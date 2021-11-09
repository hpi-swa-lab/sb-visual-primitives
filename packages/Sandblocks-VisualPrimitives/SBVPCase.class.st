Class {
	#name : #SBVPCase,
	#superclass : #SBStSubstitution,
	#instVars : [
		'input',
		'output'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPCase class >> input: anInputVisualizer output: anOutputVisualizer [
	" marker "

	
]

{ #category : #'as yet unclassified' }
SBVPCase class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [aBlock selector = 'input:output:']
]

{ #category : #'as yet unclassified' }
SBVPCase class >> newFor: aBlock [

	^ self new input: aBlock arguments first output: aBlock arguments second
]

{ #category : #'as yet unclassified' }
SBVPCase >> example [

	SBVPCase
		input: (SBVPVisualizer
			code: [ | root n1 n2 |
				root := SBVPDummyNode new.
				root key: 'Carl-Friedrich'.
				n1 := SBVPDummyNode new.
				n1 key: 'gadaitdd'.
				
				n2 := SBVPDummyNode new.
				n2 key: 'ghlplplph'.
				root
					left: n1;
					right: n2.
				root]
			extent: 300 @ 300)
		output: (SBVPVisualizer
			code: [ | root n1 n2 |
				root := SBVPDummyNode new.
				root key: 'Carl-Friedrich'.
				n1 := SBVPDummyNode new.
				n1 key: 'n1'.
				n2 := SBVPDummyNode new.
				n2 key: 'n2'.
				root
					left: n1;
					right: n2.
				root]
			extent: 300 @ 300)
]

{ #category : #'as yet unclassified' }
SBVPCase >> initialize [

	super initialize.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6
]

{ #category : #accessing }
SBVPCase >> input [

	^ input
]

{ #category : #accessing }
SBVPCase >> input: anObject [

	input := anObject
]

{ #category : #'as yet unclassified' }
SBVPCase >> input: anInputVisualizer output: anOutputVisualizer [

	self addMorph: (SBRow new
		addMorphBack: anInputVisualizer;
		addMorphBack: SBIcon iconArrowRight;
		addMorphBack: anOutputVisualizer);
		input: anInputVisualizer;
		output: anOutputVisualizer
]

{ #category : #accessing }
SBVPCase >> output [

	^ output
]

{ #category : #accessing }
SBVPCase >> output: anObject [

	output := anObject
]

{ #category : #'as yet unclassified' }
SBVPCase >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPCase input: '.
	self input writeSourceOn: aStream.
	aStream nextPutAll: ' output: '.
	self output writeSourceOn: aStream.
	aStream nextPut: $).
	self reloadArtefact
]
