Class {
	#name : #SBPatternMatcherTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> buildList: aCollection [

	| asTree reversed |
	reversed := Array streamContents: [:stream | aCollection reverseDo: [:ea | stream nextPut: ea]].
	
	asTree := reversed inject: {} into: [:tree :next | {next -> tree}].
	^ self buildTree: asTree
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> buildTree: aCollection [

	^ SBDummyNode buildTree: aCollection
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternChildSmallerThanParent [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #a} children: {
			SBEllipsisPattern bindingDict: {#identity -> #b}.
			SBBindingPattern
				bindingDict: {#identity -> #c}
				children: {SBEllipsisPattern bindingDict: {#identity -> #e}}}.
		SBEllipsisPattern bindingDict: {#identity -> #d}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #c) key < (bindings at: #a) key]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternChildSmallerThanParentOutput [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #c} children: {
			SBEllipsisPattern bindingDict: {#identity -> #b}.
			SBBindingPattern
				bindingDict: {#identity -> #a}
				children: {SBEllipsisPattern bindingDict: {#identity -> #e}}.
			SBEllipsisPattern bindingDict: {#identity -> #d}}}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternSimpleTree [

	^ SBGroupPattern patterns: {
		SBBindingPattern
			bindingDict: {#identity -> #a}
			children: {SBBindingPattern bindingDict: {#identity -> #b}. SBBindingPattern bindingDict: {#identity -> #c}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + (bindings at: #c) key)]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternSimpleTreeOutput [

	^ SBBindingPattern
		bindingDict: {#identity -> #a}
		children: {SBBindingPattern bindingDict: {#identity -> #c}. SBBindingPattern bindingDict: {#identity -> #b}}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternSingleNode [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #a}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = 10]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternSortTree [

	^ SBGroupPattern patterns: {
		SBWildcardPattern bindingDict: {#identity -> #f} children: {
			SBEllipsisPattern bindingDict: {#identity -> #g}.
			SBBindingPattern bindingDict: {#identity -> #a} children: {
				SBBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBEllipsisPattern bindingDict: {#identity -> #d}}.
				SBBindingPattern
					bindingDict: {#identity -> #c}
					children: {SBEllipsisPattern bindingDict: {#identity -> #e}}}.
			SBEllipsisPattern bindingDict: {#identity -> #h}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #b) key > (bindings at: #c) key]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternSortTreeOutput [

	^ SBGroupPattern patterns: {
		SBWildcardPattern bindingDict: {#identity -> #f} children: {
			SBEllipsisPattern bindingDict: {#identity -> #g}.
			SBBindingPattern bindingDict: {#identity -> #a} children: {
				SBBindingPattern
					bindingDict: {#identity -> #c}
					children: {SBEllipsisPattern bindingDict: {#identity -> #e}}.
				SBBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBEllipsisPattern bindingDict: {#identity -> #d}}}.
			SBEllipsisPattern bindingDict: {#identity -> #h}}}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternTreeWithEllipses [

	^ SBGroupPattern patterns: {
		SBWildcardPattern bindingDict: {#identity -> #d} children: {
			SBEllipsisPattern bindingDict: {#identity -> #e}.
			SBBindingPattern bindingDict: {#identity -> #a} children: {
				SBBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBEllipsisPattern bindingDict: {#identity -> #f}}.
				SBBindingPattern
					bindingDict: {#identity -> #c}
					children: {SBEllipsisPattern bindingDict: {#identity -> #g}}}.
			SBEllipsisPattern bindingDict: {#identity -> #h}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + (bindings at: #c) key)]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternTreeWithLabeledEllipses [

	^ SBGroupPattern patterns: {
		SBBindingPattern
			bindingDict: {#identity -> #a}
			children: {SBEllipsisPattern bindingDict: {#identity -> #b}. SBBindingPattern bindingDict: {#identity -> #c}}}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternTreeWithLabeledEllipsesOutput [

	^ SBGroupPattern patterns: {
		SBBindingPattern
			bindingDict: {#identity -> #a}
			children: {SBBindingPattern bindingDict: {#identity -> #c}. SBEllipsisPattern bindingDict: {#identity -> #b}}}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternTwoNodes [

	^ SBGroupPattern patterns: {
		SBBindingPattern
			bindingDict: {#identity -> #a}
			children: {SBBindingPattern bindingDict: {#identity -> #b}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcard [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #a} children: {
			SBWildcardPattern bindingDict: {#identity -> #c} children: {
				SBBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBWildcardPattern bindingDict: {#identity -> #d}}}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternTwoNodesWithLabeledWildcardOutput [

	^ SBBindingPattern bindingDict: {#identity -> #a} children: {
		SBWildcardPattern bindingDict: {#identity -> #d} children: {
			SBWildcardPattern
				bindingDict: {#identity -> #c}
				children: {SBBindingPattern bindingDict: {#identity -> #b}}}}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternTwoNodesWithWildcard [

	^ SBGroupPattern patterns: {
		SBBindingPattern bindingDict: {#identity -> #a} children: {
			SBWildcardPattern bindingDict: {#identity -> #c} children: {
				SBBindingPattern
					bindingDict: {#identity -> #b}
					children: {SBWildcardPattern bindingDict: {#identity -> #d}}}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> examplePatternTwoWildcardList [

	^ SBGroupPattern patterns: {
		SBWildcardPattern bindingDict: {#identity -> #c} children: {
			SBBindingPattern bindingDict: {#identity -> #a} children: {
				SBWildcardPattern bindingDict: {#identity -> #d} children: {
					SBBindingPattern
						bindingDict: {#identity -> #b}
						children: {SBWildcardPattern bindingDict: {#identity -> #e}}}}}.
		SBConstraintPattern constraint: [:bindings | (bindings at: #a) key = ((bindings at: #b) key + 10)]}
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> exampleWithConstants: anObject [

	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern expressionDict: {#identity -> [anObject]} children: {
				SBBindingPattern
					bindingDict: {#identity -> #a}
					children: {SBEllipsisPattern bindingDict: {#identity -> #b}}}})
		output: (SBGroupPattern patterns: {
			SBBindingPattern bindingDict: {#identity -> #a} children: {
				SBBindingPattern
					expressionDict: {#identity -> [anObject]}
					children: {SBEllipsisPattern bindingDict: {#identity -> #b}}}})
		strategy: {#explicitRootMatching -> false} asDictionary) replaceAllMatches
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> getLabelList: aPrimitive [

	| currentPrimitive list |
	list := OrderedCollection new.
	currentPrimitive := aPrimitive.
	[currentPrimitive children notEmpty] whileTrue: [
		list add: (currentPrimitive propertyAt: #innerLabel) asInteger.
		currentPrimitive := currentPrimitive children first].
	list add: (currentPrimitive propertyAt: #innerLabel) asInteger.
	^ list
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> getLabelTree: aPrimitive [

	^ aPrimitive children
		ifEmpty: [(aPrimitive propertyAt: #innerLabel) asInteger]
		ifNotEmpty: [(aPrimitive propertyAt: #innerLabel) asInteger -> (aPrimitive children collect: [:child | self getLabelTree: child]) asArray]
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> testComplexTree [

	| matcher root vp10 vp3 vp7 vp1 |
	root := SBDummyNode buildTree: {42 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}.
	vp10 := root left.
	vp3 := vp10 left.
	vp7 := vp10 right.
	vp1 := vp3 left.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternTreeWithEllipses.
	self
		assert: {{vp10. vp3. vp7}. {vp3. vp1. vp3 right}. {vp1. vp1 left. vp1 right}. {vp7. vp7 left. vp7 right}} asSet
		equals: (matcher getAllMatches collect: [:match | {match at: #a. match at: #b. match at: #c} collect: [:node | node sourceObject]]) asSet
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> testConstantsWork [

	| tree resultingTree |
	tree := SBDummyNode buildTree: {9 -> {10 -> {8}}}.
	resultingTree := self exampleWithConstants: tree.
	self assert: {10. 8. 9} equals: (self getLabelList: resultingTree asDomainBlock) asArray
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> testMatchAllChildrenTree [

	| matcher root vp3 vp2 vp5 |
	root := SBDummyNode buildTree: {10 -> {5 -> {2 -> {1. 1}. 3 -> {2. 1}}}}.
	vp5 := root left.
	vp2 := vp5 left.
	vp3 := vp5 right.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternTreeWithEllipses.
	self
		assert: {{vp5. vp2. vp3}. {vp2. vp2 left. vp2 right}. {vp3. vp3 left. vp3 right}} asSet
		equals: (matcher getAllMatches collect: [:match | {match at: #a. match at: #b. match at: #c} collect: [:node | node sourceObject]]) asSet
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> testSimpleTreeEllipsisOutput [

	| matcher root output |
	root := SBDummyNode buildTree: {10 -> {2 -> {-1}. 4}}.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternTreeWithLabeledEllipses.
	
	output := self examplePatternTreeWithLabeledEllipsesOutput buildFromBinding: matcher getNextMatch.
	
	self assert: 10 -> {4. 2 -> {-1}} equals: (self getLabelTree: output first)
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> testSimpleTreeOutput [

	| matcher root output |
	root := SBDummyNode buildTree: {10 -> {7. 3}}.
	matcher := SBPatternMatcher
		input: root asDomainBlock
		pattern: self examplePatternSimpleTree.
	output := (self examplePatternSimpleTreeOutput buildFromBinding: matcher getNextMatch) first.
	self assert: 10 -> {3. 7} equals: (self getLabelTree: output)
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> testSingleNodeMatch [

	| matcher primitives |
	primitives := (self buildList: {10}) asDomainBlock.
	matcher := SBPatternMatcher input: primitives pattern: self examplePatternSingleNode.
	self
		assert: {#a -> 10}
		equals: (matcher getAllMatches collect: [:match | {#a -> (match at: #a) sourceObject key}]) first
]

{ #category : #'as yet unclassified' }
SBPatternMatcherTest >> testSortTreeOutput [

	| root output |
	root := SBDummyNode buildTree: {0 -> {1 -> {3 -> {5. 4}. 2 -> {6. 7}}}}.
	output := (SBTransformation
		input: self examplePatternSortTree
		output: self examplePatternSortTreeOutput) replaceAllMatches: root.
	self
		assert: {0 -> {1 -> {2 -> {6. 7}. 3 -> {4. 5}}}}
		equals: {self getLabelTree: output asDomainBlock}
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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
