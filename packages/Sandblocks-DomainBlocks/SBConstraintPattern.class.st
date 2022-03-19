"
An SBConstraintPattern represents a textual condition and is used for pattern matching.

Instance Variables
	constraint:		BlockClosure

constraint
	- contains the condition as a BlockClosure

"
Class {
	#name : #SBConstraintPattern,
	#superclass : #SBStSubstitution,
	#instVars : [
		'constraint'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #replacements }
SBConstraintPattern class >> constraint: aClosure [
	"marker"

	^ self new constraint: aClosure
]

{ #category : #'as yet unclassified' }
SBConstraintPattern class >> constraintInputName [

	^ 'bindings'
]

{ #category : #'as yet unclassified' }
SBConstraintPattern class >> default [

	^ SBConstraintPattern new constraint: [:bindings | ]
]

{ #category : #'as yet unclassified' }
SBConstraintPattern class >> defaultVisualizedAs: aClass [

	^ self default
]

{ #category : #'as yet unclassified' }
SBConstraintPattern class >> matches: aBlock [

	^ self selector: #constraint: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBConstraintPattern class >> newFor: aBlock [

	| constraintBlock |
	constraintBlock := aBlock arguments first.
	constraintBlock allBlocksDo: [:block |
		((block isKindOf: SBStMessageSend)
			and: [block receiver contents = self constraintInputName]
			and: [block selector = 'at:']) ifTrue: [ | variableName |
			variableName := block arguments first evaluate.
			block replaceBy: ((SBStName poolDeclaration: variableName) binding: variableName -> SBDomainBlock new)]].
	constraintBlock bindings do: [:b | b owner hide].
	
	^ self new constraint: constraintBlock evaluate
]

{ #category : #'as yet unclassified' }
SBConstraintPattern class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #'adding/removing' }
SBConstraintPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self
]

{ #category : #utilities }
SBConstraintPattern >> allChildrenDo: aBlock [

	
]

{ #category : #'pattern matching' }
SBConstraintPattern >> buildImplicitChildren: aDict [

	
]

{ #category : #accessing }
SBConstraintPattern >> collectBindingsInto: aCollection [
	"we do not define bindings"

	
]

{ #category : #accessing }
SBConstraintPattern >> collectIdentityBindingsInto: aCollection [
	"we do not define bindings"

	
]

{ #category : #accessing }
SBConstraintPattern >> constraint [

	^ constraint
]

{ #category : #accessing }
SBConstraintPattern >> constraint: aBlockClosure [

	constraint := aBlockClosure.
	self removeAllMorphs.
	self addAllMorphs: aBlockClosure asSandblock statements.
	self submorphs ifEmpty: [ | unknown |
		unknown := self newUnknown.
		self addMorphBack: unknown.
		unknown label: 'expr']
]

{ #category : #actions }
SBConstraintPattern >> deleteBlock [

	self sandblockEditor do: (SBDeleteDomainBlockCommand new target: self)
]

{ #category : #'insert/delete' }
SBConstraintPattern >> deleteCommandFor: aBlock [

	^ self submorphCount = 1
		ifTrue: [self parentSandblock deleteCommandFor: self]
		ifFalse: [super deleteCommandFor: aBlock]
]

{ #category : #'testing hierarchy' }
SBConstraintPattern >> fixedNumberOfChildren [

	^ false
]

{ #category : #'pattern matching' }
SBConstraintPattern >> getNext: aDomainBlock [

	^ false
]

{ #category : #initialization }
SBConstraintPattern >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		layoutInset: 4
]

{ #category : #testing }
SBConstraintPattern >> isBlockBody [

	^ true
]

{ #category : #accessing }
SBConstraintPattern >> isExpression [

	^ false
]

{ #category : #accessing }
SBConstraintPattern >> isImplicitChild [

	^ false
]

{ #category : #accessing }
SBConstraintPattern >> isPatternBlock [

	^ true
]

{ #category : #testing }
SBConstraintPattern >> isSelectable [

	^ false
]

{ #category : #layout }
SBConstraintPattern >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: [:s | s layoutCommands] separatedBy: [SBAlgebraCommand hardLine])
]

{ #category : #'pattern matching' }
SBConstraintPattern >> matches: aDomainBlock withBinding: aDict [

	| originalBindings |
	originalBindings := aDict collect: [:domainBlockOrCollection |
		domainBlockOrCollection isCollection
			ifTrue: [domainBlockOrCollection collect: [:element | element isDomainBlock ifTrue: [element sourceObject] ifFalse: [element]]]
			ifFalse: [
				domainBlockOrCollection isDomainBlock
					ifTrue: [domainBlockOrCollection sourceObject]
					ifFalse: [domainBlockOrCollection]]].
	
	^ self constraint value: originalBindings
]

{ #category : #initialization }
SBConstraintPattern >> newUnknown [

	^ SBUnknown new grammarHandler: SBStGrammarHandler new
]

{ #category : #accessing }
SBConstraintPattern >> patternChildren [

	^ {}
]

{ #category : #'pattern hierarchy' }
SBConstraintPattern >> patternParent [

	^ self owner isPatternBlock ifTrue: [self owner]
]

{ #category : #'pattern matching' }
SBConstraintPattern >> removeImplicitChildren [

	
]

{ #category : #'pattern matching' }
SBConstraintPattern >> reset [

	
]

{ #category : #'pattern matching' }
SBConstraintPattern >> setBindingFor: aDomainBlock in: aCollection [

	^ true
]

{ #category : #accessing }
SBConstraintPattern >> statements [

	^ self submorphs
]

{ #category : #testing }
SBConstraintPattern >> wantsMethodBody [

	^ false
]

{ #category : #printing }
SBConstraintPattern >> writeSourceOn: aStream [

	aStream
		nextPutAll: '(SBConstraintPattern constraint: [:bindings | ';
		cr.
	
	self submorphs do: [:m |
		m writeSourceOn: aStream.
		m isPragma ifFalse: [aStream nextPut: $.].
		aStream cr].
	
	aStream nextPutAll: '])'
]
