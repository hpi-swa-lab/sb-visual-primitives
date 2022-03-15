"
An SBPatternMatcher is used for pattern matching. It tries to match the defined pattern in the SBTransformation to the input.

Instance Variables
	pattern:					SBGroupPattern
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
			- if true, the root of every SBBindingPattern only matches the root of the input
			- if false, the pattern can also match somewhere else in the input without further specification
		- #explicitChildrenMatching -> true
			- if true, every child has to be specified explicitly
			- if false, the pattern can also match if the specified patternChildren have more siblings than the pattern has
		- if there are no patternChildren specified in the pattern, an SBEllipsisPattern is implicitely added

visitedPrimitives
	- set of all visited primitives during the pattern matching

"
Class {
	#name : #SBPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'performedMatch',
		'searchStack',
		'strategy',
		'visitedPrimitives'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPatternMatcher class >> input: aDomainBlock pattern: anSBGroupPattern [

	^ self new input: aDomainBlock pattern: anSBGroupPattern
]

{ #category : #'as yet unclassified' }
SBPatternMatcher >> build: aPattern fromBinding: anArray [

	^ self build: aPattern fromBinding: anArray currentPrimitive: self searchStack first
]

{ #category : #'as yet unclassified' }
SBPatternMatcher >> build: aPattern fromBinding: anArray currentPrimitive: aDomainBlock [

	| subtreeRoot |
	subtreeRoot := self searchStack last.
	^ aDomainBlock = subtreeRoot
		ifTrue: [(aPattern buildFromBinding: anArray) first]
		ifFalse: [aDomainBlock copy patternChildren: (aDomainBlock patternChildren collect: [:primitive | self build: aPattern fromBinding: anArray currentPrimitive: primitive])]
]

{ #category : #accessing }
SBPatternMatcher >> currentPrimitive [

	^ self searchStack last
]

{ #category : #accessing }
SBPatternMatcher >> currentPrimitive: aDomainBlock [

	self searchStack: LinkedList new.
	self searchStack addLast: aDomainBlock.
	self visitedPrimitives: Set new.
	self visitedPrimitives add: aDomainBlock
]

{ #category : #accessing }
SBPatternMatcher >> dealWithUndefinedResult [

	(self strategy at: #explicitRootMatching ifAbsent: [true]) ifTrue: [^ nil].
	
	[self searchStack notEmpty] whileTrue: [
		self currentPrimitive patternChildren do: [:aChild |
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
SBPatternMatcher >> explicitChildrenMatching [

	^ self strategy at: #explicitChildrenMatching ifAbsent: [true]
]

{ #category : #'as yet unclassified' }
SBPatternMatcher >> getAllMatches [

	| matches match |
	matches := OrderedCollection new.
	[match := self getNextMatch] whileNotNil: [matches add: match].
	^ matches
]

{ #category : #accessing }
SBPatternMatcher >> getMatch [

	| bindings |
	bindings := Dictionary new.
	(self pattern setBindingFor: self currentPrimitive in: bindings) ifFalse: [^ self getNextMatch].
	(self pattern matches: self currentPrimitive withBinding: bindings) ifFalse: [^ self getNextMatch].
	^ bindings
]

{ #category : #accessing }
SBPatternMatcher >> getNextMatch [

	self performedMatch
		ifTrue: [(self pattern getNext: self currentPrimitive) ifFalse: [^ self dealWithUndefinedResult]]
		ifFalse: [self performedMatch: true].
	
	^ self getMatch ifNil: [self dealWithUndefinedResult]
]

{ #category : #'as yet unclassified' }
SBPatternMatcher >> initialize [

	super initialize.
	self strategy: Dictionary new
]

{ #category : #accessing }
SBPatternMatcher >> input: aDomainBlock [

	self currentPrimitive: aDomainBlock.
	self pattern reset.
	self performedMatch: false
]

{ #category : #'as yet unclassified' }
SBPatternMatcher >> input: aDomainBlock pattern: anSBGroupPattern [

	self
		pattern: anSBGroupPattern;
		currentPrimitive: aDomainBlock;
		performedMatch: false
]

{ #category : #accessing }
SBPatternMatcher >> pattern [

	^ pattern
]

{ #category : #accessing }
SBPatternMatcher >> pattern: anSBGroupPattern [

	pattern := anSBGroupPattern
]

{ #category : #accessing }
SBPatternMatcher >> performedMatch [

	^ performedMatch
]

{ #category : #accessing }
SBPatternMatcher >> performedMatch: aBoolean [

	performedMatch := aBoolean
]

{ #category : #accessing }
SBPatternMatcher >> searchStack [

	^ searchStack
]

{ #category : #accessing }
SBPatternMatcher >> searchStack: aLinkedList [

	searchStack := aLinkedList
]

{ #category : #accessing }
SBPatternMatcher >> strategy [

	^ strategy
]

{ #category : #accessing }
SBPatternMatcher >> strategy: aDict [

	strategy := aDict
]

{ #category : #accessing }
SBPatternMatcher >> visitedPrimitives [

	^ visitedPrimitives
]

{ #category : #accessing }
SBPatternMatcher >> visitedPrimitives: aSet [

	visitedPrimitives := aSet
]
