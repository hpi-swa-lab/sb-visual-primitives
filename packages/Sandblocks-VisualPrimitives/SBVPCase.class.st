Class {
	#name : #SBVPCase,
	#superclass : #SBStSubstitution,
	#instVars : [
		'input',
		'output',
		'strategy',
		'informationRow',
		'defaultPatternVisualizationClass'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPCase class >> buttonSpecifications [

	^ {
		self rootStrategy -> {
			#index -> 1.
			#icons -> {true -> SBIcon iconAnchor. false -> SBIcon iconTree} asDictionary.
			#text -> {true -> 'root matching'. false -> 'subtree matching'} asDictionary} asDictionary.
		
		self childrenStrategy -> {
			#index -> 2.
			#icons -> {true -> SBIcon iconChild. false -> SBIcon iconEyeSlash} asDictionary.
			#text -> {true -> 'explicit children'. false -> 'implicit children'} asDictionary} asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
SBVPCase class >> childrenStrategy [

	^ #explicitChildrenMatching
]

{ #category : #'as yet unclassified' }
SBVPCase class >> input: anInputVisualizer output: anOutputVisualizer [
	" marker "

	^ self new input: anInputVisualizer output: anOutputVisualizer
]

{ #category : #'as yet unclassified' }
SBVPCase class >> input: anInputVisualizer output: anOutputVisualizer strategy: aDict [
	" marker "

	^ self new
		input: anInputVisualizer output: anOutputVisualizer;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPCase class >> input: anInputVisualizer output: anOutputVisualizer strategy: aDict visualizePatternsAs: aClass [
	" marker "

	^ self new
		defaultPatternVisualizationClass: aClass;
		input: anInputVisualizer output: anOutputVisualizer;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPCase class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [{#input:output:. #input:output:strategy:. #input:output:strategy:visualizePatternsAs:} anySatisfy: [:selector | self selector: selector receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPCase class >> newFor: aBlock [

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
SBVPCase class >> rootStrategy [

	^ #explicitRootMatching
]

{ #category : #'as yet unclassified' }
SBVPCase class >> suggestion [

	^ [:block |
		block sandblockEditor do: (SBReplaceCommand new
			target: block;
			replacer: (self input: SBVPGroupPattern new output: SBVPGroupPattern new);
			yourself)]
]

{ #category : #'as yet unclassified' }
SBVPCase >> addSubPattern: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBVPCase >> addToggleButtonFor: aSymbol [

	| correctIcon correctText button isExplicit |
	isExplicit := self strategy at: aSymbol.
	correctIcon := ((self class buttonSpecifications at: aSymbol) at: #icons) at: isExplicit.
	correctText := ((self class buttonSpecifications at: aSymbol) at: #text) at: isExplicit.
	button := SBButton new icon: correctIcon label: correctText do: [
		self sandblockEditor do: (SBDoItCommand new
			artefactFrom: self containingArtefact;
			do: [self toggleStrategy: aSymbol])].
	
	(self strategyButtonFor: aSymbol)
		ifNil: [self informationRow addMorphBack: button]
		ifNotNil: [:existingButton | existingButton replaceBy: button]
]

{ #category : #'as yet unclassified' }
SBVPCase >> binding: aString for: block class: aClass ifPresent: aBlock [

	| bindingsSet |
	bindingsSet := Set new.
	self inputRoot collectBindingsInto: bindingsSet.
	bindingsSet
		detect: [:b | b notNil and: [b contents = aString]]
		ifFound: [:b | ^ aBlock value: b].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBVPCase >> buildImplicitChildrenMatchingPattern [

	(self input notNil and: [self output notNil]) ifTrue: [
		self input removeImplicitChildren.
		self output removeImplicitChildren.
		
		self explicitChildrenMatching ifFalse: [ | additionalNodes |
			additionalNodes := Dictionary new.
			self input
				buildImplicitChildren: additionalNodes;
				attachTreeDecorator.
			self output
				addImplicitChildren: additionalNodes;
				attachTreeDecorator].
		self input layout.
		self output layout]
]

{ #category : #'as yet unclassified' }
SBVPCase >> color [

	^ color
]

{ #category : #'as yet unclassified' }
SBVPCase >> colorDifferences [

	| inputRoot outputRoot inputBindingDict outputBindingDict colors |
	inputRoot := self input connections first.
	outputRoot := self output connections first.
	
	inputBindingDict := self findAllBindings: inputRoot.
	outputBindingDict := self findAllBindings: outputRoot.
	
	colors := Color wheel: inputBindingDict size saturation: 1.0 brightness: 1.0.
	
	inputBindingDict keysDo: [:bindingKey | | inputNode outputNode |
		inputNode := inputBindingDict at: bindingKey.
		outputNode := outputBindingDict at: bindingKey ifAbsent: [nil].
		outputNode isNil
			ifTrue: ["do something here"
			]
			ifFalse: [
				inputNode connections withIndexDo: [:connection :index | | outputConnection c |
					outputConnection := outputNode connections at: index ifAbsent: [nil].
					c := colors at: connection label.
					connection label = (outputConnection ifNotNil: #label) ifFalse: [
						connection color: c.
						(outputBindingDict at: connection label ifAbsent: [nil]) ifNotNil: [:o | o color: c]]]]]
]

{ #category : #accessing }
SBVPCase >> defaultPatternVisualizationClass [

	^ defaultPatternVisualizationClass
]

{ #category : #accessing }
SBVPCase >> defaultPatternVisualizationClass: anObject [

	defaultPatternVisualizationClass := anObject
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithEllipsisAndWildcardPattern [

	SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: 1 connections: {
				SBVPEllipsisPattern bindingIndex: 2 connections: {}.
				SBVPWildcardPattern bindingIndex: 3 connections: {}}.
			SBVPConstraintPattern constraint: [:b | b label = 20]})
		output: (SBVPBindingPattern bindingIndex: 1 connections: {
			SBVPEllipsisPattern bindingIndex: 2 connections: {}.
			SBVPWildcardPattern bindingIndex: 3 connections: {}})
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithPatterns [

	^ SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingIndex: 1
				connections: {SBVPBindingPattern bindingIndex: 2 connections: {}. SBVPBindingPattern bindingIndex: 3 connections: {}}.
			SBVPConstraintPattern constraint: [:c :b :a | true]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingIndex: 1
				connections: {SBVPBindingPattern bindingIndex: 3 connections: {}. SBVPBindingPattern bindingIndex: 2 connections: {}}})
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithPatterns: aDummyNode [

	^ (SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingIndex: 1
				connections: {SBVPBindingPattern bindingIndex: 2 connections: {}. SBVPBindingPattern bindingIndex: 3 connections: {}}.
			SBVPConstraintPattern constraint: [:a :b :c | true]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingIndex: 1
				connections: {SBVPBindingPattern bindingIndex: 3 connections: {}. SBVPBindingPattern bindingIndex: 2 connections: {}}})) value: aDummyNode
]

{ #category : #'as yet unclassified' }
SBVPCase >> explicitChildrenMatching [

	^ self strategy at: #explicitChildrenMatching ifAbsent: [true]
]

{ #category : #'as yet unclassified' }
SBVPCase >> explicitRootMatching [

	^ self strategy at: #explicitRootMatching ifAbsent: [true]
]

{ #category : #'as yet unclassified' }
SBVPCase >> findAllBindings: aRootPattern [

	| bindingDict dfs |
	dfs := LinkedList new.
	bindingDict := Dictionary new.
	
	dfs add: aRootPattern.
	[dfs notEmpty] whileTrue: [ | currentTop |
		currentTop := dfs first.
		dfs removeFirst.
		bindingDict add: currentTop label -> currentTop.
		dfs addAll: currentTop connections].
	
	^ bindingDict
]

{ #category : #accessing }
SBVPCase >> informationRow [

	^ informationRow
]

{ #category : #accessing }
SBVPCase >> informationRow: aBlock [

	informationRow := aBlock
]

{ #category : #'as yet unclassified' }
SBVPCase >> initialize [

	super initialize.
	informationRow := SBRow new cellInset: 3.
	self
		shrinkWrap;
		changeTableLayout;
		cellInset: 3;
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
]

{ #category : #accessing }
SBVPCase >> input [

	^ input
]

{ #category : #accessing }
SBVPCase >> input: anObject [

	input := anObject.
	"maybe buildImplicitChildren here"
	self flag: #TODO
]

{ #category : #'as yet unclassified' }
SBVPCase >> input: anSBBlock output: anotherSBBlock [

	self
		input: anSBBlock;
		output: anotherSBBlock.
	
	self buildImplicitChildrenMatchingPattern
	";
		colorDifferences"
]

{ #category : #'as yet unclassified' }
SBVPCase >> inputRoot [

	^ self input connections first
]

{ #category : #'as yet unclassified' }
SBVPCase >> noteNewOwner: aMorph [

	| row |
	super noteNewOwner: aMorph.
	self addMorph: (SBColumn new
		cellPositioning: #center;
		addMorphBack: self informationRow;
		addMorphBack: (row := SBRow new
			cellInset: 3;
			cellPositioning: #center)).
	
	row
		addMorphBack: self input;
		addMorphBack: SBIcon iconArrowRight;
		addMorphBack: self output
]
SBVPCase >> isValidBinding: aString [

	^ (self findAllBindings: self inputRoot) keys includes: aString
]

{ #category : #accessing }
SBVPCase >> output [

	^ output
]

{ #category : #accessing }
SBVPCase >> output: anObject [

	output := anObject.
	"maybe buildImplicitChildren here"
	self flag: #TODO
]

{ #category : #'as yet unclassified' }
SBVPCase >> replace: aNumber matches: anObject [

	| matcher currentPrimitive match iteration |
	currentPrimitive := anObject asVisualPrimitive.
	matcher := (SBVPPatternMatcher input: currentPrimitive pattern: self input) strategy: self strategy.
	iteration := 0.
	[(match := matcher getNextMatch) notNil and: [(iteration := iteration + 1) < aNumber]] whileTrue: [
		currentPrimitive := matcher build: self output fromBinding: match.
		matcher input: currentPrimitive].
	^ currentPrimitive getObjectFromVisualPrimitive
]

{ #category : #'as yet unclassified' }
SBVPCase >> replaceAllMatches [

	^ self replaceAllMatches: self input findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPCase >> replaceAllMatches: anObject [

	| matcher currentPrimitive match |
	currentPrimitive := anObject asVisualPrimitive.
	matcher := (SBVPPatternMatcher input: currentPrimitive pattern: self input) strategy: self strategy.
	[match := matcher getNextMatch] whileNotNil: [
		currentPrimitive := matcher build: self output fromBinding: match.
		matcher input: currentPrimitive].
	^ currentPrimitive getObjectFromVisualPrimitive
]

{ #category : #accessing }
SBVPCase >> strategy [

	^ strategy
]

{ #category : #accessing }
SBVPCase >> strategy: aDict [

	strategy ifNotNil: [strategy addAll: aDict] ifNil: [strategy := aDict].
	self class buttonSpecifications keysDo: [:strategySymbol | self addToggleButtonFor: strategySymbol].
	self buildImplicitChildrenMatchingPattern
]

{ #category : #accessing }
SBVPCase >> strategyButtonFor: aSymbol [

	| index |
	index := (self class buttonSpecifications at: aSymbol) at: #index.
	^ self informationRow submorphs at: index ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
SBVPCase >> toggleImplicitChildTo: aBoolean withBinding: aString [

	self toggleImplicitChildTo: aBoolean withBinding: aString on: self input.
	self toggleImplicitChildTo: aBoolean withBinding: aString on: self output
]

{ #category : #'as yet unclassified' }
SBVPCase >> toggleImplicitChildTo: aBoolean withBinding: aString on: aSBVPPattern [

	aSBVPPattern allConnectionsDo: [:pattern |
		pattern bindingIndex = aString ifTrue: [
			pattern isImplicitChild: aBoolean.
			^ self]]
]

{ #category : #'as yet unclassified' }
SBVPCase >> toggleStrategy: aSymbol [

	self strategy at: aSymbol put: (self strategy at: aSymbol) not.
	aSymbol = self class childrenStrategy ifTrue: [self buildImplicitChildrenMatchingPattern].
	self addToggleButtonFor: aSymbol
]

{ #category : #'as yet unclassified' }
SBVPCase >> value [

	^ self value: self input findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPCase >> value: anObject [

	| matcher match |
	matcher := (SBVPPatternMatcher input: anObject asVisualPrimitive pattern: self input) strategy: self strategy.
	match := matcher getNextMatch.
	^ match
		ifNil: [anObject]
		ifNotNil: [(matcher build: self output fromBinding: match) getObjectFromVisualPrimitive]
]

{ #category : #'as yet unclassified' }
SBVPCase >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPCase input: '.
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
