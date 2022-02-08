Class {
	#name : #SBVPRelInsertCommand,
	#superclass : #SBRelInsertCommand,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPRelInsertCommand >> do [

	| result |
	result := super do.
	self container addConnection: self morph afterIndex: self morphIndexInConnections.
	^ result
]

{ #category : #'as yet unclassified' }
SBVPRelInsertCommand >> morphIndexInConnections [

	^ self adjacent
		ifNil: [self before ifTrue: [1] ifFalse: [self container connections size]]
		ifNotNil: [ | indexInRow actualAdjacent |
			actualAdjacent := self container row
				submorphThat: [:submorph | (self adjacent hasOwner: submorph) or: [submorph = self adjacent]]
				ifNone: [nil].
			indexInRow := (self container row submorphIndexOf: actualAdjacent).
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
			morph: (SBVPConstraintPattern constraint: [:bindings | true])
			previewOnly: false}
]

{ #category : #'as yet unclassified' }
SBVPRelInsertCommand >> undo [

	self container removeConnection: self morph.
	super undo.
	^ self morph
]
