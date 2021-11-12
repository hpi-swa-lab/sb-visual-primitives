Class {
	#name : #SBVPBindingPattern,
	#superclass : #SBVisualPrimitive,
	#instVars : [
		'firstChildOffset',
		'canMatchAllChildren'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #accessing }
SBVPBindingPattern >> canMatchAllChildren [

	^ canMatchAllChildren
]

{ #category : #accessing }
SBVPBindingPattern >> canMatchAllChildren: anObject [

	canMatchAllChildren := anObject
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> couldMatch: aVisualPrimitive [

	^ self connections size + self firstChildOffset <= aVisualPrimitive connections size
]

{ #category : #accessing }
SBVPBindingPattern >> firstChildOffset [

	^ firstChildOffset
]

{ #category : #accessing }
SBVPBindingPattern >> firstChildOffset: anObject [

	firstChildOffset := anObject
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> getCurrentPrimitive: aVisualPrimitive [

	^ aVisualPrimitive
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> getNext: aVisualPrimitive [

	| currentPrimitive |
	currentPrimitive := self getCurrentPrimitive: aVisualPrimitive.
	(self couldMatch: currentPrimitive) ifTrue: [
		self connections withIndexDo: [:connection :index |
			(connection getNext: (connection searchRootFor: currentPrimitive at: index + self firstChildOffset))
				ifTrue: [^ true]
				ifFalse: [connection reset]]].
	(self canMatchAllChildren and: [self connections notEmpty]) ifTrue: [
		self firstChildOffset: self firstChildOffset + 1.
		(self couldMatch: currentPrimitive)
			ifTrue: [
				self resetChildren.
				^ true]
			ifFalse: [self reset]].
	^ false
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> initialize [

	super initialize.
	self
		firstChildOffset: 0;
		canMatchAllChildren: true
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self connections withIndexAllSatisfy: [:connection :index |
		connection
			matches: (connection
				searchRootFor: (self getCurrentPrimitive: aVisualPrimitive)
				at: index + self firstChildOffset)
			withBinding: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> reset [

	self
		firstChildOffset: 0;
		resetChildren
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> resetChildren [

	self connections do: [:connection | connection reset]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> searchRootFor: aVisualPrimitive at: anIndex [

	^ aVisualPrimitive connections at: anIndex
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	| currentPrimitive |
	currentPrimitive := self getCurrentPrimitive: aVisualPrimitive.
	self label ifNotNil: [ | variableIndex |
		variableIndex := self label asInteger.
		(aCollection at: variableIndex)
			ifNotNil: [:previousValue | ^ previousValue = currentPrimitive]
			ifNil: [aCollection at: variableIndex put: currentPrimitive]].
	^ (self couldMatch: currentPrimitive) and: [self setConnectionBindingFor: currentPrimitive in: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> setConnectionBindingFor: aVisualPrimitive in: aCollection [

	^ self connections withIndexAllSatisfy: [:connection :index |
		connection
			setBindingFor: (connection
				searchRootFor: (self getCurrentPrimitive: aVisualPrimitive)
				at: index + self firstChildOffset)
			in: aCollection]
]
