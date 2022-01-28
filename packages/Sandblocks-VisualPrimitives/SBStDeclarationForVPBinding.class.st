Class {
	#name : #SBStDeclarationForVPBinding,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForVPBinding class >> checkCastFor: aBlock parent: aMorph [

	^ aMorph isBlockBindings
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'block var'
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> guessedClass [

	^ self block containingArtefact typeFor: self block
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> inputCommandClass [

	^ SBStBindingRenameCommand
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> isBlockBinding [

	^ true
]

{ #category : #'as yet unclassified' }
SBStDeclarationForVPBinding >> isExpression [

	^ false
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> isMethodLocal [

	^ true
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> printBlockOn: aStream [

	aStream
		nextPutAll: 'block declaration ';
		nextPutAll: self contents
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> scope [

	^ {self block root parentSandblock}
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> symbolsFor: aColorPolicy [

	^ #(nil nil)
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> valid [
	" check that this name does not already exist in a parent scope "

	self block containingBlock
		ifNil: [^ false]
		ifNotNil: [:stuff | stuff parentSandblock ifNil: [^ false]].
	^ (self block containingBlock parentSandblock
		binding: self contents
		for: self block
		class: (self block containingArtefact ifNotNil: #relatedClass)
		ifPresent: [:binding | binding isMethodLocal ifTrue: [binding] ifFalse: [nil]]) isNil
]
