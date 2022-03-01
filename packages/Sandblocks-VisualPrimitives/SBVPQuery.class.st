"
A SBVPQuery is used to query a part of the input that matches the query's pattern.

Instance Variables
	input:		<Object>
	strategy:		<Object>

input
	- xxxxx

strategy
	- xxxxx

"
Class {
	#name : #SBVPQuery,
	#superclass : #SBStSubstitution,
	#instVars : [
		'input',
		'strategy'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPQuery class >> exampleExtractLeafOf: salzstangen [

	| newMaybeLeaf currentNode |
	self
		example: [SBVPQuery]
		args: [
			{
				((SBVPDummyNode key: 9) left: ((SBVPDummyNode key: 10) left: (SBVPDummyNode key: 7))) showAsVisualPrimitive}]
		label: 'example'.
	currentNode := salzstangen.
	[
		SBVPQuery
			input: (SBVPGroupPattern patterns: {
				SBVPBindingPattern
					expressionDict: {#identity -> [currentNode]}
					children: {SBVPBindingPattern bindingDict: {#identity -> #newChild}}})
			output: []
			strategy: (Dictionary new
				add: #explicitRootMatching -> true;
				add: #explicitChildrenMatching -> true;
				yourself)
			visualizePatternsAs: SBVPDummyNode] whileNotNil: [
		currentNode := newMaybeLeaf.
		Transcript showln: 'HI'].
	^ currentNode
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> exampleTwo: salzstangen [

	| gerhard currentSnack |
	SBExample
		self: [SBVPQuery]
		args: [{SBVPDummyNode buildTree: {9 -> {10 -> {7}}}}]
		label: 'example'.
	currentSnack := salzstangen.
	[
		SBVPQuery
			input: (SBVPGroupPattern patterns: {
				SBVPBindingPattern
					bindingDict: {#identity -> #c}
					expressionDict: {#topLeftLabel -> ['REPEAT1']}
					children: {SBVPBindingPattern bindingDict: {#identity -> #b}}})
			strategy: {#explicitRootMatching -> true} asDictionary] whileNotNil: [
		Transcript showln: gerhard key.
		currentSnack := gerhard].
	^ gerhard
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anSBVPVisualizer [
	" marker "

	^ self new
		input: anSBVPVisualizer;
		output: []
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anSBVPVisualizer output: aBlock [
	" marker "

	^ self new
		input: anSBVPVisualizer;
		output: aBlock
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anSBVPVisualizer output: aBlock strategy: aDict [
	" marker "

	^ self new
		input: anSBVPVisualizer;
		output: aBlock;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anSBVPVisualizer output: aBlock strategy: aDict visualizePatternsAs: aClass [
	" marker "

	^ self new
		input: anSBVPVisualizer;
		output: aBlock;
		strategy: aDict;
		defaultPatternVisualizationClass: aClass;
		yourself
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anSBVPVisualizer strategy: aDict [
	" marker "

	^ self new
		input: anSBVPVisualizer;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [{#input:. #input:strategy:. #input:output:strategy:. #input:output:strategy:visualizePatternsAs:} anySatisfy: [:selector | self selector: selector receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> newFor: aBlock [

	| input output |
	input := aBlock arguments first.
	input isVisualPrimitive ifFalse: [input := input evaluate].
	output := aBlock arguments second evaluate asSandblock.
	^ aBlock arguments size caseOf: {
		[1] -> [self input: input].
		[2] -> [self input: input output: output].
		[3] -> [self input: input output: output strategy: aBlock arguments third evaluate].
		[4] -> [
			self
				input: input
				output: output
				strategy: aBlock arguments third evaluate
				visualizePatternsAs: aBlock arguments fourth evaluate]}
]

{ #category : #'as yet unclassified' }
SBVPQuery >> buildImplicitChildrenMatchingPattern [

	self input notNil ifTrue: [
		self input removeImplicitChildren.
		
		self explicitChildrenMatching ifFalse: [ | additionalNodes |
			additionalNodes := Dictionary new.
			self input
				buildImplicitChildren: additionalNodes;
				attachTreeDecorator].
		self input layout]
]

{ #category : #'as yet unclassified' }
SBVPQuery >> input: anSBBlock output: anotherSBBlock [

	self
		input: anSBBlock;
		output: anotherSBBlock.
	
	self buildImplicitChildrenMatchingPattern
]

{ #category : #'as yet unclassified' }
SBVPQuery >> query [

	^ self query: self input findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPQuery >> query: anSBVPDummyNode [

	| matcher match |
	matcher := (SBVPPatternMatcher
		input: anSBVPDummyNode asVisualPrimitive
		pattern: self input) strategy: self strategy.
	match := matcher getNextMatch.
	^ match ifNil: [nil] ifNotNil: [(match at: #a) getObjectFromVisualPrimitive]
]

{ #category : #'as yet unclassified' }
SBVPQuery >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPQuery input: '.
	self input writeSourceOn: aStream.
	aStream nextPutAll: ' output: '.
	self output writeSourceOn: aStream.
	
	self strategy ifNotNil: [
		aStream nextPutAll: ' strategy: '.
		self strategy storeOn: aStream].
	
	self defaultPatternVisualizationClass ifNotNil: [
		aStream nextPutAll: ' visualizePatternsAs: '.
		self defaultPatternVisualizationClass storeOn: aStream].
	
	aStream nextPut: $)
]
