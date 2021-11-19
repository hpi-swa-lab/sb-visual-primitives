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
SBVPPatternMatcherTest >> examplePatternSimpleTree [

	^ SBVPGroupPattern patterns: {
		(SBVPBindingPattern new: 1) connections: {SBVPBindingPattern new: 2. SBVPBindingPattern new: 3}.
		SBVPConstraintPattern constraint: [:a :b :c | a label = (b label + c label)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSimpleTreeOutput [

	^ (SBVPBindingPattern new: 1) connections: {SBVPBindingPattern new: 3. SBVPBindingPattern new: 2}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSingleNode [

	^ SBVPGroupPattern patterns: {SBVPBindingPattern new: 1. SBVPConstraintPattern constraint: [:a | a label = 10]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithEllipses [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern new connections: {
			SBVPEllipsisPattern new.
			(SBVPBindingPattern new: 1) connections: {
				(SBVPBindingPattern new: 2) connections: {SBVPEllipsisPattern new}.
				(SBVPBindingPattern new: 3) connections: {SBVPEllipsisPattern new}}.
			SBVPEllipsisPattern new}.
		SBVPConstraintPattern constraint: [:a :b :c | a label = (b label + c label)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithLabeledEllipses [

	^ (SBVPBindingPattern new: 1) connections: {SBVPEllipsisPattern new: 2. SBVPBindingPattern new: 3}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithLabeledEllipsesOutput [

	^ (SBVPBindingPattern new: 1) connections: {SBVPBindingPattern new: 3. SBVPEllipsisPattern new: 2}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodes [

	^ SBVPGroupPattern patterns: {
		(SBVPBindingPattern new: 1) connections: {SBVPBindingPattern new: 2}.
		SBVPConstraintPattern constraint: [:a :b | a label = (b label + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcard [

	^ SBVPGroupPattern patterns: {
		(SBVPBindingPattern new: 1) connections: {
			(SBVPWildcardPattern new: 3) connections: {(SBVPBindingPattern new: 2) connections: {SBVPWildcardPattern new: 4}}}.
		SBVPConstraintPattern constraint: [:a :b :c :d | a label = (b label + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcardOutput [

	^ (SBVPBindingPattern new: 1) connections: {
		(SBVPWildcardPattern new: 4) connections: {(SBVPWildcardPattern new: 3) connections: {SBVPBindingPattern new: 2}}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithWildcard [

	^ SBVPGroupPattern patterns: {
		(SBVPBindingPattern new: 1) connections: {
			SBVPWildcardPattern new connections: {(SBVPBindingPattern new: 2) connections: {SBVPWildcardPattern new}}}.
		SBVPConstraintPattern constraint: [:a :b | a label = (b label + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoWildcardList [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern new connections: {
			(SBVPBindingPattern new: 1) connections: {
				SBVPWildcardPattern new connections: {(SBVPBindingPattern new: 2) connections: {SBVPWildcardPattern new}}}}.
		SBVPConstraintPattern constraint: [:a :b | a label = (b label + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> getLabelList: aPrimitive [

	| currentPrimitive list |
	list := OrderedCollection new.
	currentPrimitive := aPrimitive.
	[currentPrimitive connections notEmpty] whileTrue: [
		list add: currentPrimitive label.
		currentPrimitive := currentPrimitive connections first].
	list add: currentPrimitive label.
	^ list
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> getLabelTree: aPrimitive [

	^ aPrimitive connections
		ifEmpty: [aPrimitive label]
		ifNotEmpty: [aPrimitive label -> (aPrimitive connections collect: [:connection | self getLabelTree: connection]) asArray]
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testComplexTree [

	| matcher root vp10 vp3 vp7 vp1 |
	root := (self buildTree: {42 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) first.
	vp10 := root connections first.
	vp3 := vp10 connections first.
	vp7 := vp10 connections second.
	vp1 := vp3 connections first.
	matcher := SBVPPatternMatcher
		input: root
		pattern: self examplePatternTreeWithEllipses
		variableCount: 3.
	self
		assert: {
			{vp10. vp3. vp7}.
			{vp3. vp1. vp3 connections second}.
			{vp1. vp1 connections first. vp1 connections second}.
			{vp7. vp7 connections first. vp7 connections second}} asSet
		equals: matcher getAllMatches asSet
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testFiveNodesWithWildcard [

	| matcher primitives |
	primitives := self buildList: {5. 10. 5. 0. 5. 10. 5. 0. 5}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternTwoWildcardList
		variableCount: 2.
	self
		assert: {
			{primitives second. primitives fourth}.
			{primitives second. primitives eighth}.
			{primitives sixth. primitives eighth}}
		equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testMatchAllChildrenTree [

	| matcher root vp3 vp2 vp5 |
	root := (self buildTree: {10 -> {5 -> {2 -> {1. 1}. 3 -> {2. 1}}}}) first.
	vp5 := root connections first.
	vp2 := vp5 connections first.
	vp3 := vp5 connections second.
	matcher := SBVPPatternMatcher
		input: root
		pattern: self examplePatternTreeWithEllipses
		variableCount: 3.
	self
		assert: {
			{vp5. vp2. vp3}.
			{vp2. vp2 connections first. vp2 connections second}.
			{vp3. vp3 connections first. vp3 connections second}} asSet
		equals: matcher getAllMatches asSet
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTree [

	| matcher root |
	root := (self buildTree: {10 -> {7. 3}}) first.
	matcher := SBVPPatternMatcher
		input: root
		pattern: self examplePatternSimpleTree
		variableCount: 3.
	self
		assert: {{root. root connections first. root connections second}}
		equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTreeEllipsisOutput [

	| matcher root output |
	root := (self buildTree: {10 -> {1. 2 -> {-1}. 3. 4}}) first.
	matcher := SBVPPatternMatcher
		input: root
		pattern: self examplePatternTreeWithLabeledEllipses
		variableCount: 3.
	
	output := self examplePatternTreeWithLabeledEllipsesOutput buildFromBinding: matcher getNextMatch.
	
	self assert: 10 -> {4. 1. 2 -> {-1}. 3} equals: (self getLabelTree: output first)
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTreeOutput [

	| matcher root output |
	root := (self buildTree: {10 -> {7. 3}}) first.
	matcher := SBVPPatternMatcher
		input: root
		pattern: self examplePatternSimpleTree
		variableCount: 3.
	output := (self examplePatternSimpleTreeOutput buildFromBinding: matcher getNextMatch) first.
	self
		assert: {10. 3. 7}
		equals: {output label. output connections first label. output connections second label}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSingleNodeMatch [

	| matcher primitives |
	primitives := self buildList: {10}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternSingleNode
		variableCount: 1.
	self assert: {{primitives first}} equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testThreeNodesWithWildcard [

	| matcher primitives |
	primitives := self buildList: {10. 42. 0. 0. 42}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternTwoNodesWithWildcard
		variableCount: 2.
	self
		assert: {{primitives first. primitives third}. {primitives first. primitives fourth}}
		equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testThreeNodesWithWildcardOutput [

	| matcher primitives output |
	primitives := self buildList: {10. 101. 102. 0. 103}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternTwoNodesWithLabeledWildcard
		variableCount: 4.
	
	output := (self examplePatternTwoNodesWithLabeledWildcardOutput buildFromBinding: matcher getNextMatch) first.
	
	self assert: {10. 103. 101. 102. 0} equals: (self getLabelList: output) asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testTwoNodesWithoutWildcard [

	| matcher primitives |
	primitives := self buildList: {10. 0}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternTwoNodes
		variableCount: 2.
	self assert: {{primitives first. primitives second}} equals: matcher getAllMatches asArray
]
