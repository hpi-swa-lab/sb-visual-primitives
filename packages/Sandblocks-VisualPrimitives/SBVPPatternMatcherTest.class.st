Class {
	#name : #SBVPPatternMatcherTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> buildList: aCollection [

	| asTree reversed |
	reversed := Array streamContents: [:stream | aCollection reverseDo: [:ea | stream nextPut: ea]].
	
	asTree := reversed inject: {} into: [:tree :next | {next -> tree}].
	^ self buildTree: asTree
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> buildTree: aCollection [

	^ SBVPDummyNode buildTree: aCollection
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternChildSmallerThanParent [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingDict: {#identity -> #a} children: {
			SBVPEllipsisPattern bindingDict: {#identity -> #b}.
			SBVPBindingPattern
				bindingDict: {#identity -> #c}
				children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}}.
		SBVPEllipsisPattern bindingDict: {#identity -> #d}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #c) key < (bindings at: #a) key]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternChildSmallerThanParentOutput [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingDict: {#identity -> #c} children: {
			SBVPEllipsisPattern bindingDict: {#identity -> #b}.
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
			SBVPEllipsisPattern bindingDict: {#identity -> #d}}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSimpleTree [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern
			bindingDict: {#identity -> #a}
			children: {SBVPBindingPattern bindingDict: {#identity -> #b}. SBVPBindingPattern bindingDict: {#identity -> #c}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + (bindings at: #c) key)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSimpleTreeOutput [

	^ SBVPBindingPattern
		bindingDict: {#identity -> #a}
		children: {SBVPBindingPattern bindingDict: {#identity -> #c}. SBVPBindingPattern bindingDict: {#identity -> #b}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSingleNode [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingDict: {#identity -> #a}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = 10]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSortTree [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingDict: {#identity -> #f} children: {
			SBVPEllipsisPattern bindingDict: {#identity -> #g}.
			SBVPBindingPattern bindingDict: {#identity -> #a} children: {
				SBVPBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #d}}.
				SBVPBindingPattern
					bindingDict: {#identity -> #c}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}}.
			SBVPEllipsisPattern bindingDict: {#identity -> #h}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #b) key > (bindings at: #c) key]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternSortTreeOutput [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingDict: {#identity -> #f} children: {
			SBVPEllipsisPattern bindingDict: {#identity -> #g}.
			SBVPBindingPattern bindingDict: {#identity -> #a} children: {
				SBVPBindingPattern
					bindingDict: {#identity -> #c}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #d}}}.
			SBVPEllipsisPattern bindingDict: {#identity -> #h}}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithEllipses [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingDict: {#identity -> #d} children: {
			SBVPEllipsisPattern bindingDict: {#identity -> #e}.
			SBVPBindingPattern bindingDict: {#identity -> #a} children: {
				SBVPBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #f}}.
				SBVPBindingPattern
					bindingDict: {#identity -> #c}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #g}}}.
			SBVPEllipsisPattern bindingDict: {#identity -> #h}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + (bindings at: #c) key)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithLabeledEllipses [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern
			bindingDict: {#identity -> #a}
			children: {SBVPEllipsisPattern bindingDict: {#identity -> #b}. SBVPBindingPattern bindingDict: {#identity -> #c}}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTreeWithLabeledEllipsesOutput [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern
			bindingDict: {#identity -> #a}
			children: {SBVPBindingPattern bindingDict: {#identity -> #c}. SBVPEllipsisPattern bindingDict: {#identity -> #b}}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodes [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern
			bindingDict: {#identity -> #a}
			children: {SBVPBindingPattern bindingDict: {#identity -> #b}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcard [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingDict: {#identity -> #a} children: {
			SBVPWildcardPattern bindingDict: {#identity -> #c} children: {
				SBVPBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBVPWildcardPattern bindingDict: {#identity -> #d}}}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcardOutput [

	^ SBVPBindingPattern bindingDict: {#identity -> #a} children: {
		SBVPWildcardPattern bindingDict: {#identity -> #d} children: {
			SBVPWildcardPattern
				bindingDict: {#identity -> #c}
				children: {SBVPBindingPattern bindingDict: {#identity -> #b}}}}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoNodesWithWildcard [

	^ SBVPGroupPattern patterns: {
		SBVPBindingPattern bindingDict: {#identity -> #a} children: {
			SBVPWildcardPattern bindingDict: {#identity -> #c} children: {
				SBVPBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBVPWildcardPattern bindingDict: {#identity -> #d}}}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> examplePatternTwoWildcardList [

	^ SBVPGroupPattern patterns: {
		SBVPWildcardPattern bindingDict: {#identity -> #c} children: {
			SBVPBindingPattern bindingDict: {#identity -> #a} children: {
				SBVPWildcardPattern bindingDict: {#identity -> #d} children: {
					SBVPBindingPattern
						bindingDict: {#identity -> #b}
						children: {SBVPWildcardPattern bindingDict: {#identity -> #e}}}}}.
		SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> exampleWithConstants: salzstangen [

	| case |
	case := SBVPTransformation
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
		list add: (currentPrimitive propertyAt: #innerLabel).
		currentPrimitive := currentPrimitive children first].
	list add: (currentPrimitive propertyAt: #innerLabel).
	^ list
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> getLabelTree: aPrimitive [

	^ aPrimitive children
		ifEmpty: [aPrimitive propertyAt: #innerLabel]
		ifNotEmpty: [(aPrimitive propertyAt: #innerLabel) -> (aPrimitive children collect: [:child | self getLabelTree: child]) asArray]
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

	| matcher primitives config |
	config := {5. 10. 5. 0. 5. 10. 5. 0. 5}.
	primitives := (self buildList: config) asVisualPrimitive.
	matcher := SBVPPatternMatcher
		input: primitives
		pattern: self examplePatternTwoWildcardList.
	self
		assert: {{config second. config fourth}. {config second. config eighth}. {config sixth. config eighth}}
		equals: (matcher getAllMatches collect: [:match | {(match at: #a) sourceObject key. (match at: #b) sourceObject key}]) asArray
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
	primitives := (self buildList: {10}) asVisualPrimitive.
	matcher := SBVPPatternMatcher
		input: primitives
		pattern: self examplePatternSingleNode.
	self
		assert: {#a -> 10}
		equals: (matcher getAllMatches collect: [:match | {#a -> (match at: #a) sourceObject key}]) first
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testSortTreeOutput [

	| root output |
	root := SBVPDummyNode buildTree: {0 -> {1 -> {3 -> {5. 4}. 2 -> {6. 7}}}}.
	output := (SBVPTransformation
		input: SBVPPatternMatcherTest new examplePatternSortTree
		output: SBVPPatternMatcherTest new examplePatternSortTreeOutput) replaceAllMatches: root.
	self
		assert: {0 -> {1 -> {2 -> {6. 7}. 3 -> {4. 5}}}}
		equals: {self getLabelTree: output asVisualPrimitive}
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testThreeNodesWithWildcard [

	| matcher primitives |
	primitives := (self buildList: {10. 42. 0. 0. 42}) asVisualPrimitive.
	matcher := SBVPPatternMatcher
		input: primitives
		pattern: self examplePatternTwoNodesWithWildcard.
	self
		assert: {{10. 0}. {10. 0}}
		equals: (matcher getAllMatches collect: [:match | {(match at: #a) sourceObject key. (match at: #b) sourceObject key}]) asArray
]

{ #category : #'as yet unclassified' }
SBVPPatternMatcherTest >> testThreeNodesWithWildcardOutput [

	| matcher primitives output match |
	primitives := (self buildList: {10. 101. 102. 0. 103}) asVisualPrimitive.
	matcher := SBVPPatternMatcher
		input: primitives
		pattern: self examplePatternTwoNodesWithLabeledWildcard.
	
	match := matcher getNextMatch.
	self assert: match notNil.
	
	output := (self examplePatternTwoNodesWithLabeledWildcardOutput buildFromBinding: match) first.
	
	self assert: {10. 103. 101. 102. 0} equals: (self getLabelList: output) asArray
]
