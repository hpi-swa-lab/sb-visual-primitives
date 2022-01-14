"
Visualizes the return value of the code block.
"
Class {
	#name : #SBVPVisualizer,
	#superclass : #SBStSubstitution,
	#instVars : [
		'visual',
		'code',
		'showCode',
		'isImplicit'
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
	^ ((aBlock receiver satisfies: #(#notNil #isBinding)) and: [aBlock receiver contents = self name and: ['code:showCode:' = aBlock selector]]) or: [{'showAsVisualPrimitive'} includes: aBlock selector]
]

{ #category : #'as yet unclassified' }
SBVPVisualizer class >> newFor: aBlock [

	aBlock arguments size >= 2
		ifTrue: [^ self new code: aBlock arguments first showCode: aBlock arguments second evaluate]
		ifFalse: [
			^ self new
				code: aBlock receiver showCode: false;
				isImplicit: aBlock selector = 'showAsVisualPrimitive']
]

{ #category : #'as yet unclassified' }
SBVPVisualizer >> artefactSaved: aMethodBlock [

	self code: self code firstSubmorph showCode: self showCode
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

	| aSandblock vp |
	self code removeAllMorphs.
	self visual removeAllMorphs.
	aSandblock := aCodeBlock asSandblock.
	self code addMorphBack: aSandblock.
	self showCode: aBoolean.
	aBoolean ifFalse: [aSandblock hide].
	vp := SBVisualPrimitive newFromObject: aSandblock evaluate value in: self visual.
	vp attachTreeDecorator.
	vp withDecorator: SBTreeDecorator do: [:dec | dec layout]
]

{ #category : #accessing }
SBVPVisualizer >> evaluate [

	^ self code evaluate
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
	self isImplicit: false.
	
	self showCode: true.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		cellInset: 6;
		addMorphBack: (SBRow new
			addMorphBack: (visual := SBBlock new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				layoutInset: 6;
				when: #reportError send: #reportError: to: self);
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap);
		addMorphBack: (code := SBColumn new)
]

{ #category : #accessing }
SBVPVisualizer >> isImplicit [

	^ isImplicit
]

{ #category : #accessing }
SBVPVisualizer >> isImplicit: aBoolean [
	"Sometimes, e.g. when using showAsVisualPrimitive, we implicitly show a Visualizer, which we don't want to see in the writeSourceOn:"

	isImplicit := aBoolean
]

{ #category : #accessing }
SBVPVisualizer >> showCode [

	^ showCode
]

{ #category : #accessing }
SBVPVisualizer >> showCode: aBoolean [

	showCode := aBoolean
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

	^ SBVisualPrimitive newFromObject: anObject in: self visual
]

{ #category : #accessing }
SBVPVisualizer >> writeSourceOn: aStream [

	self isImplicit
		ifTrue: [
			self code submorphsDo: [:morph | morph writeSourceOn: aStream].
			aStream nextPutAll: ' showAsVisualPrimitive']
		ifFalse: [
			aStream nextPutAll: '(SBVPVisualizer code: '.
			self code submorphsDo: [:morph | morph writeSourceOn: aStream].
			aStream nextPutAll: ' showCode: '.
			self showCode storeOn: aStream.
			aStream nextPut: $)]
]
