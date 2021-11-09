Class {
	#name : #SBVPWildcardPattern,
	#superclass : #SBVPBindingPattern,
	#instVars : [
		'visitedPrimitives',
		'dfsStack'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #accessing }
SBVPWildcardPattern >> currentTop [

	^ self dfsStack first
]

{ #category : #accessing }
SBVPWildcardPattern >> dfsStack [

	^ dfsStack
]

{ #category : #accessing }
SBVPWildcardPattern >> dfsStack: anObject [

	dfsStack := anObject
]

{ #category : #accessing }
SBVPWildcardPattern >> getNext: aVisualPrimitive [

	(super getNext: aVisualPrimitive) ifTrue: [^ true].
	self dfsStack isEmpty ifTrue: [
		self pushToStack: aVisualPrimitive.
		^ true].
	[self dfsStack notEmpty] whileTrue: [
		self currentTop connections do: [:connection |
			(self visitedPrimitives includes: connection) ifFalse: [
				self pushToStack: connection.
				self resetChildren.
				^ true]].
		self dfsStack removeFirst].
	^ false
]

{ #category : #accessing }
SBVPWildcardPattern >> initialize [

	super initialize.
	self
		dfsStack: LinkedList new;
		visitedPrimitives: Set new
]

{ #category : #accessing }
SBVPWildcardPattern >> pushToStack: aVisualPrimitive [

	self dfsStack addFirst: aVisualPrimitive.
	self visitedPrimitives add: aVisualPrimitive
]

{ #category : #accessing }
SBVPWildcardPattern >> resetChildren [

	self connections do: [:connection | connection reset]
]

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> searchRootFor: aVisualPrimitive at: anIndex [

	^ aVisualPrimitive
]

{ #category : #accessing }
SBVPWildcardPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	self assert: (self dfsStack isEmpty or: [self dfsStack last = aVisualPrimitive]).
	self dfsStack isEmpty ifTrue: [self pushToStack: aVisualPrimitive].
	^ super setBindingFor: self currentTop in: aCollection
]

{ #category : #accessing }
SBVPWildcardPattern >> visitedPrimitives [

	^ visitedPrimitives
]

{ #category : #accessing }
SBVPWildcardPattern >> visitedPrimitives: anObject [

	visitedPrimitives := anObject
]
