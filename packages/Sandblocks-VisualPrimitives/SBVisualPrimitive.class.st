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
SBVisualPrimitive class >> fromVisualPrimitive: aVisualPrimitive [

	^ aVisualPrimitive
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
SBVisualPrimitive class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #accessing }
SBVisualPrimitive >> addPropertyMapping: anSBVPPropertyMapping [

	| morphy value positionBlock |
	value := anSBVPPropertyMapping getter value.
	self labelDict at: anSBVPPropertyMapping position put: anSBVPPropertyMapping.
	morphy := self getLabelMorph: value.
	positionBlock := self blockDict at: anSBVPPropertyMapping position.
	positionBlock
		removeAllMorphs;
		addMorphBack: morphy
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> addToWorld: aWorld [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> asVisualPrimitive [

	^ self
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
SBVisualPrimitive >> connections: anObject [

	connections := anObject.
	connections do: [:child | child parent: self]
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

	self labelPositions do: [:labelPosition | self blockDict at: labelPosition put: SBColumn new]
]

{ #category : #accessing }
SBVisualPrimitive >> innerLabel: anSBVPPropertyMapping [

	| shapeMorph |
	self labelDict at: #innerLabel put: anSBVPPropertyMapping.
	shapeMorph := self blockDict at: #innerLabel.
	shapeMorph removeAllMorphs.
	shapeMorph addMorphBack: (shape new
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (self getLabelMorph: (self getLabelMorph: anSBVPPropertyMapping getter value)))
]

{ #category : #accessing }
SBVisualPrimitive >> label [

	^ self innerLabel contents asInteger
]

{ #category : #accessing }
SBVisualPrimitive >> label: anObject [

	^ self innerLabel: (SBTextBubble new contents: anObject asString)
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
		nextPutAll: ' innerLabel ';
		nextPutAll: self innerLabel asString
]

{ #category : #accessing }
SBVisualPrimitive >> root [

	^ self parent ifNil: [self] ifNotNil: [self parent root]
]

{ #category : #accessing }
SBVisualPrimitive >> shape [

	^ shape
]

{ #category : #accessing }
SBVisualPrimitive >> shape: aClass [

	| innerBlockWrapper innerBlock |
	shape := aClass.
	innerBlockWrapper := self blockDict at: #innerLabel.
	innerBlockWrapper removeAllMorphs.
	innerBlock := aClass new
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap.
	self labelDict at: #innerLabel ifPresent: [:label | innerBlock addMorphBack: label].
	innerBlockWrapper addMorphBack: innerBlock
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> topLabelPositions [

	^ {#topLeftLabel. #topCenterLabel. #topRightLabel}
]
