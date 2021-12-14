Class {
	#name : #SBVisualPrimitive,
	#superclass : #SBStSubstitution,
	#instVars : [
		'innerLabel',
		'shape',
		'shapeBlock',
		'innerLabelColor',
		'topRightLabel',
		'topRightLabelBlock',
		'connections',
		'bottomCenterLabel',
		'bottomCenterLabelBlock',
		'bottomLeftLabel',
		'bottomLeftLabelBlock',
		'bottomRightLabel',
		'bottomRightLabelBlock',
		'rightLabel',
		'rightLabelBlock',
		'topCenterLabel',
		'topCenterLabelBlock',
		'topLeftLabel',
		'topLeftLabelBlock',
		'leftLabelBlock',
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

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> addToWorld: aWorld [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> asVisualPrimitive [

	^ self
]

{ #category : #accessing }
SBVisualPrimitive >> bottomCenterLabel [

	^ bottomCenterLabel
]

{ #category : #accessing }
SBVisualPrimitive >> bottomCenterLabel: aMorph [

	bottomCenterLabel := aMorph.
	self bottomCenterLabelBlock removeAllMorphs.
	self bottomCenterLabelBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> bottomCenterLabelBlock [

	^ bottomCenterLabelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> bottomCenterLabelBlock: anObject [

	bottomCenterLabelBlock := anObject
]

{ #category : #accessing }
SBVisualPrimitive >> bottomLeftLabel [

	^ bottomLeftLabel
]

{ #category : #accessing }
SBVisualPrimitive >> bottomLeftLabel: aMorph [

	bottomLeftLabel := aMorph.
	self bottomLeftLabelBlock removeAllMorphs.
	self bottomLeftLabelBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> bottomLeftLabelBlock [

	^ bottomLeftLabelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> bottomLeftLabelBlock: anObject [

	bottomLeftLabelBlock := anObject
]

{ #category : #accessing }
SBVisualPrimitive >> bottomRightLabel [

	^ bottomRightLabel
]

{ #category : #accessing }
SBVisualPrimitive >> bottomRightLabel: aMorph [

	bottomRightLabel := aMorph.
	self bottomRightLabelBlock removeAllMorphs.
	self bottomRightLabelBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> bottomRightLabelBlock [

	^ bottomRightLabelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> bottomRightLabelBlock: anObject [

	bottomRightLabelBlock := anObject
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

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> initialize [

	super initialize.
	self initializeLabelBlocks.
	self shape: CircleMorph.
	self
		addAllMorphs: {
			SBRow new addAllMorphs: {topLeftLabelBlock. topCenterLabelBlock. topRightLabelBlock}.
			SBRow new addAllMorphs: {leftLabelBlock. shapeBlock. rightLabelBlock}.
			SBRow new addAllMorphs: {bottomLeftLabelBlock. bottomCenterLabelBlock. bottomRightLabelBlock}};
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		connections: OrderedCollection new;
		color: Color transparent
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> initializeLabelBlocks [

	topLeftLabelBlock := SBColumn new.
	topCenterLabelBlock := SBColumn new.
	topRightLabelBlock := SBColumn new.
	leftLabelBlock := SBColumn new.
	shapeBlock := SBColumn new.
	rightLabelBlock := SBColumn new.
	bottomLeftLabelBlock := SBColumn new.
	bottomCenterLabelBlock := SBColumn new.
	bottomRightLabelBlock := SBColumn new.
	innerLabel := SBTextBubble new contents: ''
]

{ #category : #accessing }
SBVisualPrimitive >> innerLabel [

	^ innerLabel
]

{ #category : #accessing }
SBVisualPrimitive >> innerLabel: aMorph [

	| shapeMorph |
	innerLabel := aMorph.
	shapeBlock removeAllMorphs.
	shapeBlock addMorphBack: (shapeMorph := shape new
		hResizing: #shrinkWrap).
	shapeMorph addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> innerLabelColor [

	^ innerLabelColor
]

{ #category : #accessing }
SBVisualPrimitive >> innerLabelColor: aColor [

	innerLabelColor := aColor
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
SBVisualPrimitive >> leftLabel [

	^ leftLabel
]

{ #category : #accessing }
SBVisualPrimitive >> leftLabel: aMorph [

	leftLabel := aMorph.
	self leftLabelBlock removeAllMorphs.
	self leftLabelBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> leftLabelBlock [

	^ leftLabelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> leftLabelBlock: anObject [

	leftLabelBlock := anObject
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
SBVisualPrimitive >> rightLabel [

	^ rightLabel
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> rightLabel: aMorph [

	rightLabel := aMorph.
	self rightLabelBlock removeAllMorphs.
	self rightLabelBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> rightLabelBlock [

	^ rightLabelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> rightLabelBlock: anObject [

	rightLabelBlock := anObject
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

	shape := aClass.
	
	shapeBlock removeAllMorphs.
	shapeBlock addMorphBack: (aClass new
		addMorphBack: self innerLabel;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap)
]

{ #category : #accessing }
SBVisualPrimitive >> shapeBlock [

	^ shapeBlock
]

{ #category : #accessing }
SBVisualPrimitive >> shapeBlock: anObject [

	shapeBlock := anObject
]

{ #category : #accessing }
SBVisualPrimitive >> topCenterLabel [

	^ topCenterLabel
]

{ #category : #accessing }
SBVisualPrimitive >> topCenterLabel: aMorph [

	topCenterLabel := aMorph.
	self topCenterLabelBlock removeAllMorphs.
	self topCenterLabelBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> topCenterLabelBlock [

	^ topCenterLabelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> topCenterLabelBlock: anObject [

	topCenterLabelBlock := anObject
]

{ #category : #accessing }
SBVisualPrimitive >> topLeftLabel [

	^ topLeftLabel
]

{ #category : #accessing }
SBVisualPrimitive >> topLeftLabel: aMorph [

	topLeftLabel := aMorph.
	self topLeftLabelBlock removeAllMorphs.
	self topLeftLabelBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> topLeftLabelBlock [

	^ topLeftLabelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> topLeftLabelBlock: anObject [

	topLeftLabelBlock := anObject
]

{ #category : #accessing }
SBVisualPrimitive >> topRightLabel [

	^ topRightLabel
]

{ #category : #accessing }
SBVisualPrimitive >> topRightLabel: aMorph [

	topRightLabel := aMorph.
	self topRightLabelBlock removeAllMorphs.
	self topRightLabelBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVisualPrimitive >> topRightLabelBlock [

	^ topRightLabelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> topRightLabelBlock: anObject [

	topRightLabelBlock := anObject
]
