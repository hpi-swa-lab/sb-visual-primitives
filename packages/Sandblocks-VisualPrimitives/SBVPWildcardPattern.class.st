Class {
	#name : #SBVPWildcardPattern,
	#superclass : #SBVPBindingPattern,
	#instVars : [
		'visitedPrimitives',
		'searchStack'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #accessing }
SBVPWildcardPattern >> bindingFor: aVisualPrimitive [

	^ {#root -> self searchStack last. #leaf -> self currentTop} asDictionary
]

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> buildFromBinding: anArray [

	| binding |
	binding := anArray at: self bindingIndex.
	^ {self buildFromBinding: anArray currentPrimitive: (binding at: #root)}
]

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> buildFromBinding: anArray currentPrimitive: aVisualPrimitive [

	| output binding leaf |
	binding := anArray at: self bindingIndex.
	leaf := binding at: #leaf.
	
	output := aVisualPrimitive copy.
	aVisualPrimitive = leaf
		ifTrue: [output children: (self buildChildrenFromBinding: anArray)]
		ifFalse: [output children: (aVisualPrimitive children collect: [:primitive | self buildFromBinding: anArray currentPrimitive: primitive])].
	^ output
]

{ #category : #accessing }
SBVPWildcardPattern >> currentTop [

	^ self searchStack first
]

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> getCurrentPrimitive: aVisualPrimitive [

	^ self searchStack ifEmpty: [aVisualPrimitive] ifNotEmpty: [self currentTop]
]

{ #category : #accessing }
SBVPWildcardPattern >> getNext: aVisualPrimitive [

	(super getNext: aVisualPrimitive) ifTrue: [^ true].
	self searchStack isEmpty ifTrue: [
		self pushToStack: aVisualPrimitive.
		^ true].
	[self searchStack notEmpty] whileTrue: [
		self currentTop children do: [:child |
			(self visitedPrimitives includes: child) ifFalse: [
				self pushToStack: child.
				self resetChildren.
				^ true]].
		self searchStack removeFirst].
	^ false
]

{ #category : #accessing }
SBVPWildcardPattern >> initialize [

	super initialize.
	self
		searchStack: LinkedList new;
		visitedPrimitives: Set new.
	self firstSubmorph addMorph: (SBIcon iconAsterisk scale: 1.5)
]

{ #category : #accessing }
SBVPWildcardPattern >> isBindingPattern [

	^ false
]

{ #category : #accessing }
SBVPWildcardPattern >> pushToStack: aVisualPrimitive [

	self searchStack addFirst: aVisualPrimitive.
	self visitedPrimitives add: aVisualPrimitive
]

{ #category : #'as yet unclassified' }
SBVPWildcardPattern >> reset [

	super reset.
	self searchStack: LinkedList new
]

{ #category : #accessing }
SBVPWildcardPattern >> searchStack [

	^ searchStack
]

{ #category : #accessing }
SBVPWildcardPattern >> searchStack: anObject [

	searchStack := anObject
]

{ #category : #accessing }
SBVPWildcardPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	self assert: (self searchStack isEmpty or: [self searchStack last = aVisualPrimitive]).
	
	self searchStack isEmpty ifTrue: [self pushToStack: aVisualPrimitive].
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
