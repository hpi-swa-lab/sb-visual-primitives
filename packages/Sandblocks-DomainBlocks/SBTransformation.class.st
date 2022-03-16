"
An SBTransformation is the visual representation of a pattern matching rule with SBDomainBlocks. It consists of an input and an output pattern (SBGroupPatterns). For the pattern matching see SBPatternMatcher. You can choose a default class that determines the domainBlockMapping for the SBBindingPatterns.

By applying the case on an input object, the input pattern gets matched on this object and the matched part gets transformed to match the output pattern.

Instance Variables
	outputPattern:		SBGroupPattern
	replaceCount:		Number

outputPattern
	- this is the result of the transformation visualized as a pattern

replaceCount
	- indicates the number of matching runs
	- default is Infinity (find all matches)

"
Class {
	#name : #SBTransformation,
	#superclass : #SBPatternContainer,
	#instVars : [
		'outputPattern',
		'replaceCount'
	],
	#classVars : [
		'ColorizeDifferences'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #accessing }
SBTransformation class >> colorizeDifferences [
	<preference: 'Colorize changes of transformations' category: 'Sandblocks-DomainBlocks-PatternMatching' description: 'This option enables automatic highlighting of same bindings during transformation. This might make it easier to see the changes a transformation does. This is only an alpha feature.' type: #Boolean>

	^ ColorizeDifferences ifNil: [false]
]

