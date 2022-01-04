Class {
	#name : #SBVPPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'searchStack',
		'variableCount',
		'performedMatch',
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
		ifFalse: [aVisualPrimitive copy connections: (aVisualPrimitive connections collect: [:primitive | self build: aPattern fromBinding: anArray currentPrimitive: primitive])]
]

{ #category : #accessing }
SBVPPatternMatcher >> currentPrimitive [

	^ self searchStack last
]

{ #category : #accessing }
SBVPPatternMatcher >> currentPrimitive: aPrimitive [

	self searchStack: LinkedList new.
	self searchStack addLast: aPrimitive.
	self visitedPrimitives: Set new.
	self visitedPrimitives add: aPrimitive.
]

{ #category : #accessing }
SBVPPatternMatcher >> dealWithUndefinedResult [

	(self strategy at: #explicitRootMatching ifAbsent: [true]) ifTrue: [^ nil].
	
	[self searchStack notEmpty] whileTrue: [
		self currentPrimitive connections do: [:aConnection |
			(self visitedPrimitives includes: aConnection) ifFalse: [
				self pattern reset.
				self performedMatch: false.
				self searchStack addLast: aConnection.
				self visitedPrimitives add: aConnection.
				^ self getNextMatch]].
		self searchStack removeLast].
	^ nil
]

{ #category : #accessing }
SBVPPatternMatcher >> emptyBindingArray [

	^ Array new: self pattern highestBindingVariable
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
	bindings := self emptyBindingArray.
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
SBVPPatternMatcher >> input: anObject [

	self currentPrimitive: anObject.
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
SBVPPatternMatcher >> pattern: anObject [

	pattern := anObject
]

{ #category : #accessing }
SBVPPatternMatcher >> performedMatch [

	^ performedMatch
]

{ #category : #accessing }
SBVPPatternMatcher >> performedMatch: anObject [

	performedMatch := anObject
]

{ #category : #accessing }
SBVPPatternMatcher >> searchStack [

	^ searchStack
]

{ #category : #accessing }
SBVPPatternMatcher >> searchStack: anObject [

	searchStack := anObject
]

{ #category : #accessing }
SBVPPatternMatcher >> strategy [

	^ strategy
]

{ #category : #accessing }
SBVPPatternMatcher >> strategy: aDict [

	strategy := aDict.
]

{ #category : #accessing }
SBVPPatternMatcher >> variableCount [

	^ variableCount
]

{ #category : #accessing }
SBVPPatternMatcher >> variableCount: anObject [

	variableCount := anObject
]

{ #category : #accessing }
SBVPPatternMatcher >> visitedPrimitives [

	^ visitedPrimitives
]

{ #category : #accessing }
SBVPPatternMatcher >> visitedPrimitives: anObject [

	visitedPrimitives := anObject
]
