"
An SBVPRelInsertCommand is used to insert new patterns into an SBVPGroupPattern.

"
Class {
	#name : #SBVPRelInsertCommand,
	#superclass : #SBRelInsertCommand,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPRelInsertCommand >> do [

	| result |
	result := super do.
	self container addChild: self morph afterIndex: self morphIndexInChildren.
	^ result
]

{ #category : #'as yet unclassified' }
SBVPRelInsertCommand >> morphIndexInChildren [

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
SBVPRelInsertCommand >> suggestions [

	^ {
		(SBInsertSuggestionItem selector: 'addNewBindingPattern' label: 'choice')
			morph: SBVPBindingPattern new
			previewOnly: false.
		(SBInsertSuggestionItem selector: 'addNewConstraintPattern' label: 'choice')
			morph: (SBVPConstraintPattern constraint: [:bindings | ])
			previewOnly: false}
]

{ #category : #'as yet unclassified' }
SBVPRelInsertCommand >> undo [

	self container removeChild: self morph.
	super undo.
	^ self morph
]
