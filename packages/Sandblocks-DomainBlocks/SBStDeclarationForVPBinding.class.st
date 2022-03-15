"
An SBStDeclarationForVPBinding is xxxxxxxxx.

"
Class {
	#name : #SBStDeclarationForVPBinding,
	#superclass : #SBStDeclarationBehavior,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBStDeclarationForVPBinding class >> checkCastFor: aBlock parent: aMorph [

	| case |
	case := aMorph containingSandblock isBindingPattern
		ifTrue: [aMorph containingSandblock patternContainer]
		ifFalse: [^ false].
	^ case notNil and: [aBlock hasOwner: case pattern]
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> asSuggestionItem [

	^ SBSuggestionItem selector: self contents label: 'block var'
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> attached: aName [

	super attached: aName.
	self refreshBindingIndex
]

{ #category : #'as yet unclassified' }
SBStDeclarationForVPBinding >> castToUnknownWhenEmpty [

	^ true
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> contentsChanged [

	super contentsChanged.
	self refreshBindingIndex
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
SBStDeclarationForVPBinding >> refreshBindingIndex [

	| bindingPattern |
	bindingPattern := name firstOwnerSuchThat: [:owner | owner isBindingPattern].
	(bindingPattern labelPositionOf: name) = bindingPattern identityLabelPosition ifTrue: [bindingPattern bindingIndex: name contents]
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> scope [

	^ {self block patternRoot parentSandblock}
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> symbolsFor: aColorPolicy [

	^ #(nil nil)
]

{ #category : #accessing }
SBStDeclarationForVPBinding >> valid [

	^ ((self block containingBlock ifNotNil: #parentSandblock) ifNotNil: [:parent |
		parent
			binding: self contents
			for: self block
			class: (self block containingArtefact ifNotNil: #relatedClass)
			ifPresent: [:binding | binding isMethodLocal ifTrue: [binding]]]) isNil
]
