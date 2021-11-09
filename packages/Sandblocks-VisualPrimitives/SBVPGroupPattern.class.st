Class {
	#name : #SBVPGroupPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'patterns'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> new: aCollection [

	^ self new patterns: aCollection
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> getNext: aVisualPrimitive [

	self patterns do: [:pattern |
		(pattern getNext: aVisualPrimitive)
			ifFalse: [pattern reset]
			ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self patterns allSatisfy: [:pattern | pattern matches: aVisualPrimitive withBinding: aCollection]
]

{ #category : #accessing }
SBVPGroupPattern >> patterns [

	^ patterns
]

{ #category : #accessing }
SBVPGroupPattern >> patterns: anObject [

	patterns := anObject
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> reset [

	self patterns do: [:pattern | pattern reset]
]

{ #category : #accessing }
SBVPGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	self patterns do: [:pattern | (pattern setBindingFor: aVisualPrimitive in: aCollection) ifFalse: [^ false]].
	^ true
]
