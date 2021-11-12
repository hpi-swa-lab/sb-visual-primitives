Class {
	#name : #SBVPGroupPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'patterns',
		'row'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> matches: aBlock [

	^ self selector: #patterns: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> newFor: aBlock [

	^ self new patternBlocks: (aBlock arguments first childSandblocks collect: [:arg | self applySubstitution: arg])
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> patterns: aCollection [

	^ self new patterns: aCollection
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> getNext: aVisualPrimitive [

	self patterns do: [:pattern |
		(pattern getNext: aVisualPrimitive)
			ifFalse: [pattern reset]
			ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> initialize [

	super initialize.
	self removeAllMorphs.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6;
		addMorphBack: (row := SBRow new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap).

]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self patterns allSatisfy: [:pattern | pattern matches: aVisualPrimitive withBinding: aCollection]
]

{ #category : #accessing }
SBVPGroupPattern >> patternBlocks: aCollection [

	patterns := aCollection.
	self row removeAllMorphs.
	self patterns do: [:aBlock | self row addMorphBack: aBlock] separatedBy: [self row addMorphBack: (SBTextBubble new contents: ' and '; yourself)]
]

{ #category : #accessing }
SBVPGroupPattern >> patterns [

	^ patterns
]

{ #category : #accessing }
SBVPGroupPattern >> patterns: aCollection [

	patterns := aCollection.
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> reset [

	self patterns do: [:pattern | pattern reset]
]

{ #category : #accessing }
SBVPGroupPattern >> row [

	^ row
]

{ #category : #accessing }
SBVPGroupPattern >> row: anObject [

	row := anObject.
]

{ #category : #accessing }
SBVPGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ self patterns allSatisfy: [:pattern | pattern setBindingFor: aVisualPrimitive in: aCollection]
]
