"
An SBRelInsertDomainBlockCommand is used to insert new patterns into an SBGroupPattern.

"
Class {
	#name : #SBRelInsertDomainBlockCommand,
	#superclass : #SBRelInsertCommand,
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> continueAfterInsert: aCharacter [

	^ false
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> do [

	self morph isUnknown ifTrue: [^ nil].
	self container addChild: self morph afterIndex: self morphIndexInChildren.
	^ self morph wantsInput
		ifTrue: [self morph]
		ifFalse: [self morph nextBlockThat: #wantsInput]
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> morphIndexInChildren [

	^ self adjacent
		ifNil: [self before ifTrue: [0] ifFalse: [self container patternChildren size]]
		ifNotNil: [ | indexInRow actualAdjacent |
			actualAdjacent := self container
				submorphThat: [:submorph | (self adjacent hasOwner: submorph) or: [submorph = self adjacent]]
				ifNone: [nil].
			indexInRow := self container submorphIndexOf: actualAdjacent.
			self before ifTrue: [indexInRow := indexInRow - 1].
			indexInRow + 1 / 2]
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> newSuggestionItemFor: aPattern withSelector: aString of: anSBPatternContainer [

	^ (SBInsertSuggestionItem selector: aString label: 'choice')
		morph: (aPattern defaultVisualizedAs: anSBPatternContainer defaultVisualizationClass)
		editor: anSBPatternContainer sandblockEditor
		previewOnly: false
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> suggestions [

	| suggestions outputPattern patternContainer |
	patternContainer := self container patternContainer.
	suggestions := {
		self newSuggestionItemFor: SBBindingPattern withSelector: 'addNewBindingPattern' of: patternContainer.
		self
			newSuggestionItemFor: SBConstraintPattern
			withSelector: 'addNewConstraintPattern'
			of: patternContainer.
		self newSuggestionItemFor: SBGroupPattern withSelector: 'addNewAndPattern' of: patternContainer.
		self newSuggestionItemFor: SBOrGroupPattern withSelector: 'addNewOrPattern' of: patternContainer}.
	outputPattern := patternContainer outputPattern.
	outputPattern = self container ifTrue: [^ {suggestions first}].
	^ suggestions
]

{ #category : #'as yet unclassified' }
SBRelInsertDomainBlockCommand >> undo [

	self container removeChild: self morph.
	super undo.
	^ self morph
]
