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

	| gerhard currentSnack |
	SBExample
		self: [SBVPQuery]
		args: [{SBVPDummyNode buildTree: {9 -> {10 -> {7}}}}]
		label: 'example'.
	currentSnack := salzstangen.
	[
		SBVPQuery
			input: (SBVPGroupPattern patterns: {
				SBVPBindingPattern bindingDict: {#innerLabel -> #a} connections: {
					SBVPBindingPattern
						writeBackClosure: [:var | gerhard := var]
						connections: {SBVPEllipsisPattern expressionDict: {#identity -> [currentSnack]}}}})
			strategy: {#explicitRootMatching -> true} asDictionary] whileNotNil: [
		Transcript showln: gerhard key.
		currentSnack := gerhard].
	^ gerhard
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
					connections: {SBVPBindingPattern bindingDict: {#identity -> #b}}})
			strategy: {#explicitRootMatching -> true} asDictionary] whileNotNil: [
		Transcript showln: gerhard key.
		currentSnack := gerhard].
	^ gerhard
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anSBVPVisualizer [
	" marker "

	^ (self new input: anSBVPVisualizer) query
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anSBVPVisualizer strategy: aDict [
	" marker "

	^ (self new
		input: anSBVPVisualizer;
		strategy: aDict) query
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [{#input:. #input:strategy:} anySatisfy: [:selector | self selector: selector receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> newFor: aBlock [

	| input |
	input := aBlock arguments first.
	input isVisualPrimitive ifFalse: [input := input evaluate].
	^ aBlock arguments size > 1
		ifTrue: [
			self new
				strategy: aBlock arguments second evaluate;
				input: input]
		ifFalse: [self new input: input]
]

{ #category : #'as yet unclassified' }
SBVPQuery >> defaultPatternVisualizationClass [

	^ SBVPDummyNode
]

{ #category : #'as yet unclassified' }
SBVPQuery >> initialize [

	super initialize.
	
	self
		strategy: Dictionary new;
		shrinkWrap;
		changeTableLayout;
		layoutInset: 6
]

{ #category : #accessing }
SBVPQuery >> input [

	^ input
]

{ #category : #accessing }
SBVPQuery >> input: anSBVPGroupPattern [

	input := anSBVPGroupPattern
]

{ #category : #accessing }
SBVPQuery >> noteNewOwner: aMorph [

	| row |
	self addMorphBack: (row := SBRow new
		cellInset: 3;
		cellPositioning: #center).
	
	row addMorphBack: self input
]

{ #category : #'as yet unclassified' }
SBVPQuery >> query [

	self halt.
	^ self query: self input findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPQuery >> query: anSBVPDummyNode [

	| matcher match |
	matcher := (SBVPPatternMatcher
		input: anSBVPDummyNode asVisualPrimitive
		pattern: self input) strategy: self strategy.
	match := matcher getNextMatch.
	^ match ifNil: [nil]
]

{ #category : #accessing }
SBVPQuery >> strategy [

	^ strategy
]

{ #category : #accessing }
SBVPQuery >> strategy: aDict [

	strategy := aDict
]

{ #category : #'as yet unclassified' }
SBVPQuery >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPQuery input: '.
	self input writeSourceOn: aStream.
	
	self strategy ifNotNil: [
		aStream nextPutAll: ' strategy: '.
		self strategy storeOn: aStream].
	
	aStream nextPut: $)
]
