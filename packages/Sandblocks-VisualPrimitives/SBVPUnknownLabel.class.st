"
An SBVPUnknownLabel is the Unknown for an empty SBVisualPrimitive's label. It suggests to become a binding, variable or constant.

"
Class {
	#name : #SBVPUnknownLabel,
	#superclass : #SBUnknown,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPUnknownLabel >> deleteBeforeCursor [

	self sandblockEditor do: (SBDeleteCommand new target: self)
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
SBVPUnknownLabel >> suggestions [

	^ self parentSandblock labelSuggestionsFor: self
]
