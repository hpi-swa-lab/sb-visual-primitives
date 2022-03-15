"
An SBQuery is used to query a part of the input that matches the query's pattern.
"
Class {
	#name : #SBQuery,
	#superclass : #SBPatternContainer,
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #'as yet unclassified' }
SBQuery class >> exampleExtractLeafOf: aNode [

	| newLeaf currentNode |
	self
		example: [SBQuery]
		args: [{((SBDummyNode key: 9) left: ((SBDummyNode key: 10) left: (SBDummyNode key: 7))) showAsDomainBlock}]
		label: 'example'.
	currentNode := aNode.
	[
		(SBQuery
			pattern: (SBGroupPattern patterns: {
				SBBindingPattern
					expressionDict: {#identity -> [currentNode]}
					patternChildren: {SBBindingPattern writeBackClosure: [:var | newLeaf := var]}})
			strategy: (Dictionary new
				add: #explicitRootMatching -> false;
				add: #explicitChildrenMatching -> false;
				yourself)
			visualizePatternsAs: SBDummyNode) query] whileNotNil: [currentNode := newLeaf].
	^ currentNode
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
	pattern isPatternBlock ifFalse: [pattern := pattern evaluate].
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
SBQuery class >> pattern: anSBDomainBlockContainer strategy: aDict visualizePatternsAs: aClass [
	" marker "

	^ self new
		pattern: anSBDomainBlockContainer;
		strategy: aDict;
		defaultVisualizationClass: aClass;
		yourself
]

{ #category : #accessing }
SBQuery >> query [

	^ self query: self pattern findOriginRoot
]

{ #category : #accessing }
SBQuery >> query: anObject [

	| matcher match |
	matcher := (SBPatternMatcher input: anObject asDomainBlock pattern: self pattern) strategy: self strategy.
	match := matcher getNextMatch.
	^ match
]

{ #category : #printing }
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
