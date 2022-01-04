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
SBVPPatternMatcherTest >> examplePatternChildSmallerThanParent [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: 1 connections: {
			SBVPEllipsisPattern bindingIndex: 2.
			SBVPBindingPattern bindingIndex: 3 connections: {SBVPEllipsisPattern bindingIndex: 5}.
			SBVPEllipsisPattern bindingIndex: 4}.
		SBVPConstraintPattern constraint: [:a :b :c :d :e | c label asInteger < a label asInteger]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternChildSmallerThanParentOutput [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: 3 connections: {
			SBVPEllipsisPattern bindingIndex: 2.
			SBVPBindingPattern bindingIndex: 1 connections: {SBVPEllipsisPattern bindingIndex: 5}.
			SBVPEllipsisPattern bindingIndex: 4}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSimpleTree [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern
			bindingIndex: 1
			connections: {SBVPBindingPattern bindingIndex: 2. SBVPBindingPattern bindingIndex: 3}.
		SBVPConstraintPattern constraint: [:a :b :c | a label asInteger = (b label asInteger + c label asInteger)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSimpleTreeOutput [

	^ SBVPBindingPattern
		bindingIndex: 1
		connections: {SBVPBindingPattern bindingIndex: 3. SBVPBindingPattern bindingIndex: 2}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSingleNode [

	^ SBVPGroupPattern patterns: {SBVPBindingPattern bindingIndex: 1. SBVPConstraintPattern constraint: [:a | a label asInteger = 10]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSortTree [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingIndex: 6 connections: {
			SBVPEllipsisPattern bindingIndex: 7.
			SBVPBindingPattern bindingIndex: 1 connections: {
				SBVPBindingPattern bindingIndex: 2 connections: {SBVPEllipsisPattern bindingIndex: 4}.
				SBVPBindingPattern bindingIndex: 3 connections: {SBVPEllipsisPattern bindingIndex: 5}}.
			SBVPEllipsisPattern bindingIndex: 8}.
		SBVPConstraintPattern constraint: [:a :b :c :d :e :f :g :h | b label asInteger > c label asInteger]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSortTreeOutput [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingIndex: 6 connections: {
			SBVPEllipsisPattern bindingIndex: 7.
			SBVPBindingPattern bindingIndex: 1 connections: {
				SBVPBindingPattern bindingIndex: 3 connections: {SBVPEllipsisPattern bindingIndex: 5}.
				SBVPBindingPattern bindingIndex: 2 connections: {SBVPEllipsisPattern bindingIndex: 4}}.
			SBVPEllipsisPattern bindingIndex: 8}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithEllipses [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingIndex: 4 connections: {
			SBVPEllipsisPattern bindingIndex: 5.
			SBVPBindingPattern bindingIndex: 1 connections: {
				SBVPBindingPattern bindingIndex: 2 connections: {SBVPEllipsisPattern bindingIndex: 6}.
				SBVPBindingPattern bindingIndex: 3 connections: {SBVPEllipsisPattern bindingIndex: 7}}.
			SBVPEllipsisPattern bindingIndex: 8}.
		SBVPConstraintPattern constraint: [:a :b :c | a label asInteger = (b label asInteger + c label asInteger)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithLabeledEllipses [

	^ SBVPBindingPattern
		bindingIndex: 1
		connections: {SBVPEllipsisPattern bindingIndex: 2. SBVPBindingPattern bindingIndex: 3}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithLabeledEllipsesOutput [

	^ SBVPBindingPattern
		bindingIndex: 1
		connections: {SBVPBindingPattern bindingIndex: 3. SBVPEllipsisPattern bindingIndex: 2}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodes [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: 1 connections: {SBVPBindingPattern bindingIndex: 2}.
		SBVPConstraintPattern constraint: [:a :b | a label asInteger = (b label asInteger + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcard [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: 1 connections: {
			SBVPWildcardPattern
				bindingIndex: 3
				connections: {SBVPBindingPattern bindingIndex: 2 connections: {SBVPWildcardPattern bindingIndex: 4}}}.
		SBVPConstraintPattern constraint: [:a :b :c :d | a label asInteger = (b label asInteger + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcardOutput [

	^ SBVPBindingPattern bindingIndex: 1 connections: {
		SBVPWildcardPattern
			bindingIndex: 4
			connections: {SBVPWildcardPattern bindingIndex: 3 connections: {SBVPBindingPattern bindingIndex: 2}}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithWildcard [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: 1 connections: {
			SBVPWildcardPattern
				bindingIndex: 3
				connections: {SBVPBindingPattern bindingIndex: 2 connections: {SBVPWildcardPattern bindingIndex: 4}}}.
		SBVPConstraintPattern constraint: [:a :b | a label asInteger = (b label asInteger + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoWildcardList [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingIndex: 3 connections: {
			SBVPBindingPattern bindingIndex: 1 connections: {
				SBVPWildcardPattern
					bindingIndex: 4
					connections: {SBVPBindingPattern bindingIndex: 2 connections: {SBVPWildcardPattern bindingIndex: 5}}}}.
		SBVPConstraintPattern constraint: [:a :b | a label asInteger = (b label asInteger + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> getLabelList: aPrimitive [

	| currentPrimitive list |
	list := OrderedCollection new.
	currentPrimitive := aPrimitive.
	[currentPrimitive connections notEmpty] whileTrue: [
		list add: currentPrimitive label asInteger.
		currentPrimitive := currentPrimitive connections first].
	list add: currentPrimitive label asInteger.
	^ list
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> getLabelTree: aPrimitive [

	^ aPrimitive connections
		ifEmpty: [aPrimitive label asInteger]
		ifNotEmpty: [aPrimitive label asInteger -> (aPrimitive connections collect: [:connection | self getLabelTree: connection]) asArray]
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
		pattern: self examplePatternTreeWithEllipses.
	self
		assert: {
			{vp10. vp3. vp7}.
			{vp3. vp1. vp3 connections second}.
			{vp1. vp1 connections first. vp1 connections second}.
			{vp7. vp7 connections first. vp7 connections second}} asSet
		equals: (matcher getAllMatches collect: [:match | {match first. match second. match third}]) asSet
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testConstantsWork [

	| tree resultingTree |
	tree := SBVPDummyNode buildTree: {9 -> {10 -> {8}}}.
	resultingTree := SBVPExecuter exampleWithConstants: tree.
	self assert: {10. 8. 9} equals: (self getLabelList: resultingTree asVisualPrimitive) asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testFiveNodesWithWildcard [

	| matcher primitives |
	primitives := self buildList: {5. 10. 5. 0. 5. 10. 5. 0. 5}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternTwoWildcardList.
	self
		assert: {
			{primitives second. primitives fourth}.
			{primitives second. primitives eighth}.
			{primitives sixth. primitives eighth}}
		equals: (matcher getAllMatches collect: [:match | {match first. match second}]) asArray
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
		pattern: self examplePatternTreeWithEllipses.
	self
		assert: {
			{vp5. vp2. vp3}.
			{vp2. vp2 connections first. vp2 connections second}.
			{vp3. vp3 connections first. vp3 connections second}} asSet
		equals: (matcher getAllMatches collect: [:match | {match first. match second. match third}]) asSet
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTree [

	| matcher root |
	root := (self buildTree: {10 -> {7. 3}}) first.
	matcher := SBVPPatternMatcher input: root pattern: self examplePatternSimpleTree.
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
		pattern: self examplePatternTreeWithLabeledEllipses.
	
	output := self examplePatternTreeWithLabeledEllipsesOutput buildFromBinding: matcher getNextMatch.
	
	self assert: 10 -> {4. 1. 2 -> {-1}. 3} equals: (self getLabelTree: output first)
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTreeOutput [

	| matcher root output |
	root := (self buildTree: {10 -> {7. 3}}) first.
	matcher := SBVPPatternMatcher input: root pattern: self examplePatternSimpleTree.
	output := (self examplePatternSimpleTreeOutput buildFromBinding: matcher getNextMatch) first.
	self assert: 10 -> {3. 7} equals: (self getLabelTree: output)
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSingleNodeMatch [

	| matcher primitives |
	primitives := self buildList: {10}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternSingleNode.
	self assert: {{primitives first}} equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSortTreeOutput [

	| root output |
	root := (self buildTree: {0 -> {1 -> {3 -> {5. 4}. 2 -> {6. 7}}}}) first.
	output := (SBVPCase
		input: SBVPPatternMatcherTest new examplePatternSortTree
		output: SBVPPatternMatcherTest new examplePatternSortTreeOutput) replaceAllMatches: root.
	self assert: {0 -> {1 -> {2 -> {6. 7}. 3 -> {4. 5}}}} equals: {self getLabelTree: output}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testThreeNodesWithWildcard [

	| matcher primitives |
	primitives := self buildList: {10. 42. 0. 0. 42}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternTwoNodesWithWildcard.
	self
		assert: {{primitives first. primitives third}. {primitives first. primitives fourth}}
		equals: (matcher getAllMatches collect: [:match | {match first. match second}]) asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testThreeNodesWithWildcardOutput [

	| matcher primitives output match |
	primitives := self buildList: {10. 101. 102. 0. 103}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternTwoNodesWithLabeledWildcard.
	
	match := matcher getNextMatch.
	self assert: match notNil.
	
	output := (self examplePatternTwoNodesWithLabeledWildcardOutput buildFromBinding: match) first.
	
	self assert: {10. 103. 101. 102. 0} equals: (self getLabelList: output) asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testTwoNodesWithoutWildcard [

	| matcher primitives |
	primitives := self buildList: {10. 0}.
	matcher := SBVPPatternMatcher
		input: primitives first
		pattern: self examplePatternTwoNodes.
	self assert: {{primitives first. primitives second}} equals: matcher getAllMatches asArray
]
