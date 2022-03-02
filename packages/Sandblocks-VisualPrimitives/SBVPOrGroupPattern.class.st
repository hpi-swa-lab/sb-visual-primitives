"
A SBVPOrGroupPattern is xxxxxxxxx.

"
Class {
	#name : #SBVPOrGroupPattern,
	#superclass : #SBVPGroupPattern,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> getNext: aVisualPrimitive [

	| gotNext |
	gotNext := false.
	self children do: [:pattern | (pattern getNext: aVisualPrimitive) ifTrue: [gotNext := true]].
	^ gotNext
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ boundPattern matches: aVisualPrimitive withBinding: aCollection
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> seperatorString [

	^ ' or '
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	| originalCollection |
	originalCollection := aCollection copy.
	^ self children
		detect: [:pattern |
			aCollection removeAll.
			aCollection addAll: originalCollection.
			pattern setBindingFor: aVisualPrimitive in: aCollection]
		ifFound: [:pattern |
			boundPattern := pattern.
			true]
		ifNone: [false]
]
