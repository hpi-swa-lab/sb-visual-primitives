"
An SBDomainBlockContainer displayes the block's value as an SBDomainBlock. The code can be shown or not. If it's shown, changing the visuals will always be overwritten with the code. Otherwise changes made to the visual primitives will be saved and written back.

Instance Variables
	code:			SBBlock
	isImplicit:	Boolean
	showCode:	Boolean
	visual:		SBBlock

code
	- container for the code of the visualization

isImplicit
	- indicates whether the SBDomainBlockContainer is shown implicitly

showCode
	- indicates whether the corresponding code of the visualization should be shown

visual
	- container for the visualization of code

"
Class {
	#name : #SBDomainBlockContainer,
	#superclass : #SBStSubstitution,
	#instVars : [
		'code',
		'isImplicit',
		'showCode',
		'visual'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBDomainBlockContainer class >> code: aCode showCode: aBoolean [
	" marker "

	^ self new code: aCode asSandblock showCode: aBoolean
]

{ #category : #'as yet unclassified' }
SBDomainBlockContainer class >> matches: aBlock [

	^ ((super matches: aBlock)
		and: [aBlock receiver satisfies: #(#notNil #isBinding)]
		and: [aBlock receiver contents = self name]
		and: ['code:showCode:' = aBlock selector]) or: [{'showAsDomainBlock'} includes: aBlock selector]
]

{ #category : #'as yet unclassified' }
SBDomainBlockContainer class >> newFor: aBlock [

	aBlock arguments size >= 2
		ifTrue: [^ self new code: aBlock arguments first showCode: aBlock arguments second evaluate]
		ifFalse: [
			^ self new
				code: aBlock receiver showCode: false;
				isImplicit: aBlock selector = 'showAsDomainBlock']
]

{ #category : #'as yet unclassified' }
SBDomainBlockContainer >> artefactSaved: aMethodBlock [

	self showCode
		ifTrue: [self code: self code firstSubmorph showCode: self showCode]
		ifFalse: [
			self
				code: (String streamContents: [:stream | self writeCodeOn: stream]) parseAsSandblock
				showCode: self showCode]
]

{ #category : #accessing }
SBDomainBlockContainer >> code [

	^ code
]

{ #category : #'as yet unclassified' }
SBDomainBlockContainer >> code: aCodeBlock showCode: aBoolean [

	| aSandblock |
	self code removeAllMorphs.
	self visual removeAllMorphs.
	aSandblock := aCodeBlock asSandblock.
	self code addMorphBack: aSandblock.
	self showCode: aBoolean.
	aBoolean ifFalse: [aSandblock hide].
	
	SBDomainBlock
		newFromObject: (aSandblock evaluate isBlock
			ifTrue: [aSandblock evaluate value]
			ifFalse: [aSandblock evaluate])
		in: self visual
]

{ #category : #'as yet unclassified' }
SBDomainBlockContainer >> devisualize [
	<action>
	<actionValidIf: #isImplicit>

	| replacer |
	replacer := (String streamContents: [:stream | self writeCodeOn: stream]) parseAsSandblock.
	
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
SBDomainBlockContainer >> evaluate [

	^ self code evaluate
]

{ #category : #examples }
SBDomainBlockContainer >> exampleCircleAllLabels [

	SBDomainBlockContainer
		code: [ | root n1 n2 |
			root := SBCircleAllLabelFixture new.
			root key: 'Root Rundi'.
			n1 := SBCircleAllLabelFixture new.
			n1 key: 'Rundi jr'.
			n2 := SBCircleAllLabelFixture new.
			n2 key: 'Kindkreis'.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #examples }
SBDomainBlockContainer >> exampleGameCard [

	SBDomainBlockContainer
		code: [
			SBGameCard new
				attack: 5;
				defense: 6;
				type: 'fire';
				yourself]
		showCode: true
]

{ #category : #examples }
SBDomainBlockContainer >> exampleGameCardHand [

	| c1 c2 c3 |
	SBDomainBlockContainer
		code: [
			c1 := SBGameCard new
				attack: 5;
				defense: 6;
				type: 'fire';
				yourself.
			c2 := SBGameCard new
				attack: 300;
				defense: 1;
				type: 'bug';
				yourself.
			c3 := SBGameCard new
				attack: 3;
				defense: 10;
				type: 'water';
				yourself.
			SBGameCardHand new cards: {c1. c2. c3}]
		showCode: true
]

{ #category : #examples }
SBDomainBlockContainer >> exampleRectangleTopLabel [

	SBDomainBlockContainer
		code: [ | root n1 n2 |
			root := SBRectangleTopLabelFixture new.
			root key: 'Carl-Friedrich'.
			n1 := SBRectangleTopLabelFixture new.
			n1 key: 'peter'.
			n2 := SBRectangleTopLabelFixture new.
			n2 key: 'n2'.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #examples }
SBDomainBlockContainer >> exampleSimpleCircle [

	SBDomainBlockContainer
		code: [ | root n1 n2 |
			root := SBCircleFixture new.
			root key: 'Root Rundi'.
			n1 := SBCircleFixture new.
			n1 key: 'Rundi jr'.
			n2 := SBCircleFixture new.
			n2 key: 'Kindkreis'.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #examples }
SBDomainBlockContainer >> exampleSimpleRectangle [

	SBDomainBlockContainer
		code: [ | root n1 n2 |
			root := SBDummyNode new.
			root key: 3.
			n1 := SBDummyNode new.
			n1 key: 5.
			n2 := SBDummyNode new.
			n2 key: 1.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #examples }
SBDomainBlockContainer >> exampleSimpleTomGrammar [

	SBDomainBlockContainer
		code: (SBGrammarObject new
			objectName: '';
			type: 'SEQ';
			members: {
				SBGrammarObject new
					objectName: 'aahh';
					type: 'SYMBOL';
					members: {}.
				SBGrammarObject new
					objectName: 'bbb';
					type: 'REPEAT';
					members: {
						SBGrammarObject new
							objectName: 'aahh';
							type: 'SYMBOL';
							members: {}};
					content: (SBGrammarObject new
						objectName: 'aahh';
						type: 'SYMBOL')})
		showCode: false
]

{ #category : #examples }
SBDomainBlockContainer >> exampleSpecialShape [

	SBDomainBlockContainer
		code: [ | root n1 n2 |
			root := SBSpecialShapeFixture new.
			root key: 255.
			n1 := SBSpecialShapeFixture new.
			n1 key: 100.
			n2 := SBSpecialShapeFixture new.
			n2 key: 1.
			root
				left: n1;
				right: n2.
			root]
		showCode: true
]

{ #category : #accessing }
SBDomainBlockContainer >> initialize [

	super initialize.
	self isImplicit: false.
	
	self showCode: true.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		shrinkWrap;
		changeTableLayout;
		cellInset: 6;
		addMorphBack: (visual := SBBlock new
			layoutPolicy: SBTreeLayoutPolicy new;
			shrinkWrap;
			layoutInset: 6;
			when: #reportError send: #reportError: to: self);
		addMorphBack: (code := SBColumn new)
]

{ #category : #accessing }
SBDomainBlockContainer >> isImplicit [

	^ isImplicit
]

{ #category : #accessing }
SBDomainBlockContainer >> isImplicit: aBoolean [
	"Sometimes, e.g. when using showAsDomainBlock, we implicitly show a DomainBlockContainer, which we don't want to see in the writeSourceOn:"

	isImplicit := aBoolean
]

{ #category : #accessing }
SBDomainBlockContainer >> showCode [

	^ showCode
]

{ #category : #accessing }
SBDomainBlockContainer >> showCode: aBoolean [

	showCode := aBoolean
]

{ #category : #accessing }
SBDomainBlockContainer >> tryWriteSourceOrStore: anObject on: aStream [

	(anObject respondsTo: #writeSourceOn:)
		ifTrue: [anObject writeSourceOn: aStream]
		ifFalse: [anObject storeOn: aStream]
]

{ #category : #accessing }
SBDomainBlockContainer >> visual [

	^ visual
]

{ #category : #accessing }
SBDomainBlockContainer >> writeCodeOn: aStream [

	| object |
	aStream nextPut: $(.
	object := (self visual submorphs detect: [:morph | morph isDomainBlock]) root buildObject.
	self showCode not
		ifTrue: [self tryWriteSourceOrStore: object on: aStream]
		ifFalse: [self code submorphsDo: [:morph | self tryWriteSourceOrStore: morph on: aStream]].
	aStream nextPut: $)
]

{ #category : #accessing }
SBDomainBlockContainer >> writeSourceOn: aStream [

	self isImplicit
		ifTrue: [
			aStream nextPut: $(.
			self writeCodeOn: aStream.
			aStream nextPutAll: ') showAsDomainBlock']
		ifFalse: [
			aStream nextPutAll: '(SBDomainBlockContainer code: '.
			self writeCodeOn: aStream.
			aStream nextPutAll: ' showCode: '.
			self showCode storeOn: aStream.
			aStream nextPut: $)]
]
