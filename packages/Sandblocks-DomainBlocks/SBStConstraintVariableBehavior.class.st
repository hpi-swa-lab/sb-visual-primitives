"
An SBStConstraintVariableBehavior is xxxxxxxxx.

"
Class {
	#name : #SBStConstraintVariableBehavior,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior class >> checkCastFor: aBlock parent: aMorph [

	^ (aBlock firstOwnerSuchThat: [:owner | owner isKindOf: SBConstraintPattern])
		ifNil: [false]
		ifNotNil: [:constraintPattern |
			constraintPattern patternContainer
				ifNil: [false]
				ifNotNil: [:case | case isValidBinding: aBlock contents]]
]

{ #category : #'as yet unclassified' }
SBStConstraintVariableBehavior >> guessedClass [

	| someClass |
	someClass := self block containingArtefact typeFor: self block.
	^ (name firstOwnerSuchThat: [:owner | owner isKindOf: SBConstraintPattern])
		ifNil: [someClass]
		ifNotNil: [:constraintPattern |
			constraintPattern patternContainer
				ifNil: [someClass]
				ifNotNil: [:case | case defaultVisualizationClass]]
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

	^ {self block patternRoot parentSandblock}
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
		nextPut: $(;
		nextPutAll: SBConstraintPattern constraintInputName;
		nextPutAll: ' at: #';
		nextPutAll: name contents;
		nextPut: $)
]
