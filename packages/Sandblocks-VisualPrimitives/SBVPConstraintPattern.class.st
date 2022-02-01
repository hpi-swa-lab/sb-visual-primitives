Class {
	#name : #SBVPConstraintPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'constraint',
		'constraintBlock'
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
	constraintBlock allBlocksDo: [:britta |
		((britta isKindOf: SBStMessageSend)
			and: [britta receiver contents = self constraintInputName]
			and: [britta selector = 'at:']) ifTrue: [ | variableName |
			variableName := britta arguments first evaluate.
			britta replaceBy: ((SBVPConstraintVariable poolDeclaration: variableName) binding: variableName -> SBVisualPrimitive new)]].
	constraintBlock bindings do: [:b | b owner hide].
	"  :(  "
	^ self new constraintBlock: constraintBlock
]

{ #category : #accessing }
SBVPConstraintPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> artefactSaved: aMethodBlock [

	constraint := self constraintBlock evaluate
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> attachTreeDecorator [

	
]

{ #category : #accessing }
SBVPConstraintPattern >> constraint [

	^ constraint
]

{ #category : #accessing }
SBVPConstraintPattern >> constraint: aBlockClosure [

	| block |
	constraint := aBlockClosure.
	block := aBlockClosure decompile asSandblock shrinkWrap.
	block bindings do: [:b | b owner hide].
	self constraintBlockBasic: block
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlock [

	^ constraintBlock
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlock: aBlock [

	constraintBlock := aBlock.
	constraint := aBlock evaluate.
	self addMorphBack: aBlock
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlockBasic: aBlock [

	constraintBlock := aBlock.
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> initialize [

	super initialize.
	self removeAllMorphs.
	self constraintBlockBasic: (SBColumn new layoutInset: 0)
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> matches: aVisualPrimitive withBinding: aDict [

	^ self constraint value: aDict
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> wantsMethodBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPConstraintPattern constraint: '.
	self constraintBlock writeSourceOn: aStream.
	aStream nextPut: $)
]
