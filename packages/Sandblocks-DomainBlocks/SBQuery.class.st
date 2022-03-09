"
An SBQuery is used to query a part of the input that matches the query's pattern.
"
Class {
	#name : #SBQuery,
	#superclass : #SBPatternContainer,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBQuery class >> exampleExtractLeafOf: salzstangen [

	| newMaybeLeaf currentNode |
	self
		example: [SBQuery]
		args: [{((SBDummyNode key: 9) left: ((SBDummyNode key: 10) left: (SBDummyNode key: 7))) showAsDomainBlock}]
		label: 'example'.
	currentNode := salzstangen.
	[
		(SBQuery
			pattern: (SBGroupPattern patterns: {
				SBBindingPattern
					expressionDict: {#identity -> [currentNode]}
					children: {SBBindingPattern writeBackClosure: [:var | newMaybeLeaf := var]}})
			strategy: (Dictionary new
				add: #explicitRootMatching -> false;
				add: #explicitChildrenMatching -> false;
				yourself)
			visualizePatternsAs: SBDummyNode) query] whileNotNil: [
		currentNode := newMaybeLeaf.
		Transcript showln: 'HI'].
	^ currentNode
]

{ #category : #'as yet unclassified' }
SBQuery class >> exampleTwo: salzstangen [

	| gerhard currentSnack |
	SBExample self: [SBQuery] args: [{SBDummyNode buildTree: {9 -> {10 -> {7}}}}] label: 'example'.
	currentSnack := salzstangen.
	[
		SBQuery
			pattern: (SBGroupPattern patterns: {
				SBBindingPattern
					bindingDict: {#identity -> #c}
					expressionDict: {#topLeftLabel -> ['REPEAT1']}
					connections: {SBBindingPattern bindingDict: {#identity -> #b}}})
			strategy: {#explicitRootMatching -> true} asDictionary] whileNotNil: [
		Transcript showln: gerhard key.
		currentSnack := gerhard].
	^ gerhard
]

{ #category : #'as yet unclassified' }
SBQuery class >> input: anSBDomainBlockContainer strategy: aDict [
	" marker "

	^ self new
		input: anSBDomainBlockContainer;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBQuery class >> matches: aBlock [

	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [{#pattern:. #pattern:strategy:. #pattern:strategy:visualizePatternsAs:} anySatisfy: [:selector | self selector: selector receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBQuery class >> newFor: aBlock [

	| pattern |
	pattern := aBlock arguments first.
	pattern isDomainBlock ifFalse: [pattern := pattern evaluate].
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
SBQuery class >> pattern: anSBDomainBlockContainer [
	" marker "

	^ self new pattern: anSBDomainBlockContainer
]

{ #category : #'as yet unclassified' }
SBQuery class >> pattern: anSBDomainBlockContainer strategy: aDict [
	" marker "

	^ self new
		pattern: anSBDomainBlockContainer;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBQuery class >> pattern: aPattern strategy: aDict visualizePatternsAs: aClass [
	" marker "

	^ self new
		pattern: aPattern;
		strategy: aDict;
		defaultVisualizationClass: aClass;
		yourself
]

{ #category : #'as yet unclassified' }
SBQuery >> query [

	^ self query: self pattern findOriginRoot
]

{ #category : #'as yet unclassified' }
SBQuery >> query: anObject [

	| matcher match |
	matcher := (SBPatternMatcher input: anObject asDomainBlock pattern: self pattern) strategy: self strategy.
	match := matcher getNextMatch.
	^ match
]

{ #category : #'as yet unclassified' }
SBQuery >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBQuery pattern: '.
	self pattern writeSourceOn: aStream.
	
	self strategy ifNotNil: [
		aStream nextPutAll: ' strategy: '.
		self strategy storeOn: aStream].
	
	self defaultVisualizationClass ifNotNil: [
		aStream nextPutAll: ' visualizePatternsAs: '.
		self defaultVisualizationClass storeOn: aStream].
	
	aStream nextPut: $)
]
