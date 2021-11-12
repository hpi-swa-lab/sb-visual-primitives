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

	^ self new constraint: aClosure.
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
SBVPConstraintPattern >> constraint [

	^ constraint
]

{ #category : #accessing }
SBVPConstraintPattern >> constraint: anObject [

	constraint := anObject.

]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlock [

	^ constraintBlock
]

{ #category : #accessing }
SBVPConstraintPattern >> constraintBlock: anObject [

	constraintBlock := anObject.
	self addMorphBack: anObject
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> initialize [

	super initialize.
	self constraintBlock: (SBColumn new layoutInset: 0).
]

{ #category : #'as yet unclassified' }
SBVPConstraintPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self constraint valueWithArguments: aCollection
]
