Class {
	#name : #SBVPUnknownLabel,
	#superclass : #SBUnknown,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> nextIdentifier [

	^ self parentSandblock root nextIdentifier
]

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> printOn: aStream [

	aStream nextPutAll: 'unknown label'
]

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> suggestAlways [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> suggestionConstant [

	| position |
	position := self parentSandblock labelPositionOf: self.
	^ self parentSandblock visualPrimitiveMapping
		detect: [:mapping | mapping key = position]
		ifFound: [:mapping | mapping asPropertyMapping suggestionConstant]
		ifNone: [#a]
]

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> suggestions [

	| constantString |
	constantString := String streamContents: [:stream |
		stream
			nextPut: $[;
			store: self suggestionConstant;
			nextPut: $]].
	^ {
		SBSuggestionItem selector: self nextIdentifier label: 'binding'.
		(SBBlockSuggestionItem selector: '[myVar]' label: 'variable') builder: ['[myVar]' parseAsSandblock].
		(SBBlockSuggestionItem selector: constantString label: 'constant') builder: [constantString parseAsSandblock]}
]