{ #category : #accessing }
SBTransformation class >> colorizeDifferences: aBoolean [

	ColorizeDifferences := aBoolean
]

{ #category : #'as yet unclassified' }
SBTransformation class >> input: aPattern output: anotherPattern strategy: aDict visualizePatternsAs: aClass replaceCount: aNumber [
	" marker "

	^ self new
		defaultVisualizationClass: aClass;
		input: aPattern output: anotherPattern;
		strategy: aDict;
		replaceCount: aNumber
]

{ #category : #'as yet unclassified' }
SBTransformation class >> matches: aBlock [

	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [self selector: #input:output:strategy:visualizePatternsAs:replaceCount: receiverMatches: aBlock]
]

{ #category : #'as yet unclassified' }
SBTransformation class >> newFor: aBlock [

	| input output |
	input := aBlock arguments first.
	input isPatternBlock ifFalse: [input := input evaluate].
	output := aBlock arguments second.
	output isPatternBlock ifFalse: [output := output evaluate].
	
	^ self
		input: input
		output: output
		strategy: aBlock arguments third evaluate
		visualizePatternsAs: aBlock arguments fourth evaluate
		replaceCount: aBlock arguments fifth evaluate
]

{ #category : #'as yet unclassified' }
SBTransformation class >> suggestion [
	"Used for the projection"

	^ [:block | | case |
		case := self
			input: SBGroupPattern new
			output: SBGroupPattern new
			strategy: Dictionary new
			visualizePatternsAs: nil
			replaceCount: Float infinity.
		block sandblockEditor do: (SBReplaceCommand new
			target: block;
			replacer: case;
			yourself).
		case classNameInput promptClassForVPCase]
]

{ #category : #'as yet unclassified' }
SBTransformation >> buildImplicitChildrenMatchingPattern [

	(self pattern isNil or: [self outputPattern isNil]) ifTrue: [^ self].
	
	self pattern removeImplicitChildren.
	self outputPattern removeImplicitChildren.
	
	self explicitChildrenMatching ifFalse: [ | additionalNodes |
		additionalNodes := Dictionary new.
		self pattern buildImplicitChildren: additionalNodes.
		self outputPattern addImplicitChildren: additionalNodes]
]

{ #category : #'as yet unclassified' }
SBTransformation >> colorDifferences [
	<action>

	| inputBindingDict outputBindingDict colors |
	inputBindingDict := self findAllIdentityBindingsAsDict: self pattern.
	outputBindingDict := self findAllIdentityBindingsAsDict: self outputPattern.
	
	colors := (Color h: 50 s: 1.0 v: 1.0) wheel: inputBindingDict size.
	inputBindingDict withIndexDo: [:inputBinding :index | | bindingKey outputBinding |
		bindingKey := inputBindingDict keyAtValue: inputBinding.
		outputBinding := outputBindingDict at: bindingKey ifAbsent: [nil].
		outputBinding isNil
			ifTrue: [
				inputBinding attachDecorator: (SBColorAccentDecorator new
					color: Color red;
					message: 'This domain block will be deleted.')]
			ifFalse: [ | color |
				color := colors at: index.
				inputBinding attachDecorator: (SBColorAccentDecorator new color: color).
				outputBinding attachDecorator: (SBColorAccentDecorator new color: color)]]
]

{ #category : #examples }
SBTransformation >> exampleDeleteNodeInside: aTree [

	self
		example: [SBTransformation new]
		args: [
			{
				((SBDummyNode key: 1)
					left: ((SBDummyNode key: 2) left: (SBDummyNode key: 3));
					right: ((SBDummyNode key: 4) left: (SBDummyNode key: 42))) showAsDomainBlock}]
		label: 'example'.
	"Nodes that do not appear in the output pattern, are simply left out / deleted."
	self flag: #bug.
	"building the implicit patternChildren seems to not work."
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #parent}
				patternChildren: {
					SBBindingPattern
						bindingDict: {#identity -> #nodeWeWantToDelete}
						patternChildren: {}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #nodeWeWantToDelete) key = 42]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #parent}
				patternChildren: {}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aTree
]

{ #category : #examples }
SBTransformation >> exampleEllipsisPatternWithLabel: aDummyNode [

	self
		example: [SBTransformation new]
		args: [
			{
				((SBDummyNode key: 10)
					left: ((SBDummyNode key: 1)
						left: (SBDummyNode key: 4);
						right: (SBDummyNode key: 5));
					right: ((SBDummyNode key: 2)
						left: (SBDummyNode key: 4);
						right: (SBDummyNode key: 5))) showAsDomainBlock}]
		label: 'example'.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				patternChildren: {
					SBBindingPattern
						bindingDict: {#identity -> #b}
						patternChildren: {
							SBEllipsisPattern
								bindingDict: {#innerLabel -> #g. #identity -> #bChildren}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #c}
						patternChildren: {
							SBEllipsisPattern
								bindingDict: {#innerLabel -> #g. #identity -> #cChildren}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				patternChildren: {
					SBBindingPattern
						bindingDict: {#identity -> #b}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #bChildren} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBBindingPattern bindingDict: {#identity -> #c} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aDummyNode
]

{ #category : #examples }
SBTransformation >> exampleInsertWithExpression: aTree [

	| newNode |
	self
		example: [SBTransformation new]
		args: [{(SBStringDummyNode key: 'should get a new child') showAsDomainBlock}]
		label: 'example'.
	newNode := (SBStringDummyNode key: 'to be inserted node') showAsDomainBlock.
	"newNode is set as an Expression for the key in the child of a"
	^ (SBTransformation
		input: (SBGroupPattern patterns: {SBBindingPattern bindingDict: {#identity -> #a} visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				patternChildren: {SBBindingPattern expressionDict: {#identity -> [newNode]} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBStringDummyNode
		replaceCount: Float infinity) value: aTree
]

{ #category : #examples }
SBTransformation >> exampleMissingBindingsAreMarked: aTree [
	"Notice how bindings are marked if they are not found in the input."

	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #g}
				patternChildren: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #boi}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #boi) key < (bindings at: #boi) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #boi}
				patternChildren: {
					SBBindingPattern bindingDict: {#identity -> #notFound} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #a}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aTree
]

{ #category : #examples }
SBTransformation >> exampleTransformInputAsOftenAsPossible: aTree [

	self
		example: [SBTransformation new]
		args: [
			{
				((SBDummyNode key: 1)
					left: ((SBDummyNode key: 2)
						left: (SBDummyNode key: 3);
						right: (SBDummyNode key: 4));
					right: ((SBDummyNode key: 5)
						left: (SBDummyNode key: 6);
						right: (SBDummyNode key: 7))) showAsDomainBlock}]
		label: 'example'.
	"In this example we will create a MaxHeap by matching any parent and child and checking wether they violate the heap condition. If they do, we swap them."
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #parent}
				patternChildren: {
					SBEllipsisPattern
						bindingDict: {#identity -> #leftSiblings}
						visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #child}
						patternChildren: {
							SBEllipsisPattern
								bindingDict: {#identity -> #grandchildren}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern
						bindingDict: {#identity -> #rightSiblings}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #parent) key < (bindings at: #child) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #child}
				patternChildren: {
					SBEllipsisPattern
						bindingDict: {#identity -> #leftSiblings}
						visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #parent}
						patternChildren: {
							SBEllipsisPattern
								bindingDict: {#identity -> #grandchildren}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern
						bindingDict: {#identity -> #rightSiblings}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aTree
]

{ #category : #examples }
SBTransformation >> exampleTransformInputDifferentStrategies: aTree [

	self
		example: [SBTransformation new]
		args: [
			{
				((SBDummyNode key: 1)
					left: ((SBDummyNode key: 2) left: (SBDummyNode key: 3));
					right: ((SBDummyNode key: 4) left: (SBDummyNode key: 5))) showAsDomainBlock}]
		label: 'example'.
	"Compare this one to the exampleTransformInputAsOftenAsPossible. Our Pattern Matching supports 'root matching' (anchor the first node at the tree's root) and 'subtree matching' (the first node can by any node in the tree, the remaining matching only happens on that node's subtree). The patternChildren can also explicit (must be there 
for a match) and implicit (may or may not be there)"
	"You can toggle between the strategies using the buttons"
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #parent}
				patternChildren: {SBBindingPattern bindingDict: {#identity -> #child} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #parent) key < (bindings at: #child) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #child}
				patternChildren: {SBBindingPattern bindingDict: {#identity -> #parent} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aTree
]

{ #category : #examples }
SBTransformation >> exampleTransformWithConstant: aTree [

	self
		example: [SBTransformation new]
		args: [{(SBDummyNode key: 1) showAsDomainBlock}]
		label: 'example'.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {SBBindingPattern bindingDict: {#identity -> #a} visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> [5]}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: 1) value: aTree
]

{ #category : #examples }
SBTransformation >> exampleTransformWithExpression: aTree [

	| newValue |
	self
		example: [SBTransformation new]
		args: [{(SBDummyNode key: 1) showAsDomainBlock}]
		label: 'example'.
	newValue := 100.
	"Since we do not use a constraint here, we should only transform the input once. Otherwise there would be endless matches."
	^ (SBTransformation
		input: (SBGroupPattern patterns: {SBBindingPattern bindingDict: {#identity -> #a} visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> [newValue]}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: 1) value: aTree
]

{ #category : #examples }
SBTransformation >> exampleWithConstants: aDummyNode [

	| currentNode |
	self
		example: [SBTransformation new]
		args: [{((SBDummyNode key: 9) left: ((SBDummyNode key: 10) left: (SBDummyNode key: 8))) showAsDomainBlock}]
		label: 'example'.
	
	currentNode := aDummyNode.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				expressionDict: {#identity -> [currentNode]}
				patternChildren: {
					SBBindingPattern
						bindingDict: {#identity -> #a}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				patternChildren: {
					SBBindingPattern
						expressionDict: {#identity -> [currentNode]}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value
]

{ #category : #'as yet unclassified' }
SBTransformation >> hideColorDifferences [
	<action>

	| inputBindingDict outputBindingDict |
	inputBindingDict := self findAllIdentityBindingsAsDict: self pattern.
	outputBindingDict := self findAllIdentityBindingsAsDict: self outputPattern.
	inputBindingDict do: [:binding | binding detachDecorators: SBColorAccentDecorator].
	outputBindingDict do: [:binding | binding detachDecorators: SBColorAccentDecorator]
]

{ #category : #'as yet unclassified' }
SBTransformation >> initialize [

	super initialize.
	self replaceCount: Float infinity
]

{ #category : #'as yet unclassified' }
SBTransformation >> input: aPattern output: anotherPattern [

	self
		pattern: aPattern;
		outputPattern: (anotherPattern isOutputPattern: true).
	
	self pattern owner
		addMorphBack: (SBColumn new
			cellPositioning: #center;
			cellGap: 6;
			addMorphBack: (self newRepeatCountMorphFor: replaceCount);
			addMorphBack: SBIcon iconSyncAlt large);
		addMorphBack: self outputPattern.
	self class colorizeDifferences ifTrue: [self colorDifferences]
]

{ #category : #'as yet unclassified' }
SBTransformation >> newRepeatCountMorphFor: aNumber [

	aNumber isInfinite
		ifTrue: [^ SBIcon iconInfinity color: Color red muchDarker]
		ifFalse: [^ SBStNumber new value: aNumber]
]

{ #category : #accessing }
SBTransformation >> outputPattern [

	^ outputPattern
]

{ #category : #accessing }
SBTransformation >> outputPattern: anSBGroupPattern [

	outputPattern := anSBGroupPattern
]

{ #category : #accessing }
SBTransformation >> replaceCount [

	^ self replaceCountInput
		ifNotNil: [:replaceCountInput |
			(replaceCountInput isSandblock and: [replaceCountInput isNumberBlock])
				ifTrue: [replaceCountInput value]
				ifFalse: [Float infinity]]
		ifNil: [replaceCount]
]

{ #category : #accessing }
SBTransformation >> replaceCount: aNumber [

	replaceCount := aNumber
]

{ #category : #accessing }
SBTransformation >> replaceCountInput [

	^ self pattern owner ifNotNil: [:owner | owner submorphs second firstSubmorph]
]

{ #category : #'as yet unclassified' }
SBTransformation >> toggleImplicitChildTo: aBoolean withBinding: aString [

	super toggleImplicitChildTo: aBoolean withBinding: aString.
	self toggleImplicitChildTo: aBoolean withBinding: aString on: self outputPattern
]

{ #category : #actions }
SBTransformation >> toggleInfiniteRepeats [
	<action>

	self sandblockEditor do: (SBReplaceCommand new
		target: self replaceCountInput;
		replacer: (self replaceCount isInfinite
			ifTrue: [self newRepeatCountMorphFor: 1]
			ifFalse: [self newRepeatCountMorphFor: Float infinity]);
		shouldMergeWithNext: true;
		yourself)
]

{ #category : #accessing }
SBTransformation >> value [

	^ self value: self pattern findOriginRoot
]

{ #category : #accessing }
SBTransformation >> value: anObject [

	| matcher currentPrimitive match iteration |
	currentPrimitive := anObject asDomainBlock.
	matcher := (SBPatternMatcher input: currentPrimitive pattern: self pattern) strategy: self strategy.
	iteration := 0.
	[(match := matcher getNextMatch) notNil and: [(iteration := iteration + 1) <= self replaceCount]] whileTrue: [
		currentPrimitive := matcher build: self outputPattern fromBinding: match.
		matcher input: currentPrimitive].
	^ currentPrimitive buildObject
]

{ #category : #printing }
SBTransformation >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBTransformation input: '.
	self pattern writeSourceOn: aStream.
	aStream nextPutAll: ' output: '.
	self outputPattern writeSourceOn: aStream.
	
	aStream nextPutAll: ' strategy: '.
	self strategy storeOn: aStream.
	
	aStream nextPutAll: ' visualizePatternsAs: '.
	self defaultVisualizationClass storeOn: aStream.
	
	aStream nextPutAll: ' replaceCount: '.
	self replaceCount storeOn: aStream.
	
	aStream nextPut: $)
]
