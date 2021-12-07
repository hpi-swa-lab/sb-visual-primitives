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
SBVPConstraintPattern class >> matches: aBlock [

	^ self selector: #constraint: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern class >> newFor: aBlock [

	^ self new constraintBlock: aBlock arguments first
]

{ #category : #accessing }
SBVPConstraintPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self
]

{ #category : #accessing }
SBVPConstraintPattern >> constraint [

	^ constraint
]

{ #category : #accessing }
SBVPConstraintPattern >> constraint: aBlockClosure [

	constraint := aBlockClosure.
	self constraintBlockBasic: (aBlockClosure decompile asSandblock
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap)
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlock [

	^ constraintBlock
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlock: aBlock [

	constraintBlock := aBlock.
	constraint := aBlock evaluate.
	self addMorphBack: aBlock.
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlockBasic: aBlock [

	constraintBlock := aBlock.
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> highestBindingVariable [

	^ self constraint numArgs
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> initialize [

	super initialize.
	self removeAllMorphs.
	self constraintBlockBasic: (SBColumn new layoutInset: 0)
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self constraint valueWithArguments: aCollection
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> saveTryFixing: aBoolean quick: anotherBoolean [

	constraint := self constraintBlock evaluate.
	^ true
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> wantsMethodBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPConstraintPattern constraint: '.
	self constraintBlock writeSourceOn: aStream.
	aStream nextPut: $).
	self reloadArtefact
]
