"
An SBUnknownLabel is the Unknown for an empty SBDomainBlock's label. It suggests to become a binding, variable or constant.

"
Class {
	#name : #SBUnknownLabel,
	#superclass : #SBUnknown,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBUnknownLabel >> deleteBeforeCursor [

	self sandblockEditor do: (SBDeleteCommand new target: self)
]

{ #category : #'as yet unclassified' }
SBUnknownLabel >> printOn: aStream [

	aStream nextPutAll: 'unknown label'
]

{ #category : #'as yet unclassified' }
SBUnknownLabel >> suggestAlways [

	^ true
]

{ #category : #'as yet unclassified' }
SBUnknownLabel >> suggestions [

	^ self parentSandblock labelSuggestionsFor: self
]
