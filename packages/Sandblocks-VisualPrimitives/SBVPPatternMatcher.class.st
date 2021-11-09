Class {
	#name : #SBVPPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'currentPrimitive',
		'variableCount',
		'performedMatch'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #accessing }
SBVPPatternMatcher >> currentPrimitive [

	^ currentPrimitive
]

{ #category : #accessing }
SBVPPatternMatcher >> currentPrimitive: anObject [

	currentPrimitive := anObject
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
	bindings := Array new: self variableCount.
	(self pattern setBindingFor: self currentPrimitive in: bindings) ifFalse: [^ self getNextMatch].
	(self pattern matches: self currentPrimitive withBinding: bindings) ifFalse: [^ self getNextMatch].
	^ bindings
]

{ #category : #accessing }
SBVPPatternMatcher >> getNextMatch [

	self performedMatch
		ifTrue: [(self pattern getNext: self currentPrimitive) ifFalse: [^ nil]]
		ifFalse: [self performedMatch: true].
	^ self getMatch
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

{ #category : #'as yet unclassified' }
SBVPPatternMatcher >> startMatching: aVisualPrimitive on: aPattern variableCount: anInteger [

	self
		pattern: aPattern;
		currentPrimitive: aVisualPrimitive;
		variableCount: anInteger;
		performedMatch: false
]

{ #category : #accessing }
SBVPPatternMatcher >> variableCount [

	^ variableCount
]

{ #category : #accessing }
SBVPPatternMatcher >> variableCount: anObject [

	variableCount := anObject
]
