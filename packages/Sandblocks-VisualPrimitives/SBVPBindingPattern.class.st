Class {
	#name : #SBVPBindingPattern,
	#superclass : #SBVisualPrimitive,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> couldMatch: aVisualPrimitive [

	^ self connections size <= aVisualPrimitive connections size
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> getNext: aVisualPrimitive [

	(self couldMatch: aVisualPrimitive) ifFalse: [^ false].
	self connections withIndexDo: [:connection :index |
		(connection getNext: (connection searchRootFor: aVisualPrimitive at: index))
			ifFalse: [connection reset]
			ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> matches: aVisualPrimitive withBinding: aDictionary [

	^ self connections withIndexAllSatisfy: [:connection :index |
		connection
			matches: (connection searchRootFor: aVisualPrimitive at: index)
			withBinding: aDictionary]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> reset [

	self connections do: [:connection | connection reset]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> searchRootFor: aVisualPrimitive at: anIndex [

	^ aVisualPrimitive connections at: anIndex
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	self label ifNotNil: [ | variableIndex |
		variableIndex := self label asInteger.
		(aCollection at: variableIndex)
			ifNotNil: [:previousValue | ^ previousValue = aVisualPrimitive]
			ifNil: [aCollection at: variableIndex put: aVisualPrimitive]].
	^ (self couldMatch: aVisualPrimitive) and: [self connections withIndexAllSatisfy: [:connection :index | connection setBindingFor: (connection searchRootFor: aVisualPrimitive at: index) in: aCollection]]
]
