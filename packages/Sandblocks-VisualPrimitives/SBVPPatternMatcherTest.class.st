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
		previousPrimitive := (SBVisualPrimitive new: element) children: {previousPrimitive}.
		primitives addFirst: previousPrimitive].
	^ primitives asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> buildTree: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(SBVisualPrimitive new: element key) children: (self buildTree: element value)]
			ifFalse: [SBVisualPrimitive new: element]]
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternChildSmallerThanParent [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: #a children: {
			SBVPEllipsisPattern bindingIndex: #b.
			SBVPBindingPattern bindingIndex: #c children: {SBVPEllipsisPattern bindingIndex: #e}.
			SBVPEllipsisPattern bindingIndex: #d}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #c) label asInteger < (bindings at: #a) label asInteger]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternChildSmallerThanParentOutput [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: #c children: {
			SBVPEllipsisPattern bindingIndex: #b.
			SBVPBindingPattern bindingIndex: #a children: {SBVPEllipsisPattern bindingIndex: #e}.
			SBVPEllipsisPattern bindingIndex: #d}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSimpleTree [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern
			bindingIndex: #a
			children: {SBVPBindingPattern bindingIndex: #b. SBVPBindingPattern bindingIndex: #c}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger = ((bindings at: #b) label asInteger + (bindings at: #c) label asInteger)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSimpleTreeOutput [

	^ SBVPBindingPattern
		bindingIndex: #a
		children: {SBVPBindingPattern bindingIndex: #c. SBVPBindingPattern bindingIndex: #b}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSingleNode [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: #a.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger = 10]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSortTree [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingIndex: #f children: {
			SBVPEllipsisPattern bindingIndex: #g.
			SBVPBindingPattern bindingIndex: #a children: {
				SBVPBindingPattern bindingIndex: #b children: {SBVPEllipsisPattern bindingIndex: #d}.
				SBVPBindingPattern bindingIndex: #c children: {SBVPEllipsisPattern bindingIndex: #e}}.
			SBVPEllipsisPattern bindingIndex: #h}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #b) label asInteger > (bindings at: #c) label asInteger]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSortTreeOutput [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingIndex: #f children: {
			SBVPEllipsisPattern bindingIndex: #g.
			SBVPBindingPattern bindingIndex: #a children: {
				SBVPBindingPattern bindingIndex: #c children: {SBVPEllipsisPattern bindingIndex: #e}.
				SBVPBindingPattern bindingIndex: #b children: {SBVPEllipsisPattern bindingIndex: #d}}.
			SBVPEllipsisPattern bindingIndex: #h}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithEllipses [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingIndex: #d children: {
			SBVPEllipsisPattern bindingIndex: #e.
			SBVPBindingPattern bindingIndex: #a children: {
				SBVPBindingPattern bindingIndex: #b children: {SBVPEllipsisPattern bindingIndex: #f}.
				SBVPBindingPattern bindingIndex: #c children: {SBVPEllipsisPattern bindingIndex: #g}}.
			SBVPEllipsisPattern bindingIndex: #h}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger = ((bindings at: #b) label asInteger + (bindings at: #c) label asInteger)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithLabeledEllipses [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern
			bindingIndex: #a
			children: {SBVPEllipsisPattern bindingIndex: #b. SBVPBindingPattern bindingIndex: #c}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithLabeledEllipsesOutput [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern
			bindingIndex: #a
			children: {SBVPBindingPattern bindingIndex: #c. SBVPEllipsisPattern bindingIndex: #b}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodes [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: #a children: {SBVPBindingPattern bindingIndex: #b}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger = ((bindings at: #b) label asInteger + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcard [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: #a children: {
			SBVPWildcardPattern
				bindingIndex: #c
				children: {SBVPBindingPattern bindingIndex: #b children: {SBVPWildcardPattern bindingIndex: #d}}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger = ((bindings at: #b) label asInteger + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcardOutput [

	^ SBVPBindingPattern bindingIndex: #a children: {
		SBVPWildcardPattern
			bindingIndex: #d
			children: {SBVPWildcardPattern bindingIndex: #c children: {SBVPBindingPattern bindingIndex: #b}}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithWildcard [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingIndex: #a children: {
			SBVPWildcardPattern
				bindingIndex: #c
				children: {SBVPBindingPattern bindingIndex: #b children: {SBVPWildcardPattern bindingIndex: #d}}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger = ((bindings at: #b) label asInteger + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoWildcardList [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingIndex: #c children: {
			SBVPBindingPattern bindingIndex: #a children: {
				SBVPWildcardPattern
					bindingIndex: #d
					children: {SBVPBindingPattern bindingIndex: #b children: {SBVPWildcardPattern bindingIndex: #e}}}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger = ((bindings at: #b) label asInteger + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> exampleWithConstants: salzstangen [

	| case |
	case := SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern expressionDict: {#identity -> [salzstangen]} children: {
				SBVPBindingPattern
					bindingDict: {#identity -> #a}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #b}}}})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #a} children: {
				SBVPBindingPattern
					expressionDict: {#identity -> [salzstangen]}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #b}}}})
		strategy: {#explicitRootMatching -> false} asDictionary.
	^ case replaceAllMatches: salzstangen
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> getLabelList: aPrimitive [

	| currentPrimitive list |
	list := OrderedCollection new.
	currentPrimitive := aPrimitive.
	[currentPrimitive children notEmpty] whileTrue: [
		list add: currentPrimitive label asInteger.
		currentPrimitive := currentPrimitive children first].
	list add: currentPrimitive label asInteger.
	^ list
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> getLabelTree: aPrimitive [

	^ aPrimitive children
		ifEmpty: [aPrimitive label asInteger]
		ifNotEmpty: [aPrimitive label asInteger -> (aPrimitive children collect: [:child | self getLabelTree: child]) asArray]
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testComplexTree [

	| matcher root vp10 vp3 vp7 vp1 |
	root := SBVPDummyNode buildTree: {42 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}.
	vp10 := root left.
	vp3 := vp10 left.
	vp7 := vp10 right.
	vp1 := vp3 left.
	matcher := SBVPPatternMatcher
		input: root asVisualPrimitive
		pattern: self examplePatternTreeWithEllipses.
	self
		assert: {{vp10. vp3. vp7}. {vp3. vp1. vp3 right}. {vp1. vp1 left. vp1 right}. {vp7. vp7 left. vp7 right}} asSet
		equals: (matcher getAllMatches collect: [:match | {match at: #a. match at: #b. match at: #c} collect: [:node | node sourceObject]]) asSet
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testConstantsWork [

	| tree resultingTree |
	tree := SBVPDummyNode buildTree: {9 -> {10 -> {8}}}.
	resultingTree := self exampleWithConstants: tree.
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
		equals: (matcher getAllMatches collect: [:match | {match at: #a. match at: #b}]) asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testMatchAllChildrenTree [

	| matcher root vp3 vp2 vp5 |
	root := SBVPDummyNode buildTree: {10 -> {5 -> {2 -> {1. 1}. 3 -> {2. 1}}}}.
	vp5 := root left.
	vp2 := vp5 left.
	vp3 := vp5 right.
	matcher := SBVPPatternMatcher
		input: root asVisualPrimitive
		pattern: self examplePatternTreeWithEllipses.
	self
		assert: {{vp5. vp2. vp3}. {vp2. vp2 left. vp2 right}. {vp3. vp3 left. vp3 right}} asSet
		equals: (matcher getAllMatches collect: [:match | {match at: #a. match at: #b. match at: #c} collect: [:node | node sourceObject]]) asSet
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTree [

	| matcher root |
	root := SBVPDummyNode buildTree: {10 -> {7. 3}}.
	matcher := SBVPPatternMatcher
		input: root asVisualPrimitive
		pattern: self examplePatternSimpleTree.
	self
		assert: {{#a -> root. #b -> root left. #c -> root right} asDictionary}
		equals: (matcher getAllMatches collect: [:match | match collect: [:node | node sourceObject]]) asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTreeEllipsisOutput [

	| matcher root output |
	root := SBVPDummyNode buildTree: {10 -> {2 -> {-1}. 4}}.
	matcher := SBVPPatternMatcher
		input: root asVisualPrimitive
		pattern: self examplePatternTreeWithLabeledEllipses.
	
	output := self examplePatternTreeWithLabeledEllipsesOutput buildFromBinding: matcher getNextMatch.
	
	self assert: 10 -> {4. 2 -> {-1}} equals: (self getLabelTree: output first)
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSimpleTreeOutput [

	| matcher root output |
	root := SBVPDummyNode buildTree: {10 -> {7. 3}}.
	matcher := SBVPPatternMatcher
		input: root asVisualPrimitive
		pattern: self examplePatternSimpleTree.
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
	self assert: {{#a -> primitives first} asDictionary} equals: matcher getAllMatches asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSortTreeOutput [

	| root output |
	root := SBVPDummyNode buildTree: {0 -> {1 -> {3 -> {5. 4}. 2 -> {6. 7}}}}.
	output := (SBVPCase
		input: SBVPPatternMatcherTest new examplePatternSortTree
		output: SBVPPatternMatcherTest new examplePatternSortTreeOutput) replaceAllMatches: root.
	self
		assert: {0 -> {1 -> {2 -> {6. 7}. 3 -> {4. 5}}}}
		equals: {self getLabelTree: output asVisualPrimitive}
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
		equals: (matcher getAllMatches collect: [:match | {match at: #a. match at: #b}]) asArray
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
	self
		assert: {{#a -> primitives first. #b -> primitives second} asDictionary}
		equals: matcher getAllMatches asArray
]
