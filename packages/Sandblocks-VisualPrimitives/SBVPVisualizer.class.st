"
Visualizes the return value of the code block.
"
Class {
	#name : #SBVPVisualizer,
	#superclass : #SBStSubstitution,
	#instVars : [
		'visual',
		'code',
		'showCode'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPVisualizer class >> code: aCode showCode: aBoolean [
	" marker "

	^ self new code: aCode asSandblock showCode: aBoolean
]

{ #category : #'as yet unclassified' }
SBVPVisualizer class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [aBlock selector = 'code:showCode:']
]

{ #category : #'as yet unclassified' }
SBVPVisualizer class >> newFor: aBlock [

	^ self new code: aBlock arguments first showCode: aBlock arguments second evaluate
]

{ #category : #'as yet unclassified' }
SBVPVisualizer >> artefactSaved: aMethodBlock [

	self code: self code firstSubmorph showCode: true
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
SBVPVisualizer >> code: aCodeBlock showCode: aBoolean [

	| aSandblock |
	self code removeAllMorphs.
	self visual removeAllMorphs.
	aSandblock := aCodeBlock asSandblock.
	self code addMorphBack: aSandblock.
	aBoolean ifFalse: [aSandblock hide].
	self visualPrimitiveFrom: aSandblock evaluate value
]

{ #category : #accessing }
SBVPVisualizer >> exampleCircleAllLabels [

	SBVPVisualizer
		code: [ | root n1 n2 |
			root := SBVPCircleAllLabelFixture new.
			root key: 'Root Rundi'.
			n1 := SBVPCircleAllLabelFixture new.
			n1 key: 'Rundi jr'.
			n2 := SBVPCircleAllLabelFixture new.
			n2 key: 'Kindkreis'.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #accessing }
SBVPVisualizer >> exampleRectangleTopLabel [

	SBVPVisualizer
		code: [ | root n1 n2 |
			root := SBVPRectangleTopLabelFixture new.
			root key: 'Carl-Friedrich'.
			n1 := SBVPRectangleTopLabelFixture new.
			n1 key: 'peter'.
			n2 := SBVPRectangleTopLabelFixture new.
			n2 key: 'n2'.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #accessing }
SBVPVisualizer >> exampleSimpleCircle [

	SBVPVisualizer
		code: [ | root n1 n2 |
			root := SBVPCircleFixture new.
			root key: 'Root Rundi'.
			n1 := SBVPCircleFixture new.
			n1 key: 'Rundi jr'.
			n2 := SBVPCircleFixture new.
			n2 key: 'Kindkreis'.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #accessing }
SBVPVisualizer >> exampleSimpleRectangle [

	SBVPVisualizer
		code: [
			[ | root n1 n2 |
				root := SBVPDummyNode new.
				root key: 'Carl-Friedrich'.
				n1 := SBVPDummyNode new.
				n1 key: 'peter'.
				n2 := SBVPDummyNode new.
				n2 key: 'n2'.
				root
					left: n1;
					right: n2.
				root]]
		showCode: true
]

{ #category : #accessing }
SBVPVisualizer >> exampleSimpleTomGrammar [

	SBVPVisualizer
		code: [ | tom |
			tom := SBVPTomGrammarObject new.
			tom
				type: 'SEQ';
				members: {
					SBVPTomGrammarObject new
						type: 'SYMBOL';
						objectName: 'aahh'.
					SBVPTomGrammarObject new
						type: 'REPEAT';
						content: (SBVPTomGrammarObject new
							type: 'SYMBOL';
							objectName: 'aahh')}.
			tom]
		showCode: true
]

{ #category : #accessing }
SBVPVisualizer >> initialize [

	super initialize.
	
	self showCode: true.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6;
		addMorphBack: (visual := SBSandboxPasteUpMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			borderColor: Color black;
			layoutInset: 6;
			when: #reportError send: #reportError: to: self);
		addMorphBack: (code := SBColumn new layoutInset: 0)
]

{ #category : #accessing }
SBVPVisualizer >> labelPositions [

	^ {
		#innerLabel.
		#topLeftLabel.
		#topCenterLabel.
		#topRightLabel.
		#rightLabel.
		#bottomRightLabel.
		#bottomCenterLabel.
		#bottomLeftLabel.
		#leftLabel}
]

{ #category : #accessing }
SBVPVisualizer >> showCode [

	^ showCode
]

{ #category : #accessing }
SBVPVisualizer >> showCode: anObject [

	showCode := anObject
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
SBVPVisualizer >> visualPrimitiveFrom: anObject [

	| vp |
	vp := SBVisualPrimitive newFromObject: anObject in: self visual.
	^ vp
]

{ #category : #accessing }
SBVPVisualizer >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPVisualizer code: '.
	self code submorphsDo: [:morph | morph writeSourceOn: aStream].
	aStream nextPutAll: ' showCode: '.
	self showCode storeOn: aStream.
	aStream nextPut: $)
]
