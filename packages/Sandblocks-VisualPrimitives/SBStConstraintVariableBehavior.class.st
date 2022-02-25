"
An SBStConstraintVariableBehavior is xxxxxxxxx.

Instance Variables

"
Class {
	#name : #SBStConstraintVariableBehavior,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior class >> checkCastFor: aBlock parent: aMorph [

	^ (aBlock firstOwnerSuchThat: [:owner | owner isKindOf: SBVPConstraintPattern])
		ifNil: [false]
		ifNotNil: [:constraintPattern |
			constraintPattern parentCaseOrQuery
				ifNil: [false]
				ifNotNil: [:case | case isValidBinding: aBlock contents]]
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> guessedClass [

	| someClass |
	someClass := self block containingArtefact typeFor: self block.
	^ (name firstOwnerSuchThat: [:owner | owner isKindOf: SBVPConstraintPattern])
		ifNil: [someClass]
		ifNotNil: [:constraintPattern |
			constraintPattern parentCaseOrQuery
				ifNil: [someClass]
				ifNotNil: [:case | case defaultPatternVisualizationClass]]
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> inputCommandClass [

	^ SBStBindingRenameCommand
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> isBlockBinding [

	^ true
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> isMethodLocal [

	^ true
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> printBlockOn: aStream [

	aStream
		nextPutAll: 'constraint variable ';
		nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> scope [

	^ {self block root parentSandblock}
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> symbolsFor: aColorPolicy [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> valid [

	^ name isReserved not
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> writeSourceOn: aStream [

	aStream
		nextPutAll: '(';
		nextPutAll: SBVPConstraintPattern constraintInputName;
		nextPutAll: ' at: #';
		nextPutAll: name contents;
		nextPutAll: ')'
]
