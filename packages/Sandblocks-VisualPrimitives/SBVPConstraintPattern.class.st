Class {
	#name : #SBVPConstraintPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'constraint'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPConstraintPattern class >> constraint: aClosure [
	"marker"

	^ self new constraint: aClosure
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern class >> constraintInputName [

	^ 'bindings'
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern class >> matches: aBlock [

	^ self selector: #constraint: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern class >> newFor: aBlock [

	| constraintBlock |
	constraintBlock := aBlock arguments first.
	constraintBlock allBlocksDo: [:block |
		((block isKindOf: SBStMessageSend)
			and: [block receiver contents = self constraintInputName]
			and: [block selector = 'at:']) ifTrue: [ | variableName |
			variableName := block arguments first evaluate.
			block replaceBy: ((SBStName poolDeclaration: variableName) binding: variableName -> SBVisualPrimitive new)]].
	constraintBlock bindings do: [:b | b owner hide].
	
	^ self new constraint: constraintBlock evaluate
]

{ #category : #accessing }
SBVPConstraintPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> allChildrenDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> attachTreeDecorator [

	
]

{ #category : #accessing }
SBVPConstraintPattern >> collectBindingsInto: aCollection [
	"we do not define bindings"

	
]

{ #category : #accessing }
SBVPConstraintPattern >> constraint [

	^ constraint
]

{ #category : #accessing }
SBVPConstraintPattern >> constraint: aBlockClosure [

	constraint := aBlockClosure.
	self removeAllMorphs.
	self addAllMorphs: aBlockClosure asSandblock statements.
	self submorphs ifEmpty: [ | unknown |
		unknown := self newUnknown.
		self addMorphBack: unknown.
		unknown label: 'expr']
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> deleteCommandFor: aBlock [

	^ self submorphCount = 1
		ifTrue: [self parentSandblock deleteCommandFor: self]
		ifFalse: [super deleteCommandFor: aBlock]
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> grammarHandler [

	^ SBStGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		layoutInset: 4
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> isBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> isSelectable [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: [:s | s layoutCommands] separatedBy: [SBAlgebraCommand hardLine])
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> matches: aVisualPrimitive withBinding: aDict [

	| originalBindings |
	originalBindings := aDict collect: [:visualPrimitiveOrCollection |
		visualPrimitiveOrCollection isCollection
			ifTrue: [visualPrimitiveOrCollection collect: [:element | element isVisualPrimitive ifTrue: [element sourceObject] ifFalse: [element]]]
			ifFalse: [
				visualPrimitiveOrCollection isVisualPrimitive
					ifTrue: [visualPrimitiveOrCollection sourceObject]
					ifFalse: [visualPrimitiveOrCollection]]].
	
	^ self constraint value: originalBindings
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> newUnknown [

	^ SBUnknown new grammarHandler: SBStGrammarHandler new
]

{ #category : #accessing }
SBVPConstraintPattern >> statements [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> wantsMethodBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> writeSourceOn: aStream [

	aStream
		nextPutAll: '(SBVPConstraintPattern constraint: [:bindings | ';
		cr.
	
	self submorphs do: [:m |
		m writeSourceOn: aStream.
		m isPragma ifFalse: [aStream nextPut: $.].
		aStream cr].
	
	aStream nextPutAll: '])'
]
