"
Visualizes the return value of the code block.
"
Class {
	#name : #SBVPVisualizer,
	#superclass : #SBStSubstitution,
	#instVars : [
		'visual',
		'code'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPVisualizer class >> code: aCode extent: aPoint [
	" marker "

	
]

{ #category : #'as yet unclassified' }
SBVPVisualizer class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	Transcript showln: 'Matches called'.
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [aBlock selector = 'code:extent:']
]

{ #category : #'as yet unclassified' }
SBVPVisualizer class >> newFor: aBlock [

	^ self new code: aBlock arguments first extent: aBlock arguments second contents
]

{ #category : #accessing }
SBVPVisualizer >> code [

	^ code
]

{ #category : #accessing }
SBVPVisualizer >> code: anObject [

	code := anObject
]

{ #category : #accessing }
SBVPVisualizer >> code: aCodeBlock extent: aPoint [

	| aSandblock |
	aSandblock := aCodeBlock asSandblock.
	self code addMorphBack: aSandblock.
	aSandblock evaluate value asVisualPrimitiveIn: self visual.
	self visual extent: aPoint
]

{ #category : #accessing }
SBVPVisualizer >> example [

	SBVPVisualizer
		code: [ | root n1 n2 |
			root := SBVPDummyNode new.
			root key: 'Carl-Friedrich'.
			n1 := SBVPDummyNode new.
			n1 key: 'peter'.
			n2 := SBVPDummyNode new.
			n2 key: 'n2'.
			root
				left: n1;
				right: n2.
			root]
		extent: 300 @ 300
]

{ #category : #accessing }
SBVPVisualizer >> initialize [

	super initialize.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6;
		addMorphBack: (TransformMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addMorph: (visual := SBSandboxPasteUpMorph new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				when: #reportError send: #reportError: to: self));
		addMorphBack: (code := SBColumn new layoutInset: 0)
]

{ #category : #accessing }
SBVPVisualizer >> visual [

	^ visual
]

{ #category : #accessing }
SBVPVisualizer >> visual: anObject [

	visual := anObject
]

{ #category : #accessing }
SBVPVisualizer >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPVisualizer code: '.
	self code submorphsDo: [:morph | morph writeSourceOn: aStream].
	aStream nextPutAll: ' extent: '.
	visual extent storeOn: aStream.
	aStream nextPut: $)
	"reload."
]
