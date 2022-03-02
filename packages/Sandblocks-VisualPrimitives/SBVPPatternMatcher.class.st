"
An SBVPPatternMatcher is used for pattern matching. It tries to match the defined pattern in the SBVPTransformation to the input.

Instance Variables
	pattern:					Pattern
	performedMatch:		Boolean
	searchStack:			LinkedList
	strategy:					Dictionary
	visitedPrimitives:		Set

pattern
	- the defined pattern that is used for pattern matching

performedMatch
	- indicates whether the pattern matched on input

searchStack
	- stack that contains all possible matchable primitives

strategy
	- a dict to specify the matching strategy
	- current specifiers with their defaults:
		- #explicitRootMatching -> true
			- if true, the root of every SBVPBindingPattern only matches the root of the input
			- if false, the pattern can also match somewhere else in the input without further specification
		- #explicitChildrenMatching -> true
			- if true, every child has to be specified explicitly
			- if false, the pattern can also match if the specified children have more siblings than the pattern has
		- if there are no children specified in the pattern, an SBVPEllipsisPattern is implicitely added

visitedPrimitives
	- set of all visited primitives during the pattern matching

"
Class {
	#name : #SBVPPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'performedMatch',
		'searchStack',
		'strategy',
		'visitedPrimitives'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPatternMatcher class >> input: aVisualPrimitive pattern: aPattern [

	^ self new input: aVisualPrimitive pattern: aPattern
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher >> build: aPattern fromBinding: anArray [

	^ self build: aPattern fromBinding: anArray currentPrimitive: self searchStack first
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher >> build: aPattern fromBinding: anArray currentPrimitive: aVisualPrimitive [

	| subtreeRoot |
	subtreeRoot := self searchStack last.
	^ aVisualPrimitive = subtreeRoot
		ifTrue: [(aPattern buildFromBinding: anArray) first]
		ifFalse: [aVisualPrimitive copy children: (aVisualPrimitive children collect: [:primitive | self build: aPattern fromBinding: anArray currentPrimitive: primitive])]
]

{ #category : #accessing }
SBVPPatternMatcher >> currentPrimitive [

	^ self searchStack last
]

{ #category : #accessing }
SBVPPatternMatcher >> currentPrimitive: aVisualPrimitive [

	self searchStack: LinkedList new.
	self searchStack addLast: aVisualPrimitive.
	self visitedPrimitives: Set new.
	self visitedPrimitives add: aVisualPrimitive
]

{ #category : #accessing }
SBVPPatternMatcher >> dealWithUndefinedResult [

	(self strategy at: #explicitRootMatching ifAbsent: [true]) ifTrue: [^ nil].
	
	[self searchStack notEmpty] whileTrue: [
		self currentPrimitive children do: [:aChild |
			(self visitedPrimitives includes: aChild) ifFalse: [
				self pattern reset.
				self performedMatch: false.
				self searchStack addLast: aChild.
				self visitedPrimitives add: aChild.
				^ self getNextMatch]].
		self searchStack removeLast].
	^ nil
]

{ #category : #accessing }
SBVPPatternMatcher >> explicitChildrenMatching [

	^ self strategy at: #explicitChildrenMatching ifAbsent: [true]
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher >> getAllMatches [

	| matches match |
	matches := OrderedCollection new.
	[match := self getNextMatch] whileNotNil: [matches add: match].
	^ matches
]

{ #category : #accessing }
SBVPPatternMatcher >> getMatch [

	| bindings |
	bindings := Dictionary new.
	(self pattern setBindingFor: self currentPrimitive in: bindings) ifFalse: [^ self getNextMatch].
	(self pattern matches: self currentPrimitive withBinding: bindings) ifFalse: [^ self getNextMatch].
	^ bindings
]

{ #category : #accessing }
SBVPPatternMatcher >> getNextMatch [

	self performedMatch
		ifTrue: [(self pattern getNext: self currentPrimitive) ifFalse: [^ self dealWithUndefinedResult]]
		ifFalse: [self performedMatch: true].
	
	^ self getMatch ifNil: [self dealWithUndefinedResult]
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher >> initialize [

	super initialize.
	self strategy: Dictionary new
]

{ #category : #accessing }
SBVPPatternMatcher >> input: aVisualPrimitive [

	self currentPrimitive: aVisualPrimitive.
	self pattern reset.
	self performedMatch: false
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher >> input: aVisualPrimitive pattern: aPattern [

	self
		pattern: aPattern;
		currentPrimitive: aVisualPrimitive;
		performedMatch: false
]

{ #category : #accessing }
SBVPPatternMatcher >> pattern [

	^ pattern
]

{ #category : #accessing }
SBVPPatternMatcher >> pattern: aPattern [

	pattern := aPattern
]

{ #category : #accessing }
SBVPPatternMatcher >> performedMatch [

	^ performedMatch
]

{ #category : #accessing }
SBVPPatternMatcher >> performedMatch: aBoolean [

	performedMatch := aBoolean
]

{ #category : #accessing }
SBVPPatternMatcher >> searchStack [

	^ searchStack
]

{ #category : #accessing }
SBVPPatternMatcher >> searchStack: aLinkedList [

	searchStack := aLinkedList
]

{ #category : #accessing }
SBVPPatternMatcher >> strategy [

	^ strategy
]

{ #category : #accessing }
SBVPPatternMatcher >> strategy: aDict [

	strategy := aDict
]

{ #category : #accessing }
SBVPPatternMatcher >> visitedPrimitives [

	^ visitedPrimitives
]

{ #category : #accessing }
SBVPPatternMatcher >> visitedPrimitives: aSet [

	visitedPrimitives := aSet
]
