Class {
	#name : #SBVisualPrimitive,
	#superclass : #SBStSubstitution,
	#instVars : [
		'labelDict',
		'blockDict',
		'shape',
		'connections',
		'parent',
		'origin'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> buildTree: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(self new: element key) connections: (self buildTree: element value)]
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
	vp origin: anObject.
	vp addPropertyMappings: anObject visualPrimitiveMapping.
	^ vp
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> newFromObject: anObject in: aMorph [

	| vp |
	vp := self new.
	aMorph addMorphBack: vp.
	vp origin: anObject.
	vp addPropertyMappings: anObject visualPrimitiveMapping.
	^ vp
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #accessing }
SBVisualPrimitive >> addConnection: aVisualPrimitive [

	self addConnection: aVisualPrimitive afterIndex: self connections size
]

{ #category : #accessing }
SBVisualPrimitive >> addConnection: aVisualPrimitive afterIndex: aNumber [

	self connections add: aVisualPrimitive afterIndex: aNumber.
	aVisualPrimitive parent: self
]

{ #category : #accessing }
SBVisualPrimitive >> addPropertyMapping: anSBVPPropertyMapping [

	| value propertyMapping child |
	propertyMapping := anSBVPPropertyMapping.
	anSBVPPropertyMapping isPropertyMapping ifFalse: [
		propertyMapping := anSBVPPropertyMapping value propertyMappingClass
			fromAssociation: anSBVPPropertyMapping
			for: self origin].
	value := propertyMapping getter value.
	self labelDict at: propertyMapping position put: value.
	
	propertyMapping position
		caseOf: {
			[#shape] -> [self shape: value].
			[#innerLabel] -> [self innerLabel: propertyMapping getMorph].
			[#connections] -> [
				self connections: OrderedCollection new.
				value do: [:connection |
					child := self owner
						ifNil: [connection asVisualPrimitive]
						ifNotNil: [SBVisualPrimitive newFromObject: connection in: self owner].
					self addConnection: child]]}
		otherwise: [
			(self labelPositions includes: propertyMapping position) ifTrue: [
				(self blockDict at: propertyMapping position)
					removeAllMorphs;
					addMorphBack: propertyMapping getMorph
				"self setLabelAt: propertyMapping position to: value"]]
]

{ #category : #accessing }
SBVisualPrimitive >> addPropertyMappings: aCollection [

	aCollection do: [:mappingEntry | self addPropertyMapping: mappingEntry]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> addToWorld: aWorld [

	^ self subclassResponsibility
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
				do: [:parentDecorator | parentDecorator addChild: decorator afterIndex: self siblingIndex - 1]]].
	
	self connections do: [:child | child attachTreeDecorator]
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
SBVisualPrimitive >> bottomLabelPositions [

	^ {#bottomLeftLabel. #bottomCenterLabel. #bottomRightLabel}
]

{ #category : #accessing }
SBVisualPrimitive >> connections [

	^ connections
]

{ #category : #accessing }
SBVisualPrimitive >> connections: aCollection [

	connections := aCollection asOrderedCollection.
	connections do: [:child | child parent: self]
]

{ #category : #accessing }
SBVisualPrimitive >> getLabelContents: anObject [

	^ (anObject isString or: [anObject isNumber])
		ifTrue: [anObject]
		ifFalse: [anObject firstSubmorph contents]
]

{ #category : #accessing }
SBVisualPrimitive >> getLabelMorph: anObject [

	^ (anObject isString or: [anObject isNumber])
		ifTrue: [SBTextBubble new contents: anObject asString]
		ifFalse: [anObject]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> getObjectFromVisualPrimitive [

	| anObject |
	anObject := self origin copy.
	anObject visualPrimitiveMapping do: [:propertyMapping |
		(propertyMapping isPropertyMapping
			ifFalse: [SBVPPropertyMapping fromAssociation: propertyMapping for: anObject]
			ifTrue: [propertyMapping]) setter value: self].
	
	^ anObject
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> initialize [

	super initialize.
	
	self
		blockDict: Dictionary new;
		labelDict: Dictionary new;
		initializeLabelBlocks;
		shape: CircleMorph.
	
	self
		addAllMorphs: {
			SBRow new addAllMorphs: (self topLabelPositions collect: [:position | self blockDict at: position]).
			SBRow new addAllMorphs: (self middleLabelPositions collect: [:position | self blockDict at: position]).
			SBRow new addAllMorphs: (self bottomLabelPositions collect: [:position | self blockDict at: position])};
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		connections: OrderedCollection new;
		color: Color transparent
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> initializeLabelBlocks [

	self labelPositions do: [:labelPosition |
		self blockDict at: labelPosition put: (SBColumn new
			changeTableLayout;
			vResizing: #shrinkWrap;
			hResizing: #shrinkWrap;
			yourself)]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> innerLabel [

	^ (self blockDict at: #innerLabel) firstSubmorphOrNil firstSubmorphOrNil
]

{ #category : #accessing }
SBVisualPrimitive >> innerLabel: aMorph [

	| morph |
	(self blockDict at: #innerLabel)
		removeAllMorphs;
		addMorphBack: (morph := shape new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap).
	self labelDict at: #innerLabel put: (self getLabelContents: aMorph).
	morph addMorphBack: aMorph
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

	^ self labelDict at: #innerLabel ifAbsent: nil
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
		ifAbsent: [self connections do: [:connection | connection layout]]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> middleLabelPositions [

	^ {#leftLabel. #innerLabel. #rightLabel}
]

{ #category : #accessing }
SBVisualPrimitive >> origin [

	^ origin
]

{ #category : #accessing }
SBVisualPrimitive >> origin: anObject [

	origin := anObject
]

{ #category : #accessing }
SBVisualPrimitive >> parent [

	^ parent
]

{ #category : #accessing }
SBVisualPrimitive >> parent: anObject [

	parent := anObject
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

	aSymbol = #innerLabel ifTrue: [^ self innerLabel contents].
	(self labelPositions includes: aSymbol) ifTrue: [
		^ self blockDict
			at: aSymbol
			ifPresent: [:block | self getLabelContents: block]
			ifAbsent: [nil]].
	aSymbol = #connections ifTrue: [^ self connections].
	aSymbol = #shape ifTrue: [^ self shape]
]

{ #category : #accessing }
SBVisualPrimitive >> removeConnection: aVisualPrimitive [

	self withDecorator: SBTreeDecorator do: [:dec | dec removeChild: aVisualPrimitive].
	self connections remove: aVisualPrimitive.
	aVisualPrimitive parent: nil
]

{ #category : #accessing }
SBVisualPrimitive >> root [

	^ self parent ifNil: [self] ifNotNil: [self parent root]
]

{ #category : #accessing }
SBVisualPrimitive >> setLabelAt: aSymbol to: anObject [

	| morphy positionBlock |
	self halt.
	morphy := self getLabelMorph: anObject.
	positionBlock := self blockDict at: aSymbol.
	positionBlock
		removeAllMorphs;
		addMorphBack: morphy.
	^ morphy
]

{ #category : #accessing }
SBVisualPrimitive >> shape [

	^ shape
]

{ #category : #accessing }
SBVisualPrimitive >> shape: aClass [

	| innerBlockWrapper innerBlock innerLabel |
	shape := aClass.
	innerBlockWrapper := self blockDict at: #innerLabel.
	innerLabel := self innerLabel.
	innerBlockWrapper removeAllMorphs.
	innerBlock := aClass new
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap.
	innerBlockWrapper addMorphBack: innerBlock.
	innerLabel ifNotNil: [:label | innerBlock addMorphBack: label]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> siblingIndex [

	^ self parent connections indexOf: self
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> topLabelPositions [

	^ {#topLeftLabel. #topCenterLabel. #topRightLabel}
]

{ #category : #accessing }
SBVisualPrimitive >> writeBack [
	"schreibe meine aktuellen Werte in meine origin zurück"
	"geh meine attribute durch, für jedes attr:
			setter mit Ziel origin aufrufen (MutateCommand)
			"
	"erstmal nur inner label ^.^"

	| currentSetter |
	self halt.
	currentSetter := self labelDict at: #innerLabel setter.
	^ SBMutatePropertyCommand new
		target: self origin;
		selector: currentSetter;
		value: (self blockDict at: #innerLabel text)
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> writeSourceOn: aStream [

	
]
