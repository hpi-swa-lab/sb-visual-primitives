"
An SBVPVisualizer displayes the block's value as an SBVisualPrimitive. The code can be shown or not. If it's shown, changing the visuals will always be overwritten with the code. Otherwise changes made to the visual primitives will be saved and written back.
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

	self showCode
		ifTrue: [self code: self code firstSubmorph showCode: self showCode]
		ifFalse: [
			self
				code: (String streamContents: [:stream | self writeCodeOn: stream]) parseAsSandblock
				showCode: self showCode]
]

{ #category : #accessing }
SBVPVisualizer >> code [

	^ code
]

{ #category : #accessing }
SBVPVisualizer >> code: aCodeBlock [

	code := aCodeBlock
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
	
	vp := SBVisualPrimitive
		newFromObject: (aSandblock evaluate isBlock
			ifTrue: [aSandblock evaluate value]
			ifFalse: [aSandblock evaluate])
		in: self visual.
	vp attachTreeDecorator.
	vp layout
]

{ #category : #'as yet unclassified' }
SBVPVisualizer >> devisualize [
	<action>
	<actionValidIf: #isImplicit>

	| replacer |
	replacer := self code firstSubmorph.
	
	self sandblockEditor do: (SBCombinedCommand newWith: {
		SBReplaceCommand new
			target: self;
			replacer: replacer;
			yourself.
		SBDoItCommand new
			do: [replacer show];
			undo: [replacer hide]})
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
SBVPVisualizer >> exampleGameCard [

	SBVPVisualizer
		code: [
			SBVPGameCard new
				attack: 5;
				defense: 6;
				type: 'fire';
				yourself]
		showCode: true
]

{ #category : #accessing }
SBVPVisualizer >> exampleGameCardHand [

	| c1 c2 c3 |
	SBVPVisualizer
		code: [
			c1 := SBVPGameCard new
				attack: 5;
				defense: 6;
				type: 'fire';
				yourself.
			c2 := SBVPGameCard new
				attack: 300;
				defense: 1;
				type: 'bug';
				yourself.
			c3 := SBVPGameCard new
				attack: 3;
				defense: 10;
				type: 'water';
				yourself.
			SBVPGameCardHand new cards: {c1. c2. c3}]
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
		code: [ | root n1 n2 |
			root := SBVPDummyNode new.
			root key: 3.
			n1 := SBVPDummyNode new.
			n1 key: 5.
			n2 := SBVPDummyNode new.
			n2 key: 1.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #accessing }
SBVPVisualizer >> exampleSimpleTomGrammar [

	SBVPVisualizer
		code: (SBVPGrammarObject new
			objectName: '';
			type: 'SEQ';
			members: {
				SBVPGrammarObject new
					objectName: 'aahh';
					type: 'SYMBOL';
					members: {}.
				SBVPGrammarObject new
					objectName: 'bbb';
					type: 'REPEAT';
					members: {
						SBVPGrammarObject new
							objectName: 'aahh';
							type: 'SYMBOL';
							members: {}};
					content: (SBVPGrammarObject new
						objectName: 'aahh';
						type: 'SYMBOL')})
		showCode: false
]

{ #category : #accessing }
SBVPVisualizer >> exampleSpecialShape [

	SBVPVisualizer
		code: [ | root n1 n2 |
			root := SBVPSpecialShapeFixture new.
			root key: 255.
			n1 := SBVPSpecialShapeFixture new.
			n1 key: 100.
			n2 := SBVPSpecialShapeFixture new.
			n2 key: 1.
			root
				left: n1;
				right: n2.
			root]
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
		shrinkWrap;
		changeTableLayout;
		cellInset: 6;
		addMorphBack: (SBRow new
			addMorphBack: (visual := SBBlock new
				shrinkWrap;
				layoutInset: 6;
				when: #reportError send: #reportError: to: self);
			shrinkWrap);
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
SBVPVisualizer >> tryWriteSourceOrStore: anObject on: aStream [

	(anObject respondsTo: #writeSourceOn:)
		ifTrue: [anObject writeSourceOn: aStream]
		ifFalse: [anObject storeOn: aStream]
]

{ #category : #accessing }
SBVPVisualizer >> visual [

	^ visual
]

{ #category : #accessing }
SBVPVisualizer >> visualPrimitiveFrom: anObject [

	^ SBVisualPrimitive newFromObject: anObject in: self visual
]

{ #category : #accessing }
SBVPVisualizer >> writeCodeOn: aStream [

	| object |
	aStream nextPut: $(.
	object := (self visual submorphs detect: [:morph | morph isVisualPrimitive]) root buildObject.
	self showCode not
		ifTrue: [self tryWriteSourceOrStore: object on: aStream]
		ifFalse: [self code submorphsDo: [:morph | self tryWriteSourceOrStore: morph on: aStream]].
	aStream nextPut: $)
]

{ #category : #accessing }
SBVPVisualizer >> writeSourceOn: aStream [

	self isImplicit
		ifTrue: [
			aStream nextPut: $(.
			self writeCodeOn: aStream.
			aStream nextPutAll: ') showAsVisualPrimitive']
		ifFalse: [
			aStream nextPutAll: '(SBVPVisualizer code: '.
			self writeCodeOn: aStream.
			aStream nextPutAll: ' showCode: '.
			self showCode storeOn: aStream.
			aStream nextPut: $)]
]
