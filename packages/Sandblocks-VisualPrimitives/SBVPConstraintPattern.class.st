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
SBVPConstraintPattern >> constraint: anObject [

	constraint := anObject
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlock [

	^ constraintBlock
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlock: aBlock [

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
	self constraintBlock: (SBColumn new layoutInset: 0)
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self constraint valueWithArguments: aCollection
]
