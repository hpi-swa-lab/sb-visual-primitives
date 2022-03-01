"
An SBVisualPrimitive is the visuall representation of an Object. It can also be used to display various patterns. When originating from an object, this object's class's visualPrimitiveMapping will be used as a directive on how to map from object properties to properties of the visual primitive (vpProperty). 
See SBVPPropertyMappings for the different ways of mapping.

Instance Variables
	blockDict:		Dictionary
	children:		OrderedCollection of SBVisualPrimitives
	labelDict:		Dictionary
	origin:			Object
	parent:			SBVisualPrimitive

blockDict
	-  (#blockPosition -> SBBlock)
	- stores the blocks that the labels or shape blocks are inserted into

children
	- the connected SBVisualPrimitives

labelDict
	- (#labelPosition -> SBBlock)

origin
	- the object the primitive is buid for
	- may be nil if the SBPrimitive is a pattern

parent
	- the parent primitive
	- also indicates the hirachy of patterns 

"
Class {
	#name : #SBVisualPrimitive,
	#superclass : #SBStSubstitution,
	#instVars : [
		'labelDict',
		'blockDict',
		'children',
		'parent',
		'origin',
		'sourceObject'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> buildTree: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(self new: element key) children: (self buildTree: element value)]
			ifFalse: [self new: element]]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> matches: aBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> new: aLabel [

	^ self new label: aLabel
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> newFromObject: anObject [

	| vp |
	vp := self new.
	vp sourceObject: anObject.
	vp addPropertyMappings: anObject class visualPrimitiveMapping.
	^ vp
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> newFromObject: anObject in: aMorph [

	| vp |
	vp := self new.
	aMorph addMorphBack: vp.
	vp sourceObject: anObject.
	vp addPropertyMappings: anObject class visualPrimitiveMapping.
	^ vp
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> registerShortcuts: aProvider [

	aProvider
		registerShortcut: Character space do: #addNewChild;
		registerShortcut: Character space shift do: #addNewParent
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #accessing }
SBVisualPrimitive >> addChild: aVisualPrimitive [

	self addChild: aVisualPrimitive afterIndex: self children size
]

{ #category : #accessing }
SBVisualPrimitive >> addChild: aVisualPrimitive afterIndex: aNumber [

	aVisualPrimitive parent ifNotNil: [aVisualPrimitive parent removeChild: aVisualPrimitive].
	self children add: aVisualPrimitive afterIndex: aNumber.
	aVisualPrimitive parent: self.
	self withDecorator: SBTreeDecorator do: [:myDecorator |
		aVisualPrimitive
			withDecorator: SBTreeDecorator
			do: [:childDecorator | myDecorator addChild: childDecorator afterIndex: aNumber]]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> addNewChild [
	<action>

	self sandblockEditor do: (SBVPInsertCommand new
		index: self owner submorphCount + 1;
		parent: self;
		container: self owner;
		morph: self buildNewInstance;
		shouldMergeWithNext: false;
		yourself)
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> addNewParent [
	<action>

	self sandblockEditor do: (SBVPInsertCommand new
		index: self owner submorphCount + 1;
		parent: self parent;
		container: self owner;
		siblingIndex: self siblingIndex;
		children: {self};
		morph: self buildNewInstance;
		shouldMergeWithNext: false;
		yourself)
]

{ #category : #accessing }
SBVisualPrimitive >> addPropertyMapping: anSBVPPropertyMapping [

	| value propertyMapping newChild |
	propertyMapping := anSBVPPropertyMapping asPropertyMapping.
	value := self valueFromPropertyMapping: propertyMapping.
	
	self labelDict at: propertyMapping vpProperty put: value.
	
	propertyMapping vpProperty
		caseOf: {
			[#shape] -> [self shape: (propertyMapping getMorphForValue: value)].
			[#children] -> [
				self children: OrderedCollection new.
				value do: [:child |
					newChild := self owner
						ifNil: [child asVisualPrimitive]
						ifNotNil: [SBVisualPrimitive newFromObject: child in: self owner].
					self addChild: newChild]]}
		otherwise: [(self labelPositions includes: propertyMapping vpProperty) ifTrue: [(self blockDict at: propertyMapping vpProperty) addVPLabel: (propertyMapping getMorphFor: self sourceObject)]]
]

{ #category : #accessing }
SBVisualPrimitive >> addPropertyMappings: aCollection [

	aCollection do: [:mappingEntry | self addPropertyMapping: mappingEntry]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> addToWorld: aWorld [

	^ self subclassResponsibility
]

{ #category : #nil }
SBVisualPrimitive >> allChildrenDo: aBlock [

	aBlock value: self.
	self children do: [:child | child allChildrenDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> asVisualPrimitive [

	^ self
]

{ #category : #nil }
SBVisualPrimitive >> attachTreeDecorator [

	self withDecorator: SBTreeDecorator do: [:d | ] ifAbsent: [ | decorator |
		decorator := SBTreeDecorator new.
		self attachDecorator: decorator.
		self parent ifNotNil: [:parent |
			parent
				withDecorator: SBTreeDecorator
				do: [:parentDecorator | parentDecorator addChild: decorator afterIndex: self siblingIndex - 1]].
		self children do: [:child |
			child
				withDecorator: SBTreeDecorator
				do: [:childDecorator | decorator addChild: childDecorator afterIndex: child siblingIndex - 1]]].
	
	self children do: [:child | child attachTreeDecorator]
]

{ #category : #accessing }
SBVisualPrimitive >> blockDict [

	^ blockDict
]

{ #category : #accessing }
SBVisualPrimitive >> blockDict: anObject [

	blockDict := anObject
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> blockPositions [

	^ self topLabelPositions, self middleBlockPositions, self bottomLabelPositions
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> bottomLabelPositions [

	^ {#bottomLeftLabel. #bottomCenterLabel. #bottomRightLabel}
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> buildNewInstance [

	^ self sourceObject
		ifNotNil: [self sourceObject class new asVisualPrimitive]
		ifNil: [self class new]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> buildObject [

	| anObject |
	anObject := self sourceObject copy.
	anObject class visualPrimitiveMapping do: [:propertyMapping |
		(propertyMapping isPropertyMapping
			ifFalse: [SBVPPropertyMapping fromAssociation: propertyMapping]
			ifTrue: [propertyMapping]) setter
			value: anObject
			value: self].
	
	^ anObject
]

{ #category : #nil }
SBVisualPrimitive >> centerChild [

	^ self children ifEmpty: [nil] ifNotEmpty: [self children at: self children size + 1 / 2]
]

{ #category : #accessing }
SBVisualPrimitive >> children [

	^ children
]

{ #category : #accessing }
SBVisualPrimitive >> children: aCollection [

	children := aCollection asOrderedCollection.
	children do: [:child | child parent: self]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> defaultShape [

	^ CircleMorph new
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> deleteBlock [

	self sandblockEditor do: (SBVPDeleteCommand new
		target: self;
		yourself)
]

{ #category : #accessing }
SBVisualPrimitive >> getLabelContents: anObject [

	^ (anObject isString or: [anObject isNumber])
		ifTrue: [anObject]
		ifFalse: [[anObject firstSubmorph contents] on: Error do: [nil]]
]

{ #category : #accessing }
SBVisualPrimitive >> getLabelMorph: anObject [

	^ (anObject isString or: [anObject isNumber])
		ifTrue: [SBTextBubble new contents: anObject asString]
		ifFalse: [anObject]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> initialize [

	super initialize.
	
	self
		blockDict: Dictionary new;
		labelDict: Dictionary new;
		initializeLabelBlocks;
		shape: self defaultShape.
	self blockDict at: #innerLabel put: self shape.
	
	self
		addAllMorphs: {
			SBRow new
				addAllMorphs: (self topLabelPositions collect: [:position | self blockDict at: position]);
				hResizing: #spaceFill.
			SBRow new
				addAllMorphs: (self middleBlockPositions collect: [:position | self blockDict at: position]);
				cellPositioning: #center;
				hResizing: #spaceFill;
				yourself.
			SBRow new
				addAllMorphs: (self bottomLabelPositions collect: [:position | self blockDict at: position]);
				hResizing: #spaceFill};
		changeTableLayout;
		shrinkWrap;
		children: OrderedCollection new;
		color: Color transparent
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> initializeLabelBlocks [

	self blockPositions do: [:blockPosition |
		self blockDict at: blockPosition put: (SBColumn new
			changeTableLayout;
			vResizing: #shrinkWrap;
			hResizing: #spaceFill;
			wrapCentering: #center;
			yourself)]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> innerLabel [

	^ (self blockDict at: #innerLabel ifAbsent: [nil]) firstSubmorphOrNil
]

{ #category : #accessing }
SBVisualPrimitive >> innerLabel: aMorph [

	self shape
		removeAllMorphs;
		addMorphBack: aMorph
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> isVisualPrimitive [

	^ true
]

{ #category : #accessing }
SBVisualPrimitive >> label [

	^ self innerLabel ifNotNil: [:label | label contents] ifNil: [nil]
]

{ #category : #accessing }
SBVisualPrimitive >> label: anObject [

	^ self innerLabel: (SBTextBubble new contents: anObject asString)
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> labelContentAt: aSymbol [

	^ (self blockDict at: aSymbol) firstSubmorph contents
]

{ #category : #accessing }
SBVisualPrimitive >> labelDict [

	^ labelDict
]

{ #category : #accessing }
SBVisualPrimitive >> labelDict: anObject [

	labelDict := anObject
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> labelPositions [

	^ self topLabelPositions, self middleLabelPositions, self bottomLabelPositions
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> layout [

	self
		withDecorator: SBTreeDecorator
		do: [:dec | dec layout]
		ifAbsent: [self children do: [:child | child layout]]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> leftSibling [

	^ self parent ifNotNil: [:parent | | index |
		index := parent children indexOf: self.
		index > 1 ifTrue: [parent children at: index - 1]]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> middleBlockPositions [

	^ {#leftLabel. #shape. #rightLabel}
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> middleLabelPositions [

	^ {#leftLabel. #innerLabel. #rightLabel}
]

{ #category : #accessing }
SBVisualPrimitive >> morphAt: aSymbol [

	(self labelPositions includes: aSymbol) ifTrue: [^ self blockDict at: aSymbol ifPresent: [:block | block firstSubmorphOrNil] ifAbsent: [nil]].
	aSymbol = #children ifTrue: [^ self children].
	aSymbol = #shape ifTrue: [^ self shape]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> moveCursorDown [
	<action>

	self floating
		ifTrue: [self centerChild ifNotNil: #select ifNil: [self selectBottomToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorDown]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> moveCursorLeft [
	<action>

	self floating
		ifTrue: [self leftSibling ifNotNil: #select ifNil: [self selectLeftToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorLeft]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> moveCursorRight [
	<action>

	self floating
		ifTrue: [self rightSibling ifNotNil: #select ifNil: [self selectRightToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorRight]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> moveCursorUp [
	<action>

	self floating
		ifTrue: [self parent ifNotNil: #select ifNil: [self selectTopToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorUp]
]

{ #category : #accessing }
SBVisualPrimitive >> parent [

	^ parent
]

{ #category : #accessing }
SBVisualPrimitive >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
SBVisualPrimitive >> parentCase [

	^ nil
]

{ #category : #accessing }
SBVisualPrimitive >> parentCaseOrQuery [

	^ nil
]

{ #category : #accessing }
SBVisualPrimitive >> parentQuery [

	^ nil
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' innerLabel: ';
		nextPutAll: self label asString
]

{ #category : #accessing }
SBVisualPrimitive >> propertyAt: aSymbol [

	(self labelPositions includes: aSymbol) ifTrue: [
		^ self blockDict
			at: aSymbol
			ifPresent: [:block | self getLabelContents: block]
			ifAbsent: [nil]].
	aSymbol = #children ifTrue: [^ self children].
	aSymbol = #shape ifTrue: [^ self shape]
]

{ #category : #accessing }
SBVisualPrimitive >> removeChild: aVisualPrimitive [

	self withDecorator: SBTreeDecorator do: [:dec | dec removeChild: aVisualPrimitive].
	self children remove: aVisualPrimitive.
	aVisualPrimitive parent: nil
]

{ #category : #accessing }
SBVisualPrimitive >> removeLabelAt: aSymbol [

	(self blockDict at: aSymbol) removeAllMorphs
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> rightSibling [

	^ self parent ifNotNil: [:parent | | index |
		index := parent children indexOf: self.
		index < parent children size ifTrue: [parent children at: index + 1]]
]

{ #category : #accessing }
SBVisualPrimitive >> root [

	^ self parent ifNil: [self] ifNotNil: [self parent root]
]

{ #category : #accessing }
SBVisualPrimitive >> setLabelAt: aSymbol to: anObject [

	| morphy positionBlock |
	morphy := self getLabelMorph: anObject.
	positionBlock := self blockDict at: aSymbol.
	positionBlock
		removeAllMorphs;
		addMorphBack: morphy.
	^ morphy
]

{ #category : #accessing }
SBVisualPrimitive >> shape [

	^ (self blockDict at: #shape) firstSubmorphOrNil
]

{ #category : #accessing }
SBVisualPrimitive >> shape: aMorph [

	| innerBlockWrapper innerBlock innerLabel |
	aMorph layoutPolicy ifNil: [
		aMorph
			changeTableLayout;
			listCentering: #center;
			wrapCentering: #center;
			shrinkWrap;
			layoutInset: 8].
	innerBlockWrapper := self blockDict at: #shape.
	innerLabel := self innerLabel.
	self blockDict at: #innerLabel put: aMorph.
	innerBlockWrapper removeAllMorphs.
	innerBlock := aMorph.
	innerBlockWrapper addMorphBack: innerBlock.
	innerLabel ifNotNil: [:label | innerBlock addVPLabel: label]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> siblingIndex [

	^ self parent ifNil: [0] ifNotNil: [self parent children indexOf: self]
]

{ #category : #accessing }
SBVisualPrimitive >> sourceObject [

	^ sourceObject
]

{ #category : #accessing }
SBVisualPrimitive >> sourceObject: anObject [

	sourceObject := anObject
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> topLabelPositions [

	^ {#topLeftLabel. #topCenterLabel. #topRightLabel}
]

{ #category : #accessing }
SBVisualPrimitive >> valueFromPropertyMapping: aPropertyMapping [

	^ aPropertyMapping value: self sourceObject
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> writeSourceOn: aStream [

	
]
