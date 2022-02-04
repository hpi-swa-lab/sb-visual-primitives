Class {
	#name : #SBStDeclarationForVPBinding,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForVPBinding class >> checkCastFor: aBlock parent: aMorph [

	| case |
	case := (aMorph containingSandblock isKindOf: SBVPBindingPattern)
		ifTrue: [aMorph containingSandblock parentCase]
		ifFalse: [^ false].
	^ case notNil and: [aBlock hasOwner: case input]
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
		nextPutAll: 'pattern input declaration ';
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

	self block containingBlock
		ifNil: [^ false]
		ifNotNil: [:b | b parentSandblock ifNil: [^ false]].
	^ (self block containingBlock parentSandblock
		binding: self contents
		for: self block
		class: (self block containingArtefact ifNotNil: #relatedClass)
		ifPresent: [:binding | binding isMethodLocal ifTrue: [binding] ifFalse: [nil]]) isNil
]
