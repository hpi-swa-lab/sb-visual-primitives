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

	^ self new patternBlocks: aBlock arguments first childSandblocks
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> patterns: aCollection [

	^ self new patternBlocks: aCollection
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addImplicitChildren: anArray [

	self patterns do: [:pattern | pattern addImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> buildFromBinding: anArray [

	^ self patterns first buildFromBinding: anArray
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> buildImplicitChildren: anArray [

	self patterns do: [:pattern | pattern buildImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> findConstant [

	self patterns do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
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
SBVPGroupPattern >> highestBindingVariable [

	^ self patterns
		ifEmpty: [0]
		ifNotEmpty: [(self patterns collect: [:pattern | pattern highestBindingVariable]) max]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> initialize [

	super initialize.
	self removeAllMorphs.
	self patterns: {}.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6;
		addMorphBack: (row := SBRow new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap)
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self patterns allSatisfy: [:pattern | pattern matches: aVisualPrimitive withBinding: aCollection]
]

{ #category : #accessing }
SBVPGroupPattern >> patternBlocks: aCollection [

	| isBindingPattern |
	patterns := aCollection.
	self row removeAllMorphs.
	self patterns
		do: [:aPattern |
			isBindingPattern := SBVPBindingPattern withAllSubclasses anySatisfy: [:subclass | subclass = aPattern class].
			isBindingPattern
				ifTrue: [ | patternContainer |
					patternContainer := SBSandboxPasteUpMorph new
						hResizing: #shrinkWrap;
						vResizing: #shrinkWrap;
						borderColor: Color black;
						layoutInset: 6;
						when: #reportError send: #reportError: to: self.
					patternContainer extent: 300 @ 300.
					self row addMorphBack: (TransformMorph new
						hResizing: #shrinkWrap;
						vResizing: #shrinkWrap;
						changeTableLayout;
						addMorph: patternContainer).
					aPattern
						addToWorld: patternContainer;
						attachTreeDecorator;
						withDecorator: SBTreeDecorator do: [:treeDecorator | treeDecorator layout]]
				ifFalse: [aPattern addToWorld: self row]]
		separatedBy: [
			self row addMorphBack: (SBTextBubble new
				contents: ' and ';
				yourself)]
]

{ #category : #accessing }
SBVPGroupPattern >> patterns [

	^ patterns
]

{ #category : #accessing }
SBVPGroupPattern >> patterns: aCollection [

	patterns := aCollection
]

{ #category : #accessing }
SBVPGroupPattern >> removeImplicitChildren [

	self patterns do: [:child | child removeImplicitChildren]
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

	row := anObject
]

{ #category : #accessing }
SBVPGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ self patterns allSatisfy: [:pattern | pattern setBindingFor: aVisualPrimitive in: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPGroupPattern patterns: {'.
	self patterns do: [:pattern |
		pattern writeSourceOn: aStream.
		aStream nextPut: $.].
	aStream nextPutAll: '})'
]
