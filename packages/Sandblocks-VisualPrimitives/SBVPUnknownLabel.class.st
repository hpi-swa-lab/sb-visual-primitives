Class {
	#name : #SBVPUnknownLabel,
	#superclass : #SBUnknown,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> printOn: aStream [

	aStream nextPutAll: 'unknown label'
]

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> suggestAlways [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> suggestions [

	^ {SBSuggestionItem selector: 'text' label: 'a'}
]
