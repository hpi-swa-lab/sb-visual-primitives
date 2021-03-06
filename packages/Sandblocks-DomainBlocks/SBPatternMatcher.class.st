"
An SBPatternMatcher is used for pattern matching. It tries to match the defined pattern in the SBTransformation to the input.

Instance Variables
	pattern:					SBGroupPattern
	performedMatch:		Boolean
	searchStack:			LinkedList
	strategy:					Dictionary
	visited:					Set

pattern
	- the defined pattern that is used for pattern matching

performedMatch
	- indicates whether the pattern matched on input

searchStack
	- the current stack of the depth-first search searching for a possible ""root"" when using implicit RootMatching

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

visited
	- the domain blocks that have already been found by the depth-first search searching for a possible ""root"" when using implicit RootMatching

"
Class {
	#name : #SBPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'performedMatch',
		'searchStack',
		'strategy',
		'visited'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #'as yet unclassified' }
SBPatternMatcher class >> input: aDomainBlock pattern: anSBGroupPattern [

	^ self new input: aDomainBlock pattern: anSBGroupPattern
]

{ #category : #'output creation' }
SBPatternMatcher >> build: aPattern fromBinding: anArray [

	^ self build: aPattern fromBinding: anArray currentPrimitive: self searchStack first
]

{ #category : #'output creation' }
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
	self visited: Set new.
	self visited add: aDomainBlock
]

{ #category : #accessing }
SBPatternMatcher >> dealWithUndefinedResult [

	(self strategy at: #explicitRootMatching ifAbsent: [true]) ifTrue: [^ nil].
	
	[self searchStack notEmpty] whileTrue: [
		self currentPrimitive patternChildren do: [:aChild |
			(self visited includes: aChild) ifFalse: [
				self pattern reset.
				self performedMatch: false.
				self searchStack addLast: aChild.
				self visited add: aChild.
				^ self getNextMatch]].
		self searchStack removeLast].
	^ nil
]

{ #category : #accessing }
SBPatternMatcher >> explicitChildrenMatching [

	^ self strategy at: #explicitChildrenMatching ifAbsent: [true]
]

{ #category : #'output creation' }
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

{ #category : #accessing }
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

{ #category : #accessing }
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
SBPatternMatcher >> visited [

	^ visited
]

{ #category : #accessing }
SBPatternMatcher >> visited: aSet [

	visited := aSet
]
