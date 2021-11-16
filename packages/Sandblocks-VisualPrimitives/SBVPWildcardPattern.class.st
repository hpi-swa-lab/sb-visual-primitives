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
SBVPWildcardPattern >> bindingFor: aVisualPrimitive [

	^ {#root -> self dfsStack last. #leaf -> self currentTop} asDictionary
	""""
]

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> buildFromBinding: anArray [

	| binding |
	binding := anArray at: self label asInteger.
	^ {self buildFromBinding: anArray currentPrimitive: (binding at: #root)}
]

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> buildFromBinding: anArray currentPrimitive: aVisualPrimitive [

	| output binding leaf |
	binding := anArray at: self label asInteger.
	leaf := binding at: #leaf.
	""
	""
	output := aVisualPrimitive copy.
	aVisualPrimitive = leaf
		ifTrue: [output connections: (self buildChildrenFromBinding: anArray)]
		ifFalse: [output connections: (aVisualPrimitive connections collect: [:primitive | self buildFromBinding: anArray currentPrimitive: primitive])].
	^ output
]

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

{ #category : #accessing }
SBVPWildcardPattern >> initialize [

	super initialize.
	self
		dfsStack: LinkedList new;
		visitedPrimitives: Set new;
		addMorph: SBIcon iconStar
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
