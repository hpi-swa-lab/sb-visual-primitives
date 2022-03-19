"
An SBStDeclarationForDBBinding is the behaviour of the SBStNames that defining bindings inside of SBBindingPatterns when they are inside of an SBQuery or on the input pattern side of an SBTransformation.

"
Class {
	#name : #SBStDeclarationForDBBinding,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForDBBinding class >> checkCastFor: aBlock parent: aMorph [

	| case |
	case := aMorph containingSandblock isBindingPattern
		ifTrue: [aMorph containingSandblock patternContainer]
		ifFalse: [^ false].
	^ case notNil and: [aBlock hasOwner: case pattern]
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'block var'
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> attached: aName [

	super attached: aName.
	self refreshBindingName
]

{ #category : #'as yet unclassified' }
SBStDeclarationForDBBinding >> castToUnknownWhenEmpty [

	^ true
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> contentsChanged [

	super contentsChanged.
	self refreshBindingName
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> guessedClass [

	^ self block containingArtefact typeFor: self block
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> inputCommandClass [

	^ SBStBindingRenameCommand
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> isBlockBinding [

	^ true
]

{ #category : #'as yet unclassified' }
SBStDeclarationForDBBinding >> isExpression [

	^ false
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> isMethodLocal [

	^ true
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> printBlockOn: aStream [

	aStream
		nextPutAll: 'pattern input declaration ';
		nextPutAll: self contents
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> refreshBindingName [

	| bindingPattern |
	bindingPattern := name firstOwnerSuchThat: [:owner | owner isBindingPattern].
	(bindingPattern labelPositionOf: name) = bindingPattern identityLabelPosition ifTrue: [bindingPattern bindingName: name contents]
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> scope [

	^ {self block root parentSandblock}
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> symbolsFor: aColorPolicy [

	^ #(nil nil)
]

{ #category : #accessing }
SBStDeclarationForDBBinding >> valid [

	^ ((self block containingBlock ifNotNil: #parentSandblock) ifNotNil: [:parent |
		parent
			binding: self contents
			for: self block
			class: (self block containingArtefact ifNotNil: #relatedClass)
			ifPresent: [:binding | binding isMethodLocal ifTrue: [binding]]]) isNil
]
