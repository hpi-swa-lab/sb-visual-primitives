"
An SBPatternMatcherTest tests some pattern matching scenarios using SBDummyNodes.

"
Class {
	#name : #SBPatternMatcherTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #helpers }
SBPatternMatcherTest >> buildList: aCollection [

	| asTree reversed |
	reversed := Array streamContents: [:stream | aCollection reverseDo: [:ea | stream nextPut: ea]].
	
	asTree := reversed inject: {} into: [:tree :next | {next -> tree}].
	^ self buildTree: asTree
]

{ #category : #helpers }
SBPatternMatcherTest >> buildTree: aCollection [

	^ SBDummyNode buildTree: aCollection
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternChildSmallerThanParent [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
			SBEllipsisPattern bindingDict: {#identity -> #b}.
			SBBindingPattern
				bindingDict: {#identity -> #c}
				patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e}}}.
		SBEllipsisPattern bindingDict: {#identity -> #d}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #c) key < (bindings at: #a) key]}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternChildSmallerThanParentOutput [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #c} patternChildren: {
			SBEllipsisPattern bindingDict: {#identity -> #b}.
			SBBindingPattern
				bindingDict: {#identity -> #a}
				patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e}}.
			SBEllipsisPattern bindingDict: {#identity -> #d}}}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternSimpleTree [

	^ SBGroupPattern patterns: {
		SBBindingPattern
			bindingDict: {#identity -> #a}
			patternChildren: {SBBindingPattern bindingDict: {#identity -> #b}. SBBindingPattern bindingDict: {#identity -> #c}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + (bindings at: #c) key)]}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternSimpleTreeOutput [

	^ SBBindingPattern
		bindingDict: {#identity -> #a}
		patternChildren: {SBBindingPattern bindingDict: {#identity -> #c}. SBBindingPattern bindingDict: {#identity -> #b}}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternSingleNode [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #a}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = 10]}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternSortTree [

	^ SBGroupPattern patterns: {
		SBWildcardPattern bindingDict: {#identity -> #f} patternChildren: {
			SBEllipsisPattern bindingDict: {#identity -> #g}.
			SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
				SBBindingPattern
					bindingDict: {#identity -> #b}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #d}}.
				SBBindingPattern
					bindingDict: {#identity -> #c}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e}}}.
			SBEllipsisPattern bindingDict: {#identity -> #h}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #b) key > (bindings at: #c) key]}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternSortTreeOutput [

	^ SBGroupPattern patterns: {
		SBWildcardPattern bindingDict: {#identity -> #f} patternChildren: {
			SBEllipsisPattern bindingDict: {#identity -> #g}.
			SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
				SBBindingPattern
					bindingDict: {#identity -> #c}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e}}.
				SBBindingPattern
					bindingDict: {#identity -> #b}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #d}}}.
			SBEllipsisPattern bindingDict: {#identity -> #h}}}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternTreeWithEllipses [

	^ SBGroupPattern patterns: {
		SBWildcardPattern bindingDict: {#identity -> #d} patternChildren: {
			SBEllipsisPattern bindingDict: {#identity -> #e}.
			SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
				SBBindingPattern
					bindingDict: {#identity -> #b}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #f}}.
				SBBindingPattern
					bindingDict: {#identity -> #c}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #g}}}.
			SBEllipsisPattern bindingDict: {#identity -> #h}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + (bindings at: #c) key)]}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternTreeWithLabeledEllipses [

	^ SBGroupPattern patterns: {
		SBBindingPattern
			bindingDict: {#identity -> #a}
			patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b}. SBBindingPattern bindingDict: {#identity -> #c}}}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternTreeWithLabeledEllipsesOutput [

	^ SBGroupPattern patterns: {
		SBBindingPattern
			bindingDict: {#identity -> #a}
			patternChildren: {SBBindingPattern bindingDict: {#identity -> #c}. SBEllipsisPattern bindingDict: {#identity -> #b}}}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternTwoNodes [

	^ SBGroupPattern patterns: {
		SBBindingPattern
			bindingDict: {#identity -> #a}
			patternChildren: {SBBindingPattern bindingDict: {#identity -> #b}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcard [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
			SBWildcardPattern bindingDict: {#identity -> #c} patternChildren: {
				SBBindingPattern
					bindingDict: {#identity -> #b}
					patternChildren: {SBWildcardPattern bindingDict: {#identity -> #d}}}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcardOutput [

	^ SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
		SBWildcardPattern bindingDict: {#identity -> #d} patternChildren: {
			SBWildcardPattern
				bindingDict: {#identity -> #c}
				patternChildren: {SBBindingPattern bindingDict: {#identity -> #b}}}}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternTwoNodesWithWildcard [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
			SBWildcardPattern bindingDict: {#identity -> #c} patternChildren: {
				SBBindingPattern
					bindingDict: {#identity -> #b}
					patternChildren: {SBWildcardPattern bindingDict: {#identity -> #d}}}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #examples }
SBPatternMatcherTest >> examplePatternTwoWildcardList [

	^ SBGroupPattern patterns: {
		SBWildcardPattern bindingDict: {#identity -> #c} patternChildren: {
			SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
				SBWildcardPattern bindingDict: {#identity -> #d} patternChildren: {
					SBBindingPattern
						bindingDict: {#identity -> #b}
						patternChildren: {SBWildcardPattern bindingDict: {#identity -> #e}}}}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #examples }
SBPatternMatcherTest >> exampleWithConstants: anObject [

	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern expressionDict: {#identity -> [anObject]} patternChildren: {
				SBBindingPattern
					bindingDict: {#identity -> #a}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b}}}})
		output: (SBGroupPattern patterns: {
			SBBindingPattern bindingDict: {#identity -> #a} patternChildren: {
				SBBindingPattern
					expressionDict: {#identity -> [anObject]}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b}}}})
		strategy: {#explicitRootMatching -> false} asDictionary
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value
]

{ #category : #helpers }
SBPatternMatcherTest >> getLabelList: aPrimitive [

	| currentPrimitive list |
	list := OrderedCollection new.
	currentPrimitive := aPrimitive.
	[currentPrimitive patternChildren notEmpty] whileTrue: [
		list add: (currentPrimitive propertyAt: #innerLabel) asInteger.
		currentPrimitive := currentPrimitive patternChildren first].
	list add: (currentPrimitive propertyAt: #innerLabel) asInteger.
	^ list
]

{ #category : #helpers }
SBPatternMatcherTest >> getLabelTree: aPrimitive [

	^ aPrimitive patternChildren
		ifEmpty: [(aPrimitive propertyAt: #innerLabel) asInteger]
		ifNotEmpty: [(aPrimitive propertyAt: #innerLabel) asInteger -> (aPrimitive patternChildren collect: [:child | self getLabelTree: child]) asArray]
]

{ #category : #tests }
SBPatternMatcherTest >> testComplexTree [

	| matcher root db10 db3 db7 db1 |
	root := SBDummyNode buildTree: {42 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}.
	db10 := root left.
	db3 := db10 left.
	db7 := db10 right.
	db1 := db3 left.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternTreeWithEllipses.
	self
		assert: {{db10. db3. db7}. {db3. db1. db3 right}. {db1. db1 left. db1 right}. {db7. db7 left. db7 right}} asSet
		equals: (matcher getAllMatches collect: [:match | {match at: #a. match at: #b. match at: #c} collect: [:node | node sourceObject]]) asSet
]

{ #category : #tests }
SBPatternMatcherTest >> testConstantsWork [

	| tree resultingTree |
	tree := SBDummyNode buildTree: {9 -> {10 -> {8}}}.
	resultingTree := self exampleWithConstants: tree.
	self assert: {10. 8. 9} equals: (self getLabelList: resultingTree asDomainBlock) asArray
]

{ #category : #tests }
SBPatternMatcherTest >> testFiveNodesWithWildcard [

	| matcher primitives config |
	config := {5. 10. 5. 0. 5. 10. 5. 0. 5}.
	primitives := (self buildList: config) asDomainBlock.
	matcher := SBPatternMatcher
		input: primitives
		pattern: self examplePatternTwoWildcardList.
	self
		assert: {{config second. config fourth}. {config second. config eighth}. {config sixth. config eighth}}
		equals: (matcher getAllMatches collect: [:match | {(match at: #a) sourceObject key. (match at: #b) sourceObject key}]) asArray
]

{ #category : #tests }
SBPatternMatcherTest >> testMatchAllChildrenTree [

	| matcher root db3 db2 db5 |
	root := SBDummyNode buildTree: {10 -> {5 -> {2 -> {1. 1}. 3 -> {2. 1}}}}.
	db5 := root left.
	db2 := db5 left.
	db3 := db5 right.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternTreeWithEllipses.
	self
		assert: {{db5. db2. db3}. {db2. db2 left. db2 right}. {db3. db3 left. db3 right}} asSet
		equals: (matcher getAllMatches collect: [:match | {match at: #a. match at: #b. match at: #c} collect: [:node | node sourceObject]]) asSet
]

{ #category : #tests }
SBPatternMatcherTest >> testSimpleTree [

	| matcher root |
	root := SBDummyNode buildTree: {10 -> {7. 3}}.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternSimpleTree.
	self
		assert: {{#a -> root. #b -> root left. #c -> root right} asDictionary}
		equals: (matcher getAllMatches collect: [:match | match collect: [:node | node sourceObject]]) asArray
]

{ #category : #tests }
SBPatternMatcherTest >> testSimpleTreeEllipsisOutput [

	| matcher root output |
	root := SBDummyNode buildTree: {10 -> {2 -> {-1}. 4}}.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternTreeWithLabeledEllipses.
	
	output := self examplePatternTreeWithLabeledEllipsesOutput buildFromBinding: matcher getNextMatch.
	
	self assert: 10 -> {4. 2 -> {-1}} equals: (self getLabelTree: output first)
]

{ #category : #tests }
SBPatternMatcherTest >> testSimpleTreeOutput [

	| matcher root output |
	root := SBDummyNode buildTree: {10 -> {7. 3}}.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternSimpleTree.
	output := (self examplePatternSimpleTreeOutput buildFromBinding: matcher getNextMatch) first.
	self assert: 10 -> {3. 7} equals: (self getLabelTree: output)
]

{ #category : #tests }
SBPatternMatcherTest >> testSingleNodeMatch [

	| matcher primitives |
	primitives := (self buildList: {10}) asDomainBlock.
	matcher := SBPatternMatcher input: primitives pattern: self examplePatternSingleNode.
	self
		assert: {#a -> 10}
		equals: (matcher getAllMatches collect: [:match | {#a -> (match at: #a) sourceObject key}]) first
]

{ #category : #tests }
SBPatternMatcherTest >> testSortTreeOutput [

	| root output |
	root := SBDummyNode buildTree: {0 -> {1 -> {3 -> {5. 4}. 2 -> {6. 7}}}}.
	output := (SBTransformation
		input: self examplePatternSortTree
		output: self examplePatternSortTreeOutput
		strategy: Dictionary new
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: root.
	self
		assert: {0 -> {1 -> {2 -> {6. 7}. 3 -> {4. 5}}}}
		equals: {self getLabelTree: output asDomainBlock}
]

{ #category : #tests }
SBPatternMatcherTest >> testThreeNodesWithWildcard [

	| matcher primitives |
	primitives := (self buildList: {10. 42. 0. 0. 42}) asDomainBlock.
	matcher := SBPatternMatcher
		input: primitives
		pattern: self examplePatternTwoNodesWithWildcard.
	self
		assert: {{10. 0}. {10. 0}}
		equals: (matcher getAllMatches collect: [:match | {(match at: #a) sourceObject key. (match at: #b) sourceObject key}]) asArray
]

{ #category : #tests }
SBPatternMatcherTest >> testThreeNodesWithWildcardOutput [

	| matcher primitives output match |
	primitives := (self buildList: {10. 101. 102. 0. 103}) asDomainBlock.
	matcher := SBPatternMatcher
		input: primitives
		pattern: self examplePatternTwoNodesWithLabeledWildcard.
	
	match := matcher getNextMatch.
	self assert: match notNil.
	
	output := (self examplePatternTwoNodesWithLabeledWildcardOutput buildFromBinding: match) first.
	
	self assert: {10. 103. 101. 102. 0} equals: (self getLabelList: output) asArray
]
