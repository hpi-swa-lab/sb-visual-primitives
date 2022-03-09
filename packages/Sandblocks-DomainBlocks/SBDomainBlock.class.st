"
An SBDomainBlock is the visual representation of an object. It can also be used to display various patterns. When originating from an object, this object's class domainBlockMapping will be used as a directive on how to map from object properties to properties of the visual primitive (vpProperty). 
See SBPropertyMappings for the different ways of mapping.

Instance Variables
	blockDict:		Dictionary
	children:			OrderedCollection of SBDomainBlocks
	labelDict:		Dictionary
	parent:			SBDomainBlock
	sourceObject:	Object

blockDict
	- (#blockPosition -> SBBlock)
	- stores the blocks that the labels or shape blocks are inserted into

children
	- the connected SBDomainBlocks

labelDict
	- (#labelPosition -> SBBlock)

parent
	- the parent primitive
	- also indicates the hierarchy of patterns 

sourceObject
	- the object the primitive is build for
	- may be nil if the SBDomainBlock is a pattern

"
Class {
	#name : #SBDomainBlock,
	#superclass : #SBStSubstitution,
	#instVars : [
		'blockDict',
		'children',
		'parent',
		'sourceObject'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBDomainBlock class >> buildTree: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(self new: element key) children: (self buildTree: element value)]
			ifFalse: [self new: element]]
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> matches: aBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> new: aLabel [

	^ self new label: aLabel
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> newFromObject: anObject [

	| vp |
	vp := self new.
	vp sourceObject: anObject.
	vp addPropertyMappings: anObject class domainBlockMapping.
	^ vp
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> newFromObject: anObject in: aMorph [

	| vp |
	vp := self new.
	aMorph addMorphBack: vp.
	vp sourceObject: anObject.
	vp addPropertyMappings: anObject class domainBlockMapping.
	^ vp
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> registerShortcuts: aProvider [

	aProvider
		registerShortcut: Character space do: #addNewChild;
		registerShortcut: Character space shift do: #addNewParent
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #accessing }
SBDomainBlock >> addChild: aDomainBlock [

	self addChild: aDomainBlock afterIndex: self children size
]

{ #category : #accessing }
SBDomainBlock >> addChild: aDomainBlock afterIndex: aNumber [

	aDomainBlock parent ifNotNil: [aDomainBlock parent removeChild: aDomainBlock].
	self children add: aDomainBlock afterIndex: aNumber.
	aDomainBlock parent: self
]

{ #category : #accessing }
SBDomainBlock >> addConnectorLinesIn: aMorph [

	self children do: [:child | | connector |
		connector := (SBConnectorLine connect: self align: #bottom to: child align: #top)
			connectorType: #line;
			lineWidth: 1;
			color: Color black.
		aMorph addMorphBack: connector.
		child addConnectorLinesIn: aMorph]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> addLabel [
	<action>
	<actionValidIf: #supportsLabels>

	| index notSetProperties |
	notSetProperties := self missingProperties.
	index := UIManager default chooseFrom: (notSetProperties collect: [:propertyMapping | propertyMapping name]).
	index > 0 ifTrue: [ | vpProperty newBlock |
		vpProperty := (notSetProperties at: index) vpProperty.
		self sandblockEditor do: (SBDoItCommand new
			do: [
				self setLabelAt: vpProperty to: (newBlock := self newLabelBlockAt: vpProperty).
				self afterAddLabel: newBlock.
				newBlock];
			undo: [self removeLabelAt: vpProperty])]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> addNewChild [
	<action>

	self sandblockEditor do: (SBInsertDomainBlockCommand new
		index: self owner submorphCount + 1;
		parent: self;
		container: self owner;
		morph: self buildNewInstance;
		shouldMergeWithNext: false;
		yourself)
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> addNewParent [
	<action>

	self sandblockEditor do: (SBInsertDomainBlockCommand new
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
SBDomainBlock >> addPropertyMapping: anSBPropertyMapping [

	| value propertyMapping newChild |
	propertyMapping := anSBPropertyMapping asPropertyMapping.
	value := self valueFromPropertyMapping: propertyMapping.
	
	propertyMapping vpProperty
		caseOf: {
			[#shape] -> [self shape: (propertyMapping getMorphForValue: value)].
			[#children] -> [
				self children: OrderedCollection new.
				value do: [:child |
					newChild := self owner
						ifNil: [child asDomainBlock]
						ifNotNil: [SBDomainBlock newFromObject: child in: self owner].
					self addChild: newChild]]}
		otherwise: [(self labelPositions includes: propertyMapping vpProperty) ifTrue: [(self blockDict at: propertyMapping vpProperty) addVPLabel: (propertyMapping getMorphFor: self sourceObject)]]
]

{ #category : #accessing }
SBDomainBlock >> addPropertyMappings: aCollection [

	aCollection do: [:mappingEntry | self addPropertyMapping: mappingEntry]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> addToWorld: aWorld [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> afterAddLabel: aBlock [

	
]

{ #category : #nil }
SBDomainBlock >> allChildrenDo: aBlock [

	aBlock value: self.
	self children do: [:child | child allChildrenDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> asDomainBlock [

	^ self
]

{ #category : #accessing }
SBDomainBlock >> blockDict [

	^ blockDict
]

{ #category : #accessing }
SBDomainBlock >> blockDict: aDict [

	blockDict := aDict
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> blockPositions [

	^ self topLabelPositions, self middleBlockPositions, self bottomLabelPositions
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> bottomLabelPositions [

	^ {#bottomLeftLabel. #bottomCenterLabel. #bottomRightLabel}
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> buildNewInstance [

	^ self sourceObject
		ifNotNil: [self sourceObject class new asDomainBlock]
		ifNil: [self class new]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> buildObject [

	| anObject |
	anObject := self sourceObject copy.
	anObject class domainBlockMapping do: [:propertyMapping |
		(propertyMapping isPropertyMapping
			ifFalse: [SBPropertyMapping fromAssociation: propertyMapping]
			ifTrue: [propertyMapping]) setter
			value: anObject
			value: self].
	
	^ anObject
]

{ #category : #nil }
SBDomainBlock >> centerChild [

	^ self children ifEmpty: [nil] ifNotEmpty: [self children at: self children size + 1 / 2]
]

{ #category : #accessing }
SBDomainBlock >> children [

	^ children
]

{ #category : #accessing }
SBDomainBlock >> children: aCollection [

	children := aCollection asOrderedCollection.
	children do: [:child | child parent: self]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> constantSuggestionsFor: aSBUnknownLabel [

	| aVPProperty suggestionConstant constantString suggestionConstantBlock |
	aVPProperty := self labelPositionOf: aSBUnknownLabel.
	suggestionConstant := self suggestionConstantAt: aVPProperty.
	suggestionConstantBlock := self suggestionConstantBlockAt: aVPProperty.
	constantString := String streamContents: [:stream |
		stream
			nextPut: $[;
			store: suggestionConstant;
			nextPut: $]].
	^ (SBBlockSuggestionItem selector: constantString label: 'constant') builder: [suggestionConstantBlock]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> defaultShape [

	^ CircleMorph new layoutInset: 4
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> deleteBlock [

	self sandblockEditor do: (SBDeleteDomainBlockCommand new
		target: self;
		yourself)
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> domainBlockMappings [

	^ self sourceObject class domainBlockMapping collect: [:mappingOrAssoc |
		mappingOrAssoc isPropertyMapping
			ifTrue: [mappingOrAssoc]
			ifFalse: [SBPropertyMapping fromAssociation: mappingOrAssoc]]
]

{ #category : #accessing }
SBDomainBlock >> getLabelMorph: anObject [

	^ (anObject isString or: [anObject isNumber])
		ifTrue: [SBTextBubble new contents: anObject asString]
		ifFalse: [anObject]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> initialize [

	super initialize.
	
	self
		blockDict: Dictionary new;
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
SBDomainBlock >> initializeLabelBlocks [

	self blockPositions do: [:blockPosition |
		self blockDict at: blockPosition put: (SBColumn new
			changeTableLayout;
			vResizing: #shrinkWrap;
			hResizing: #spaceFill;
			wrapCentering: #center;
			yourself)]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> innerLabel [

	^ (self blockDict at: #innerLabel ifAbsent: [nil]) firstSubmorphOrNil
]

{ #category : #accessing }
SBDomainBlock >> innerLabel: aMorph [

	self shape
		removeAllMorphs;
		addMorphBack: aMorph
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> isDomainBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> isTreeLayoutRoot [

	^ self parent isNil
]

{ #category : #accessing }
SBDomainBlock >> label [

	^ self innerLabel ifNotNil: [:label | label contents] ifNil: [nil]
]

{ #category : #accessing }
SBDomainBlock >> label: anObject [

	^ self innerLabel: (SBTextBubble new contents: anObject asString)
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> labelContentAt: aSymbol [

	^ (self blockDict at: aSymbol) firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> labelPositionOf: aMorph [

	self blockDict keysAndValuesDo: [:position :block | (aMorph hasOwner: block) ifTrue: [^ position]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> labelPositions [

	^ self topLabelPositions, self middleLabelPositions, self bottomLabelPositions
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> labelSuggestionsFor: aSBUnknownLabel [

	^ {self constantSuggestionsFor: aSBUnknownLabel}
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> layoutInset [

	^ 0
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> leftSibling [

	| index |
	self parent ifNil: [^ nil].
	index := self parent children indexOf: self.
	^ index > 1 ifTrue: [self parent children at: index - 1]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> middleBlockPositions [

	^ {#leftLabel. #shape. #rightLabel}
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> middleLabelPositions [

	^ {#leftLabel. #innerLabel. #rightLabel}
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> missingProperties [

	^ self domainBlockMappings select: [:mapping |
		(self labelPositions includes: mapping vpProperty)
			ifTrue: [
				(self blockDict
					at: mapping vpProperty
					ifPresent: [:block | block firstSubmorphOrNil]
					ifAbsent: [nil]) isNil]
			ifFalse: [false]]
]

{ #category : #accessing }
SBDomainBlock >> morphAt: aSymbol [

	(self labelPositions includes: aSymbol) ifTrue: [^ self blockDict at: aSymbol ifPresent: [:block | block firstSubmorphOrNil] ifAbsent: [nil]].
	aSymbol = #children ifTrue: [^ self children].
	aSymbol = #shape ifTrue: [^ self shape]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> moveCursorDown [
	<action>

	self floating
		ifTrue: [self centerChild ifNotNil: #select ifNil: [self selectBottomToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorDown]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> moveCursorLeft [
	<action>

	self floating
		ifTrue: [self leftSibling ifNotNil: #select ifNil: [self selectLeftToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorLeft]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> moveCursorRight [
	<action>

	self floating
		ifTrue: [self rightSibling ifNotNil: #select ifNil: [self selectRightToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorRight]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> moveCursorUp [
	<action>

	self floating
		ifTrue: [self parent ifNotNil: #select ifNil: [self selectTopToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorUp]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> newLabelBlockAt: aVPProperty [

	^ self suggestionConstantBlockAt: aVPProperty
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> newUnknown [

	^ SBUnknownLabel new grammarHandler: SBStGrammarHandler new
]

{ #category : #accessing }
SBDomainBlock >> objectInterface [

	^ self parent objectInterfaceNear: self at: #replace
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> objectInterfaceNear: aBlock at: aSymbol [

	^ {[:o | o isKindOf: SBDomainBlock]}
]

{ #category : #accessing }
SBDomainBlock >> parent [

	^ parent
]

{ #category : #accessing }
SBDomainBlock >> parent: aDomainBlock [

	parent := aDomainBlock
]

{ #category : #accessing }
SBDomainBlock >> parentCase [

	^ nil
]

{ #category : #accessing }
SBDomainBlock >> parentQuery [

	^ nil
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> pasteReplace [
	<action>

	| position editor |
	editor := self sandblockEditor.
	position := editor cursor cursorPosition.
	editor
		copyBufferForContext: ((position isKindOf: SBCursorInsert)
			ifTrue: [position objectInterface]
			ifFalse: [self objectInterface])
		reversed: ((position isKindOf: SBCursorInsert) and: [position adjacent notNil])
		do: [:block :index :isLast |
			(position isKindOf: SBCursorInsert)
				ifTrue: [
					editor do: ((position container
						insertCommandRequest: block
						near: position adjacent
						before: position before) shouldMergeWithNext: isLast not)]
				ifFalse: [
					index = 1 ifTrue: [
						editor do: (SBCombinedCommand newWith: {
							SBDeleteDomainBlockCommand new target: self.
							SBInsertDomainBlockCommand new
								index: self owner submorphCount + 1;
								parent: self parent;
								container: self owner;
								siblingIndex: self siblingIndex;
								morph: block;
								shouldMergeWithNext: false;
								yourself})]]]
		ifWrappingDo: [:block | self wrapSelectionWith: block]
]

{ #category : #accessing }
SBDomainBlock >> patternContainer [

	^ nil
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> prefersNoBorder [

	^ true
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' innerLabel: ';
		nextPutAll: self label asString
]

{ #category : #accessing }
SBDomainBlock >> propertyAt: aSymbol [

	(self labelPositions includes: aSymbol) ifTrue: [
		^ self blockDict
			at: aSymbol
			ifPresent: [:block | (self vpMappingAt: aSymbol) getLabelContents: block]
			ifAbsent: [nil]].
	aSymbol = #children ifTrue: [^ self children collect: #buildObject].
	aSymbol = #shape ifTrue: [^ self shape]
]

{ #category : #accessing }
SBDomainBlock >> removeChild: aDomainBlock [

	self children remove: aDomainBlock.
	aDomainBlock parent: nil
]

{ #category : #accessing }
SBDomainBlock >> removeLabelAt: aSymbol [

	(self blockDict at: aSymbol) removeAllMorphs
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> rightSibling [

	| index |
	self parent ifNil: [^ nil].
		index := parent children indexOf: self.
		index < parent children size ifTrue: [parent children at: index + 1]
]

{ #category : #accessing }
SBDomainBlock >> root [

	^ self parent ifNil: [self] ifNotNil: [self parent root]
]

{ #category : #accessing }
SBDomainBlock >> setLabelAt: aSymbol to: anObject [

	| morphy positionBlock |
	morphy := self getLabelMorph: anObject.
	positionBlock := self blockDict at: aSymbol.
	positionBlock
		removeAllMorphs;
		addMorphBack: morphy.
	^ morphy
]

{ #category : #accessing }
SBDomainBlock >> shape [

	^ (self blockDict at: #shape) firstSubmorphOrNil
]

{ #category : #accessing }
SBDomainBlock >> shape: aMorph [

	| innerBlockWrapper innerBlock innerLabel |
	aMorph layoutPolicy ifNil: [
		aMorph
			changeTableLayout;
			listCentering: #center;
			wrapCentering: #center;
			shrinkWrap].
	innerBlockWrapper := self blockDict at: #shape.
	innerLabel := self innerLabel.
	self blockDict at: #innerLabel put: aMorph.
	innerBlockWrapper removeAllMorphs.
	innerBlock := aMorph.
	innerBlockWrapper addMorphBack: innerBlock.
	innerLabel ifNotNil: [:label | innerBlock addVPLabel: label]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> siblingIndex [

	^ self parent ifNil: [0] ifNotNil: [self parent children indexOf: self]
]

{ #category : #accessing }
SBDomainBlock >> sourceObject [

	^ sourceObject
]

{ #category : #accessing }
SBDomainBlock >> sourceObject: anObject [

	sourceObject := anObject
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> suggestionConstantAt: aVPProperty [

	| aSBPropertyMapping |
	aSBPropertyMapping := self vpMappingAt: aVPProperty.
	^ aSBPropertyMapping ifNotNil: #suggestionConstant ifNil: [#a]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> suggestionConstantBlockAt: aVPProperty [

	| suggestionConstant aSBPropertyMapping |
	aSBPropertyMapping := self vpMappingAt: aVPProperty.
	suggestionConstant := self suggestionConstantAt: aVPProperty.
	^ aSBPropertyMapping
		ifNotNil: [aSBPropertyMapping getMorphForValue: suggestionConstant]
		ifNil: [#a]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> supportsLabels [

	^ true
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> topLabelPositions [

	^ {#topLeftLabel. #topCenterLabel. #topRightLabel}
]

{ #category : #accessing }
SBDomainBlock >> valueFromPropertyMapping: aPropertyMapping [

	^ aPropertyMapping value: self sourceObject
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> vpMappingAt: aVPProperty [

	^ self domainBlockMappings
		detect: [:mapping | mapping key = aVPProperty]
		ifFound: [:mapping | mapping asPropertyMapping]
		ifNone: [nil]
]

{ #category : #'as yet unclassified' }
SBDomainBlock >> writeSourceOn: aStream [

	
]
