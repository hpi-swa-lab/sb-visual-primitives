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

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> getCurrentPrimitive: aVisualPrimitive [

	^ self dfsStack ifEmpty: [aVisualPrimitive] ifNotEmpty: [self currentTop]
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

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> indexOffset [

	^ (self dfsStack isEmpty and: [self childrenInCurrentMatch <= 0])
		ifTrue: [-1]
		ifFalse: [0]
]

{ #category : #accessing }
SBVPWildcardPattern >> initialize [

	super initialize.
	self
		dfsStack: LinkedList new;
		visitedPrimitives: Set new;
		addMorph: SBIcon iconStar.
]

{ #category : #accessing }
SBVPWildcardPattern >> pushToStack: aVisualPrimitive [

	self dfsStack addFirst: aVisualPrimitive.
	self visitedPrimitives add: aVisualPrimitive
]

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> reset [

	super reset.
	self dfsStack: LinkedList new
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
