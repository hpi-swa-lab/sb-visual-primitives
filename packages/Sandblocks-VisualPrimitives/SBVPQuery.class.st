"
An SBVPQuery is used to query a part of the input that matches the query's pattern.
"
Class {
	#name : #SBVPQuery,
	#superclass : #SBVPPatternContainer,
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
		(SBVPQuery
			pattern: (SBVPGroupPattern patterns: {
				SBVPBindingPattern
					expressionDict: {#identity -> [currentNode]}
					children: {SBVPBindingPattern writeBackClosure: [:var | newMaybeLeaf := var]}})
			strategy: (Dictionary new
				add: #explicitRootMatching -> false;
				add: #explicitChildrenMatching -> false;
				yourself)
			visualizePatternsAs: SBVPDummyNode) query] whileNotNil: [
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
			pattern: (SBVPGroupPattern patterns: {
				SBVPBindingPattern
					bindingDict: {#identity -> #c}
					expressionDict: {#topLeftLabel -> ['REPEAT1']}
					connections: {SBVPBindingPattern bindingDict: {#identity -> #b}}})
			strategy: {#explicitRootMatching -> true} asDictionary] whileNotNil: [
		Transcript showln: gerhard key.
		currentSnack := gerhard].
	^ gerhard
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

	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [{#pattern:. #pattern:strategy:. #pattern:strategy:visualizePatternsAs:} anySatisfy: [:selector | self selector: selector receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> newFor: aBlock [

	| pattern |
	pattern := aBlock arguments first.
	pattern isVisualPrimitive ifFalse: [pattern := pattern evaluate].
	^ aBlock arguments size caseOf: {
		[1] -> [self pattern: pattern].
		[2] -> [self pattern: pattern strategy: aBlock arguments second evaluate].
		[3] -> [
			self
				pattern: pattern
				strategy: aBlock arguments second evaluate
				visualizePatternsAs: aBlock arguments third evaluate]}
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> pattern: anSBVPVisualizer [
	" marker "

	^ self new pattern: anSBVPVisualizer
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> pattern: anSBVPVisualizer strategy: aDict [
	" marker "

	^ self new
		pattern: anSBVPVisualizer;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> pattern: aPattern strategy: aDict visualizePatternsAs: aClass [
	" marker "

	^ self new
		pattern: aPattern;
		strategy: aDict;
		defaultVisualizationClass: aClass;
		yourself
]

{ #category : #'as yet unclassified' }
SBVPQuery >> query [

	^ self query: self pattern findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPQuery >> query: anObject [

	| matcher match |
	matcher := (SBVPPatternMatcher
		input: anObject asVisualPrimitive
		pattern: self pattern) strategy: self strategy.
	match := matcher getNextMatch.
	^ match
]

{ #category : #'as yet unclassified' }
SBVPQuery >> toggleImplicitChildTo: aBoolean withBinding: aString [

	self toggleImplicitChildTo: aBoolean withBinding: aString on: self pattern
]

{ #category : #'as yet unclassified' }
SBVPQuery >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPQuery pattern: '.
	self pattern writeSourceOn: aStream.
	
	self strategy ifNotNil: [
		aStream nextPutAll: ' strategy: '.
		self strategy storeOn: aStream].
	
	self defaultVisualizationClass ifNotNil: [
		aStream nextPutAll: ' visualizePatternsAs: '.
		self defaultVisualizationClass storeOn: aStream].
	
	aStream nextPut: $)
]
