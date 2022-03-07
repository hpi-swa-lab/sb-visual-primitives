"
An SBVPTransformation is the visual representation of a pattern matching rule with SBVisualPrimitives. It consists of an input and an output pattern (see SBVPPattern). For the pattern matching see SBVPPatternMatcher. You can choose a default class that determines the visualPrimitiveMapping for the SBVPBindingPatterns.

By applying the case on an input object, the input pattern gets matched on this object and the matched part gets transformed to match the output pattern.

Instance Variables
	outputPattern:		SBBlock (SBVPPattern)

outputPattern
	- this is the result of the transformation
	if true, the root of every SBVPBindingPattern only matches the root of the input
	if false, the pattern can also match somewhere else in the input without further specification

"
Class {
	#name : #SBVPTransformation,
	#superclass : #SBVPPatternContainer,
	#instVars : [
		'outputPattern'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPTransformation class >> input: aPattern output: anotherPattern [
	" marker "

	^ self new input: aPattern output: anotherPattern
]

{ #category : #'as yet unclassified' }
SBVPTransformation class >> input: aPattern output: anotherPattern strategy: aDict [
	" marker "

	^ self new
		input: aPattern output: anotherPattern;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPTransformation class >> input: aPattern output: anotherPattern strategy: aDict visualizePatternsAs: aClass [
	" marker "

	^ self new
		defaultVisualizationClass: aClass;
		input: aPattern output: anotherPattern;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPTransformation class >> matches: aBlock [

	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [{#input:output:. #input:output:strategy:. #input:output:strategy:visualizePatternsAs:} anySatisfy: [:selector | self selector: selector receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPTransformation class >> newFor: aBlock [

	| input output |
	input := aBlock arguments first.
	input isVisualPrimitive ifFalse: [input := input evaluate].
	output := aBlock arguments second.
	output isVisualPrimitive ifFalse: [output := output evaluate].
	
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
SBVPTransformation class >> suggestion [
	"Used for the projection"

	^ [:block | | case |
		case := self input: SBVPGroupPattern new output: SBVPGroupPattern new.
		block sandblockEditor do: (SBReplaceCommand new
			target: block;
			replacer: case;
			yourself).
		case classNameInput promptClassForVPCase]
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> buildImplicitChildrenMatchingPattern [

	(self pattern notNil and: [self outputPattern notNil]) ifTrue: [
		self pattern removeImplicitChildren.
		self outputPattern removeImplicitChildren.
		
		self explicitChildrenMatching ifFalse: [ | additionalNodes |
			additionalNodes := Dictionary new.
			self pattern buildImplicitChildren: additionalNodes.
			self outputPattern addImplicitChildren: additionalNodes]]
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> colorDifferences [

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
SBVPTransformation >> exampleDeleteNodeInside: aTree [

	self
		example: [SBVPTransformation new]
		args: [
			{
				((SBVPDummyNode key: 1)
					left: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 3));
					right: ((SBVPDummyNode key: 4) left: (SBVPDummyNode key: 42))) showAsVisualPrimitive}]
		label: 'example'.
	"Nodes that do not appear in the output pattern, are simply left out / deleted."
	self flag: #bug.
	"building the implicit children seems to not work."
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #parent}
				children: {
					SBVPBindingPattern
						bindingDict: {#identity -> #nodeWeWantToDelete}
						children: {}
						visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #nodeWeWantToDelete) key = 42]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #parent}
				children: {}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aTree
]

{ #category : #examples }
SBVPTransformation >> exampleInsertWithExpression: aTree [

	| newNode |
	self
		example: [SBVPTransformation new]
		args: [{(SBVPStringDummyNode key: 'should get a new child') showAsVisualPrimitive}]
		label: 'example'.
	newNode := (SBVPStringDummyNode key: 'to be inserted node') showAsVisualPrimitive.
	"newNode is set as an Expression for the key in the child of a"
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {SBVPBindingPattern bindingDict: {#identity -> #a} visualizingClass: SBVPDummyNode})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBVPBindingPattern
						expressionDict: {#identity -> [newNode]}
						visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPStringDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> exampleMissingBindingsAreMarked: aTree [
	"Notice how bindings are marked if they are not found in the input."

	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #g}
				children: {
					SBVPEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #boi) key < (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBVPBindingPattern
						bindingDict: {#identity -> #notFound}
						visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aTree
]

{ #category : #examples }
SBVPTransformation >> exampleTransformInputAsOftenAsPossible: aTree [

	self
		example: [SBVPTransformation new]
		args: [
			{
				((SBVPDummyNode key: 1)
					left: ((SBVPDummyNode key: 2)
						left: (SBVPDummyNode key: 3);
						right: (SBVPDummyNode key: 4));
					right: ((SBVPDummyNode key: 5)
						left: (SBVPDummyNode key: 6);
						right: (SBVPDummyNode key: 7))) showAsVisualPrimitive}]
		label: 'example'.
	"In this example we will create a MaxHeap by matching any parent and child and checking wether they violate the heap condition. If they do, we swap them."
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #parent}
				children: {
					SBVPEllipsisPattern
						bindingDict: {#identity -> #leftSiblings}
						visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #child}
						children: {
							SBVPEllipsisPattern
								bindingDict: {#identity -> #grandchildren}
								visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern
						bindingDict: {#identity -> #rightSiblings}
						visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #parent) key < (bindings at: #child) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #child}
				children: {
					SBVPEllipsisPattern
						bindingDict: {#identity -> #leftSiblings}
						visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #parent}
						children: {
							SBVPEllipsisPattern
								bindingDict: {#identity -> #grandchildren}
								visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern
						bindingDict: {#identity -> #rightSiblings}
						visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aTree
]

{ #category : #examples }
SBVPTransformation >> exampleTransformInputDifferentStrategies: aTree [

	self
		example: [SBVPTransformation new]
		args: [
			{
				((SBVPDummyNode key: 1)
					left: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 3));
					right: ((SBVPDummyNode key: 4) left: (SBVPDummyNode key: 5))) showAsVisualPrimitive}]
		label: 'example'.
	"Compare this one to the exampleTransformInputAsOftenAsPossible. Our Pattern Matching supports 'root matching' (anchor the first node at the tree's root) and 'subtree matching' (the first node can by any node in the tree, the remaining matching only happens on that node's subtree). The children can also explicit (must be there 
for a match) and implicit (may or may not be there)"
	"You can toggle between the strategies using the buttons"
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #parent}
				children: {SBVPBindingPattern bindingDict: {#identity -> #child} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #parent) key < (bindings at: #child) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #child}
				children: {SBVPBindingPattern bindingDict: {#identity -> #parent} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aTree
]

{ #category : #examples }
SBVPTransformation >> exampleTransformWithConstant: aTree [

	self
		example: [SBVPTransformation new]
		args: [{(SBVPDummyNode key: 1) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {SBVPBindingPattern bindingDict: {#identity -> #a} visualizingClass: SBVPDummyNode})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> ['5']}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPDummyNode)
		replace: 1
		matches: aTree
]

{ #category : #examples }
SBVPTransformation >> exampleTransformWithExpression: aTree [

	| newValue |
	self
		example: [SBVPTransformation new]
		args: [{(SBVPDummyNode key: 1) showAsVisualPrimitive}]
		label: 'example'.
	newValue := 100.
	"Since we do not use a constraint here, we should only transform the input once. Otherwise there would be endless matches."
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {SBVPBindingPattern bindingDict: {#identity -> #a} visualizingClass: SBVPDummyNode})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> [newValue]}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPDummyNode)
		replace: 1
		matches: aTree
]

{ #category : #examples }
SBVPTransformation >> exampleWithConstants: aDummyNode [

	| salzstangen |
	self
		example: [SBVPTransformation new]
		args: [
			{
				((SBVPDummyNode key: 9) left: ((SBVPDummyNode key: 10) left: (SBVPDummyNode key: 8))) showAsVisualPrimitive}]
		label: 'example'.
	
	salzstangen := aDummyNode.
	^ (SBVPTransformation
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
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)) replaceAllMatches
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> input: aPattern output: anotherPattern [

	self
		pattern: aPattern;
		outputPattern: (anotherPattern isOutputPattern: true).
	self buildImplicitChildrenMatchingPattern
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> noteNewOwner: aMorph [

	| wasBuilt |
	wasBuilt := self classNameInput notNil.
	super noteNewOwner: aMorph.
	(wasBuilt not and: [self classNameInput notNil]) ifTrue: [
		self pattern owner
			addMorphBack: SBIcon iconArrowRight;
			addMorphBack: self outputPattern]
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> outputPattern [

	^ outputPattern
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> outputPattern: aPattern [

	outputPattern := aPattern
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> replace: aNumber matches: anObject [

	| matcher currentPrimitive match iteration |
	currentPrimitive := anObject asVisualPrimitive.
	matcher := (SBVPPatternMatcher input: currentPrimitive pattern: self pattern) strategy: self strategy.
	iteration := 0.
	[(match := matcher getNextMatch) notNil and: [(iteration := iteration + 1) < aNumber]] whileTrue: [
		currentPrimitive := matcher build: self outputPattern fromBinding: match.
		matcher input: currentPrimitive].
	^ currentPrimitive buildObject
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> replaceAllMatches [

	^ self replaceAllMatches: self pattern findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> replaceAllMatches: anObject [

	| matcher currentPrimitive match |
	currentPrimitive := anObject asVisualPrimitive.
	
	matcher := (SBVPPatternMatcher input: currentPrimitive pattern: self pattern) strategy: self strategy.
	[match := matcher getNextMatch] whileNotNil: [
		currentPrimitive := matcher build: self outputPattern fromBinding: match.
		matcher input: currentPrimitive].
	^ currentPrimitive buildObject
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> toggleImplicitChildTo: aBoolean withBinding: aString [

	super toggleImplicitChildTo: aBoolean withBinding: aString on: self outputPattern.
	self toggleImplicitChildTo: aBoolean withBinding: aString on: self outputPattern
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> value [

	^ self value: self pattern findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> value: anObject [

	| matcher match |
	matcher := (SBVPPatternMatcher
		input: anObject asVisualPrimitive
		pattern: self pattern) strategy: self strategy.
	match := matcher getNextMatch.
	^ match
		ifNil: [anObject]
		ifNotNil: [(matcher build: self outputPattern fromBinding: match) buildObject]
]

{ #category : #'as yet unclassified' }
SBVPTransformation >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPTransformation input: '.
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
