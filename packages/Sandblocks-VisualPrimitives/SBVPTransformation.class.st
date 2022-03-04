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
			self pattern
				buildImplicitChildren: additionalNodes;
				attachTreeDecorator.
			self outputPattern
				addImplicitChildren: additionalNodes;
				attachTreeDecorator].
		self pattern layout.
		self outputPattern layout]
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

{ #category : #'as yet unclassified' }
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
