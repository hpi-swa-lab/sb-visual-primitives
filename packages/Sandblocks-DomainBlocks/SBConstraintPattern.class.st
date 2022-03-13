"
An SBConstraintPattern represents a textual condition and is used for pattern matching.

Instance Variables
	constraint:		BlockClosure
	parent:			Object

constraint
	- contains the condition as a BlockClosure

parent
	- the parent primitive
	- also indicates the hierarchy of patterns 
"
Class {
	#name : #SBConstraintPattern,
	#superclass : #SBStSubstitution,
	#instVars : [
		'constraint',
		'parent'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBConstraintPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBConstraintPattern >> allChildrenDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBConstraintPattern >> buildImplicitChildren: aDict [

	
]

{ #category : #'as yet unclassified' }
SBConstraintPattern >> children [

	^ {}
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

{ #category : #'as yet unclassified' }
SBConstraintPattern >> deleteBlock [

	self sandblockEditor do: (SBDeleteDomainBlockCommand new
		target: self;
		yourself)
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

{ #category : #'as yet unclassified' }
SBConstraintPattern >> isDomainBlock [

	self flag: #todo.
	"Should actually be false"
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBConstraintPattern >> newUnknown [

	^ SBUnknown new grammarHandler: SBStGrammarHandler new
]

{ #category : #accessing }
SBConstraintPattern >> parent [

	^ parent
]

{ #category : #accessing }
SBConstraintPattern >> parent: anObject [

	parent := anObject
]

{ #category : #'as yet unclassified' }
SBConstraintPattern >> patternContainer [

	| case |
	case := self root parentSandblock.
	^ (case isKindOf: SBPatternContainer) ifTrue: [case]
]

{ #category : #'pattern matching' }
SBConstraintPattern >> removeImplicitChildren [

	
]

{ #category : #'pattern matching' }
SBConstraintPattern >> reset [

	
]

{ #category : #'as yet unclassified' }
SBConstraintPattern >> root [

	^ self parent ifNil: [self] ifNotNil: [self parent root]
]

{ #category : #'pattern matching' }
SBConstraintPattern >> setBindingFor: aDomainBlock in: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBConstraintPattern >> siblingIndex [

	^ self parent ifNil: [0] ifNotNil: [self parent children indexOf: self]
]

{ #category : #accessing }
SBConstraintPattern >> statements [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
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
