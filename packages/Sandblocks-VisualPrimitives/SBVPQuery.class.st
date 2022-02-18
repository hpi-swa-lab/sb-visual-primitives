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
				SBVPBindingPattern constant: currentSnack connections: {
					SBVPBindingPattern
						writeBackClosure: [:var | gerhard := var]
						connections: {SBVPEllipsisPattern bindingIndex: #a}}})
			strategy: {#explicitRootMatching -> true} asDictionary] whileNotNil: [
		Transcript showln: gerhard key.
		currentSnack := gerhard].
	^ gerhard
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anInputVisualizer [
	" marker "

	^ (self new input: anInputVisualizer) query
]

{ #category : #'as yet unclassified' }
SBVPQuery class >> input: anInputVisualizer strategy: aDict [
	" marker "

	^ (self new
		input: anInputVisualizer;
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

	^ aBlock arguments size > 1
		ifTrue: [
			self new
				strategy: aBlock arguments second evaluate;
				input: aBlock arguments first]
		ifFalse: [self new input: aBlock arguments first]
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
SBVPQuery >> input: anSBBlock [

	self addMorph: anSBBlock.
	input := anSBBlock
]

{ #category : #'as yet unclassified' }
SBVPQuery >> query [

	^ self query: self input findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPQuery >> query: aDummyNode [

	| matcher match |
	matcher := (SBVPPatternMatcher
		input: aDummyNode asVisualPrimitive
		pattern: self input) strategy: self strategy.
	match := matcher getNextMatch.
	^ match ifNil: [nil]
]

{ #category : #accessing }
SBVPQuery >> strategy [

	^ strategy
]

{ #category : #accessing }
SBVPQuery >> strategy: anObject [

	strategy := anObject
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
