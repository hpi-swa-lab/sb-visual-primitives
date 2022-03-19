"
An SBDomainBlockContainer displayes the block's value as an SBDomainBlock. The code can be shown or not. If it's shown, changing the visuals will always be overwritten with the code. Otherwise changes made to the domain block will be saved and written back.

Instance Variables
	isImplicit:	Boolean

isImplicit
	- indicates whether the SBDomainBlockContainer is shown implicitly

"
Class {
	#name : #SBDomainBlockContainer,
	#superclass : #SBStSubstitution,
	#instVars : [
		'isImplicit'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBDomainBlockContainer class >> code: anObject [
	" marker "

	^ self new code: anObject asSandblock
]

{ #category : #'as yet unclassified' }
SBDomainBlockContainer class >> matches: aBlock [

	^ ((super matches: aBlock)
		and: [aBlock receiver satisfies: #(#notNil #isBinding)]
		and: [aBlock receiver contents = self name]
		and: ['code:' = aBlock selector]) or: [{'showAsDomainBlock'} includes: aBlock selector]
]

{ #category : #'as yet unclassified' }
SBDomainBlockContainer class >> newFor: aBlock [

	^ aBlock arguments size >= 1
		ifTrue: [self new code: aBlock arguments first]
		ifFalse: [
			self new
				code: aBlock receiver;
				isImplicit: aBlock selector = 'showAsDomainBlock']
]

{ #category : #'as yet unclassified' }
SBDomainBlockContainer class >> visualize: aDomainBlock [
	" marker "

	^ self new visualize: aDomainBlock
]

{ #category : #callbacks }
SBDomainBlockContainer >> artefactSaved: aMethodBlock [

	self code: (String streamContents: [:stream | self writeCodeOn: stream]) parseAsSandblock
]

{ #category : #visualization }
SBDomainBlockContainer >> code: aCodeBlock [

	| result |
	result := aCodeBlock asSandblock evaluate.
	
	self visualize: (SBDomainBlock newFromObject: (result isBlock ifTrue: [result value] ifFalse: [result]))
]

{ #category : #visualization }
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

{ #category : #examples }
SBDomainBlockContainer >> exampleCircleAllLabels [

	SBDomainBlockContainer code: ((SBCircleAllLabelFixture key: 'root')
		left: (SBCircleAllLabelFixture key: 'child1');
		right: (SBCircleAllLabelFixture key: 'child2'))
]

{ #category : #examples }
SBDomainBlockContainer >> exampleGameCard [

	SBDomainBlockContainer code: (SBGameCard new
		attack: 5;
		defense: 6;
		type: 'fire')
]

{ #category : #examples }
SBDomainBlockContainer >> exampleGameCardHand [

	SBDomainBlockContainer code: (SBGameCardHand new cards: {
		SBGameCard new
			attack: 5;
			defense: 6;
			type: 'fire'.
		SBGameCard new
			attack: 300;
			defense: 1;
			type: 'bug'.
		SBGameCard new
			attack: 3;
			defense: 10;
			type: 'water'})
]

{ #category : #examples }
SBDomainBlockContainer >> exampleRectangleStringLabel [

	SBDomainBlockContainer code: ((SBRectangleTopLabelFixture key: 'a')
		left: (SBRectangleTopLabelFixture key: 'b');
		right: (SBRectangleTopLabelFixture key: 'c'))
]

{ #category : #examples }
SBDomainBlockContainer >> exampleSimpleCircle [

	SBDomainBlockContainer code: ((SBCircleFixture key: 'root')
		left: (SBCircleFixture key: 'child1');
		right: (SBCircleFixture key: 'child2'))
]

{ #category : #examples }
SBDomainBlockContainer >> exampleSimpleGrammar [

	SBDomainBlockContainer code: (SBGrammarObject new
		objectName: '';
		type: 'SEQ';
		members: {
			SBGrammarObject new
				objectName: 'a';
				type: 'SYMBOL';
				members: {}.
			SBGrammarObject new
				objectName: 'b';
				type: 'REPEAT';
				content: (SBGrammarObject new
					objectName: 'a';
					type: 'SYMBOL';
					members: {})})
]

{ #category : #examples }
SBDomainBlockContainer >> exampleSimpleRectangle [

	SBDomainBlockContainer code: ((SBDummyNode key: 3)
		left: (SBDummyNode key: 5);
		right: (SBDummyNode key: 1))
]

{ #category : #examples }
SBDomainBlockContainer >> exampleSpecialShape [

	SBDomainBlockContainer code: ((SBSpecialShapeFixture key: 255)
		left: (SBSpecialShapeFixture key: 100);
		right: (SBSpecialShapeFixture key: 1))
]

{ #category : #initialization }
SBDomainBlockContainer >> initialize [

	super initialize.
	isImplicit := false.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		shrinkWrap;
		changeTableLayout;
		cellInset: 6;
		addMorphBack: (SBBlock new
			layoutPolicy: SBTreeLayoutPolicy new;
			shrinkWrap;
			layoutInset: 6;
			when: #reportError send: #reportError: to: self)
]

{ #category : #accessing }
SBDomainBlockContainer >> isImplicit [

	^ isImplicit
]

{ #category : #accessing }
SBDomainBlockContainer >> isImplicit: aBoolean [
	"Sometimes, e.g. when using showAsDomainBlock, we implicitly show a SBDomainBlockContainer, which we don't want to see in the writeSourceOn:"

	isImplicit := aBoolean
]

{ #category : #printing }
SBDomainBlockContainer >> tryWriteSourceOrStore: anObject on: aStream [

	(anObject respondsTo: #writeSourceOn:)
		ifTrue: [anObject writeSourceOn: aStream]
		ifFalse: [anObject storeOn: aStream]
]

{ #category : #visualization }
SBDomainBlockContainer >> visualize: aDomainBlock [

	self firstSubmorph removeAllMorphs.
	self firstSubmorph addMorph: aDomainBlock
]

{ #category : #printing }
SBDomainBlockContainer >> writeCodeOn: aStream [

	| object |
	aStream nextPut: $(.
	object := (self firstSubmorph submorphs detect: [:morph | morph isDomainBlock]) patternRoot buildObject.
	self tryWriteSourceOrStore: object on: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
SBDomainBlockContainer >> writeSourceOn: aStream [

	self isImplicit
		ifTrue: [
			aStream nextPut: $(.
			self writeCodeOn: aStream.
			aStream nextPutAll: ') showAsDomainBlock']
		ifFalse: [
			aStream nextPutAll: '(SBDomainBlockContainer code: '.
			self writeCodeOn: aStream.
			aStream nextPut: $)]
]
