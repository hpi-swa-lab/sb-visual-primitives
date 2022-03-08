"
An SBTransformation is the visual representation of a pattern matching rule with SBDomainBlocks. It consists of an input and an output pattern (see SBPattern). For the pattern matching see SBPatternMatcher. You can choose a default class that determines the domainBlockMapping for the SBBindingPatterns.

By applying the case on an input object, the input pattern gets matched on this object and the matched part gets transformed to match the output pattern.

Instance Variables
	outputPattern:		SBBlock (SBPattern)

outputPattern
	- this is the result of the transformation
	if true, the root of every SBBindingPattern only matches the root of the input
	if false, the pattern can also match somewhere else in the input without further specification

"
Class {
	#name : #SBTransformation,
	#superclass : #SBPatternContainer,
	#instVars : [
		'outputPattern'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBTransformation class >> input: aPattern output: anotherPattern [
	" marker "

	^ self new input: aPattern output: anotherPattern
]

{ #category : #'as yet unclassified' }
SBTransformation class >> input: aPattern output: anotherPattern strategy: aDict [
	" marker "

	^ self new
		input: aPattern output: anotherPattern;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBTransformation class >> input: aPattern output: anotherPattern strategy: aDict visualizePatternsAs: aClass [
	" marker "

	^ self new
		defaultVisualizationClass: aClass;
		input: aPattern output: anotherPattern;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBTransformation class >> matches: aBlock [

	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [{#input:output:. #input:output:strategy:. #input:output:strategy:visualizePatternsAs:} anySatisfy: [:selector | self selector: selector receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBTransformation class >> newFor: aBlock [

	| input output |
	input := aBlock arguments first.
	input isDomainBlock ifFalse: [input := input evaluate].
	output := aBlock arguments second.
	output isDomainBlock ifFalse: [output := output evaluate].
	
	^ aBlock arguments size > 2
		ifTrue: [ | strategy |
			strategy := aBlock arguments third evaluate.
			aBlock arguments size > 3
				ifTrue: [
					self
						input: input
						output: output
						strategy: strategy
						visualizePatternsAs: aBlock arguments fourth evaluate]
				ifFalse: [self input: input output: output strategy: strategy]]
		ifFalse: [self input: input output: output]
]

{ #category : #'as yet unclassified' }
SBTransformation class >> suggestion [
	"Used for the projection"

	^ [:block | | case |
		case := self input: SBGroupPattern new output: SBGroupPattern new.
		block sandblockEditor do: (SBReplaceCommand new
			target: block;
			replacer: case;
			yourself).
		case classNameInput promptClassForVPCase]
]

{ #category : #'as yet unclassified' }
SBTransformation >> buildImplicitChildrenMatchingPattern [

	(self pattern notNil and: [self outputPattern notNil]) ifTrue: [
		self pattern removeImplicitChildren.
		self outputPattern removeImplicitChildren.
		
		self explicitChildrenMatching ifFalse: [ | additionalNodes |
			additionalNodes := Dictionary new.
			self pattern buildImplicitChildren: additionalNodes.
			self outputPattern addImplicitChildren: additionalNodes]]
]

{ #category : #'as yet unclassified' }
SBTransformation >> colorDifferences [

	| inputRoot outputRoot inputBindingDict outputBindingDict colors |
	inputRoot := self pattern connections first.
	outputRoot := self outputPattern connections first.
	
	inputBindingDict := self findAllBindings: inputRoot.
	outputBindingDict := self findAllBindings: outputRoot.
	
	colors := Color wheel: inputBindingDict size saturation: 1.0 brightness: 1.0.
	
	inputBindingDict keysDo: [:bindingKey | | inputNode outputNode |
		inputNode := inputBindingDict at: bindingKey.
		outputNode := outputBindingDict at: bindingKey ifAbsent: [nil].
		outputNode isNil ifTrue: [] ifFalse: [
			inputNode connections withIndexDo: [:connection :index | | outputConnection c |
				outputConnection := outputNode connections at: index ifAbsent: [nil].
				c := colors at: connection label.
				connection label = (outputConnection ifNotNil: #label) ifFalse: [
					connection color: c.
					(outputBindingDict at: connection label ifAbsent: [nil]) ifNotNil: [:o | o color: c]]]]]
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
	"building the implicit children seems to not work."
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #parent}
				children: {
					SBBindingPattern
						bindingDict: {#identity -> #nodeWeWantToDelete}
						children: {}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #nodeWeWantToDelete) key = 42]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #parent}
				children: {}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
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
				children: {
					SBBindingPattern
						bindingDict: {#identity -> #b}
						children: {
							SBEllipsisPattern
								bindingDict: {#innerLabel -> #g. #identity -> #bChildren}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #c}
						children: {
							SBEllipsisPattern
								bindingDict: {#innerLabel -> #g. #identity -> #cChildren}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBBindingPattern
						bindingDict: {#identity -> #b}
						children: {
							SBEllipsisPattern
								bindingDict: {#identity -> #bChildren}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBBindingPattern bindingDict: {#identity -> #c} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aDummyNode
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
				children: {
					SBBindingPattern
						expressionDict: {#identity -> [newNode]}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBStringDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBTransformation >> exampleMissingBindingsAreMarked: aTree [
	"Notice how bindings are marked if they are not found in the input."

	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #g}
				children: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #boi) key < (bindings at: #boi) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBBindingPattern
						bindingDict: {#identity -> #notFound}
						visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aTree
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
				children: {
					SBEllipsisPattern
						bindingDict: {#identity -> #leftSiblings}
						visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #child}
						children: {
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
				children: {
					SBEllipsisPattern
						bindingDict: {#identity -> #leftSiblings}
						visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #parent}
						children: {
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
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aTree
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
	"Compare this one to the exampleTransformInputAsOftenAsPossible. Our Pattern Matching supports 'root matching' (anchor the first node at the tree's root) and 'subtree matching' (the first node can by any node in the tree, the remaining matching only happens on that node's subtree). The children can also explicit (must be there 
for a match) and implicit (may or may not be there)"
	"You can toggle between the strategies using the buttons"
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #parent}
				children: {SBBindingPattern bindingDict: {#identity -> #child} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #parent) key < (bindings at: #child) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #child}
				children: {SBBindingPattern bindingDict: {#identity -> #parent} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aTree
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
		visualizePatternsAs: SBDummyNode)
		replace: 1
		matches: aTree
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
		visualizePatternsAs: SBDummyNode)
		replace: 1
		matches: aTree
]

{ #category : #examples }
SBTransformation >> exampleWithConstants: aDummyNode [

	| salzstangen |
	self
		example: [SBTransformation new]
		args: [
			{
				((SBDummyNode key: 9) left: ((SBDummyNode key: 10) left: (SBDummyNode key: 8))) showAsDomainBlock}]
		label: 'example'.
	
	salzstangen := aDummyNode.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				expressionDict: {#identity -> [salzstangen]}
				children: {
					SBBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBBindingPattern
						expressionDict: {#identity -> [salzstangen]}
						children: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aDummyNode
]

{ #category : #'as yet unclassified' }
SBTransformation >> input: aPattern output: anotherPattern [

	self
		pattern: aPattern;
		outputPattern: (anotherPattern isOutputPattern: true).
	self buildImplicitChildrenMatchingPattern
]

{ #category : #'as yet unclassified' }
SBTransformation >> noteNewOwner: aMorph [

	| wasBuilt |
	wasBuilt := self classNameInput notNil.
	super noteNewOwner: aMorph.
	(wasBuilt not and: [self classNameInput notNil]) ifTrue: [
		self pattern owner
			addMorphBack: SBIcon iconArrowRight;
			addMorphBack: self outputPattern]
]

{ #category : #'as yet unclassified' }
SBTransformation >> outputPattern [

	^ outputPattern
]

{ #category : #'as yet unclassified' }
SBTransformation >> outputPattern: aPattern [

	outputPattern := aPattern
]

{ #category : #'as yet unclassified' }
SBTransformation >> replace: aNumber matches: anObject [

	| matcher currentPrimitive match iteration |
	currentPrimitive := anObject asDomainBlock.
	matcher := (SBPatternMatcher input: currentPrimitive pattern: self pattern) strategy: self strategy.
	iteration := 0.
	[(match := matcher getNextMatch) notNil and: [(iteration := iteration + 1) <= aNumber]] whileTrue: [
		currentPrimitive := matcher build: self outputPattern fromBinding: match.
		matcher input: currentPrimitive].
	^ currentPrimitive buildObject
]

{ #category : #'as yet unclassified' }
SBTransformation >> replaceAllMatches [

	^ self replaceAllMatches: self pattern findOriginRoot
]

{ #category : #'as yet unclassified' }
SBTransformation >> replaceAllMatches: anObject [

	| matcher currentPrimitive match |
	currentPrimitive := anObject asDomainBlock.
	
	matcher := (SBPatternMatcher input: currentPrimitive pattern: self pattern) strategy: self strategy.
	[match := matcher getNextMatch] whileNotNil: [
		currentPrimitive := matcher build: self outputPattern fromBinding: match.
		matcher input: currentPrimitive].
	^ currentPrimitive buildObject
]

{ #category : #'as yet unclassified' }
SBTransformation >> toggleImplicitChildTo: aBoolean withBinding: aString [

	super toggleImplicitChildTo: aBoolean withBinding: aString on: self outputPattern.
	self toggleImplicitChildTo: aBoolean withBinding: aString on: self outputPattern
]

{ #category : #'as yet unclassified' }
SBTransformation >> value [

	^ self value: self pattern findOriginRoot
]

{ #category : #'as yet unclassified' }
SBTransformation >> value: anObject [

	| matcher match |
	matcher := (SBPatternMatcher
		input: anObject asDomainBlock
		pattern: self pattern) strategy: self strategy.
	match := matcher getNextMatch.
	^ match
		ifNil: [anObject]
		ifNotNil: [(matcher build: self outputPattern fromBinding: match) buildObject]
]

{ #category : #'as yet unclassified' }
SBTransformation >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBTransformation input: '.
	self pattern writeSourceOn: aStream.
	aStream nextPutAll: ' output: '.
	self outputPattern writeSourceOn: aStream.
	
	self strategy ifNotNil: [
		aStream nextPutAll: ' strategy: '.
		self strategy storeOn: aStream].
	
	self defaultVisualizationClass ifNotNil: [
		aStream nextPutAll: ' visualizePatternsAs: '.
		self defaultVisualizationClass storeOn: aStream].
	
	aStream nextPut: $)
]
