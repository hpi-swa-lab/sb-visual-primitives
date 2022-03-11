"
An SBRelInsertDomainBlockCommand is used to insert new patterns into an SBGroupPattern.

"
Class {
	#name : #SBRelInsertDomainBlockCommand,
	#superclass : #SBRelInsertCommand,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> continueAfterInsert: aCharacter [

	^ false
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> do [

	| result |
	self morph isUnknown ifTrue: [^ nil].
	result := super do.
	self container addChild: self morph afterIndex: self morphIndexInChildren.
	^ result
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> morphIndexInChildren [

	^ self adjacent
		ifNil: [self before ifTrue: [0] ifFalse: [self container children size]]
		ifNotNil: [ | indexInRow actualAdjacent |
			actualAdjacent := self container row
				submorphThat: [:submorph | (self adjacent hasOwner: submorph) or: [submorph = self adjacent]]
				ifNone: [nil].
			indexInRow := self container row submorphIndexOf: actualAdjacent.
			self before ifTrue: [indexInRow := indexInRow - 1].
			indexInRow + 1 / 2]
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> suggestions [

	| suggestions outputPattern |
	suggestions := {
		(SBInsertSuggestionItem selector: 'addNewBindingPattern' label: 'choice')
			morph: SBBindingPattern new
			previewOnly: false.
		(SBInsertSuggestionItem selector: 'addNewConstraintPattern' label: 'choice')
			morph: (SBConstraintPattern constraint: [:bindings | ])
			previewOnly: false.
		(SBInsertSuggestionItem selector: 'addNewAndPattern' label: 'choice')
			morph: SBGroupPattern new
			previewOnly: false.
		(SBInsertSuggestionItem selector: 'addNewOrPattern' label: 'choice')
			morph: SBOrGroupPattern new
			previewOnly: false}.
	outputPattern := self container patternContainer outputPattern.
	outputPattern = self container ifTrue: [^ {suggestions first}].
	^ suggestions
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> undo [

	self container removeChild: self morph.
	super undo.
	^ self morph
]
