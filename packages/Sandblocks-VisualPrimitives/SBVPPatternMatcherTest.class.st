Class {
	#name : #SBVPPatternMatcherTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> buildList: aCollection [

	| previousPrimitive primitives numbers |
	numbers := aCollection asOrderedCollection.
	previousPrimitive := SBVisualPrimitive new: numbers removeLast.
	primitives := LinkedList new
		add: previousPrimitive;
		yourself.
	numbers reverseDo: [:element |
		previousPrimitive := (SBVisualPrimitive new: element) connections: {previousPrimitive}.
		primitives addFirst: previousPrimitive].
	^ primitives asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> buildTree: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(SBVisualPrimitive new: element key) connections: (self buildTree: element value)]
			ifFalse: [SBVisualPrimitive new: element]]
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testComplexTree [

	| matcher root vp10 vp3 vp7 vp1 |
	matcher := SBVPPatternMatcher new.
	root := (self buildTree: {42 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) first.
	vp10 := root connections first.
	vp3 := vp10 connections first.
	vp7 := vp10 connections second.
	vp1 := vp3 connections first.
	matcher startMatching: root on: SBVPPattern example7 variableCount: 3.
	self
		assert: {
			{vp10. vp3. vp7}.
			{vp3. vp1. vp3 connections second}.
			{vp1. vp1 connections first. vp1 connections second}.
			{vp7. vp7 connections first. vp7 connections second}}
		equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testFiveNodesWithWildcard [

	| matcher primitives |
	matcher := SBVPPatternMatcher new.
	primitives := self buildList: {5. 10. 0. 10. 0}.
	matcher startMatching: primitives first on: SBVPPattern example5 variableCount: 2.
	self
		assert: {
			{primitives second. primitives third}.
			{primitives second. primitives fifth}.
			{primitives fourth. primitives fifth}}
		equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTree [

	| matcher root |
	matcher := SBVPPatternMatcher new.
	root := (self buildTree: {10 -> {7. 3}}) first.
	matcher startMatching: root on: SBVPPattern example6 variableCount: 3.
	self
		assert: {{root. root connections first. root connections second}}
		equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSingleNodeMatch [

	| matcher primitives |
	matcher := SBVPPatternMatcher new.
	primitives := self buildList: {10}.
	matcher startMatching: primitives first on: SBVPPattern example variableCount: 1.
	self assert: {{primitives first}} equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testThreeNodesWithWildcard [

	| matcher primitives |
	matcher := SBVPPatternMatcher new.
	primitives := self buildList: {10. 0. 0}.
	matcher startMatching: primitives first on: SBVPPattern example4 variableCount: 2.
	self
		assert: {{primitives first. primitives second}. {primitives first. primitives third}}
		equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testTwoNodesWithWildcard [

	| matcher primitives |
	matcher := SBVPPatternMatcher new.
	primitives := self buildList: {10. 0}.
	matcher startMatching: primitives first on: SBVPPattern example3 variableCount: 2.
	self assert: {{primitives first. primitives second}} equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testTwoNodesWithoutWildcard [

	| matcher primitives |
	matcher := SBVPPatternMatcher new.
	primitives := self buildList: {10. 0}.
	matcher startMatching: primitives first on: SBVPPattern example2 variableCount: 2.
	self assert: {{primitives first. primitives second}} equals: matcher getAllMatches asArray
]
