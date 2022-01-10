Class {
	#name : #SBVPGroupPattern,
	#superclass : #SBVPPattern,
	#instVars : [
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

	self connections do: [:pattern | pattern addImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> buildFromBinding: anArray [

	^ self connections first buildFromBinding: anArray
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> buildImplicitChildren: anArray [

	self connections do: [:pattern | pattern buildImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> findConstant [

	self connections do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> getNext: aVisualPrimitive [

	self connections do: [:pattern |
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
		layoutInset: 4;
		addMorphBack: (row := SBRow new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			cellInset: 3;
			cellPositioning: #center)
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self connections allSatisfy: [:pattern | pattern matches: aVisualPrimitive withBinding: aCollection]
]

{ #category : #accessing }
SBVPGroupPattern >> patternBlocks: aCollection [

	| isBindingPattern |
	self connections: aCollection.
	self row removeAllMorphs.
	self connections
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
				contents: self seperatorString;
				yourself)]
]

{ #category : #accessing }
SBVPGroupPattern >> removeImplicitChildren [

	self connections do: [:child | child removeImplicitChildren]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> reset [

	self connections do: [:pattern | pattern reset]
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
SBVPGroupPattern >> seperatorString [

	^ ' and '
]

{ #category : #accessing }
SBVPGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ self connections allSatisfy: [:pattern | pattern setBindingFor: aVisualPrimitive in: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(', self class name, ' patterns: {'.
	self connections do: [:pattern |
		pattern writeSourceOn: aStream.
		aStream nextPut: $.].
	aStream nextPutAll: '})'
]
