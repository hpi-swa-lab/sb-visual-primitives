Class {
	#name : #SBVPPatternMatcher,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'currentPrimitive',
		'variableCount'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPatternMatcher class >> example [

	| matcher |
	matcher := self new.
	matcher startMatching: (SBVisualPrimitive new: 10) on: SBVPPattern example variableCount: 1.
	^ matcher getMatch
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher class >> example2 [

	| matcher |
	matcher := self new.
	matcher
		startMatching: ((SBVisualPrimitive new: 10) connections: {SBVisualPrimitive new: 0})
		on: SBVPPattern example2
		variableCount: 2.
	^ matcher getMatch
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher class >> example3 [

	| matcher |
	matcher := self new.
	matcher
		startMatching: ((SBVisualPrimitive new: 10) connections: {SBVisualPrimitive new: 0})
		on: SBVPPattern example3
		variableCount: 2.
	^ matcher getMatch
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher class >> example4 [

	| matcher |
	matcher := self new.
	matcher
		startMatching: ((SBVisualPrimitive new: 10) connections: {(SBVisualPrimitive new: 0) connections: {SBVisualPrimitive new: 0}})
		on: SBVPPattern example3
		variableCount: 2.
	^ {matcher getMatch. matcher getNextMatch. matcher getNextMatch}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcher class >> example5 [

	| matcher |
	matcher := self new.
	matcher
		startMatching: ((SBVisualPrimitive new: 10) connections: {(SBVisualPrimitive new: 0) connections: {SBVisualPrimitive new: 0}})
		on: SBVPPattern example5
		variableCount: 2.
	^ {matcher getMatch. matcher getNextMatch. matcher getNextMatch}
]

{ #category : #accessing }
SBVPPatternMatcher >> currentPrimitive [

	^ currentPrimitive
]

{ #category : #accessing }
SBVPPatternMatcher >> currentPrimitive: anObject [

	currentPrimitive := anObject
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

	(self pattern getNext: self currentPrimitive) ifFalse: [^ nil].
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

{ #category : #'as yet unclassified' }
SBVPPatternMatcher >> startMatching: aVisualPrimitive on: aPattern variableCount: anInteger [

	self
		pattern: aPattern;
		currentPrimitive: aVisualPrimitive;
		variableCount: anInteger
]

{ #category : #accessing }
SBVPPatternMatcher >> variableCount [

	^ variableCount
]

{ #category : #accessing }
SBVPPatternMatcher >> variableCount: anObject [

	variableCount := anObject
]
