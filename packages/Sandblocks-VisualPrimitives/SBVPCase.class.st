Class {
	#name : #SBVPCase,
	#superclass : #SBStSubstitution,
	#instVars : [
		'input',
		'output',
		'strategy',
		'replaceAll',
		'informationRow'
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
SBVPCase class >> input: anInputVisualizer output: anOutputVisualizer strategy: aDict replaceAll: aBoolean [
	" marker "

	| case |
	case := self new
		input: anInputVisualizer output: anOutputVisualizer;
		strategy: aDict.
	
	^ aBoolean
		ifNotNil: [aBoolean ifTrue: [case replaceAllMatches] ifFalse: [case value]]
		ifNil: [case]
]

{ #category : #'as yet unclassified' }
SBVPCase class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [{#input:output:. #input:output:strategy:. #input:output:strategy:replaceAll:} anySatisfy: [:selector | self selector: selector receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPCase class >> newFor: aBlock [

	| input output |
	input := aBlock arguments first.
	input isVisualPrimitive ifFalse: [input := input evaluate].
	output := aBlock arguments second.
	output isVisualPrimitive ifFalse: [output := output evaluate].
	
	^ aBlock arguments size > 2
		ifTrue: [ | replaceAll |
			replaceAll := aBlock arguments size > 3 ifTrue: [aBlock arguments fourth evaluate].
			(self input: input output: output strategy: aBlock arguments third evaluate) replaceAll: replaceAll]
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
SBVPCase >> buildImplicitChildrenMatchingPattern [

	self input ifNotNil: #removeImplicitChildren.
	self output ifNotNil: #removeImplicitChildren.
	
	self explicitChildrenMatching ifFalse: [ | additionalNodes additionalNodes2 |
		additionalNodes := Dictionary new.
		additionalNodes2 := Dictionary new.
		self input buildImplicitChildren: additionalNodes.
		self flag: #TODO.
		"FIgure this out"
		self output buildImplicitChildren: additionalNodes2
		"self output addImplicitChildren: additionalNodes"]
]

{ #category : #'as yet unclassified' }
SBVPCase >> buildOutput: aPattern fromBinding: anArray [

	^ aPattern buildFromBinding: anArray
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

{ #category : #'as yet unclassified' }
SBVPCase >> example [

	SBVPCase
		input: (SBVPVisualizer
			code: [
				[ | root n1 n2 |
					root := SBVPDummyNode new.
					root key: 'Carl-Friedrich'.
					n1 := SBVPDummyNode new.
					n1 key: 'gadaitdd'.
					
					n2 := SBVPDummyNode new.
					n2 key: 'ghlplplph'.
					root
						left: n1;
						right: n2.
					root]]
			showCode: true)
		output: (SBVPVisualizer
			code: [
				[ | root n1 n2 |
					root := SBVPDummyNode new.
					root key: 'Carl-Friedrich'.
					n1 := SBVPDummyNode new.
					n1 key: 'n1'.
					n2 := SBVPDummyNode new.
					n2 key: 'n2'.
					root
						left: n1;
						right: n2.
					root]]
			showCode: true)
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			yourself)
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithBindingPattern [

	SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: 1 connections: {}.
			SBVPConstraintPattern constraint: [:b | b label = 20]})
		output: (SBVPVisualizer
			code: [ | root n1 n2 |
				root := SBVPDummyNode new.
				root key: 'Carl-Friedrich'.
				n1 := SBVPDummyNode new.
				n1 key: 'n1'.
				n2 := SBVPDummyNode new.
				n2 key: 'n2'.
				root
					left: n1;
					right: n2.
				root]
			showCode: true)
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithBindingPatterns [

	SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingIndex: 1
				connections: {SBVPBindingPattern bindingIndex: 2 connections: {}. SBVPBindingPattern bindingIndex: 3 connections: {}}.
			SBVPConstraintPattern constraint: [:b | b label = 20]})
		output: (SBVPVisualizer
			code: [ | root n1 n2 |
				root := SBVPDummyNode new.
				root key: 'Carl-Friedrich'.
				n1 := SBVPDummyNode new.
				n1 key: 'n1'.
				n2 := SBVPDummyNode new.
				n2 key: 'n2'.
				root
					left: n1;
					right: n2.
				root]
			showCode: true)
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
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
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
		addMorph: (SBColumn new
			cellPositioning: #center;
			addMorphBack: self informationRow;
			addMorphBack: (SBRow new
				cellInset: 3;
				cellPositioning: #center;
				addMorphBack: anSBBlock;
				addMorphBack: SBIcon iconArrowRight;
				addMorphBack: anotherSBBlock));
		input: anSBBlock;
		output: anotherSBBlock.
	
	self buildImplicitChildrenMatchingPattern
	";
		colorDifferences"
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
SBVPCase >> replace: aNumber matches: aDummyNode [

	| matcher currentPrimitive match iteration |
	currentPrimitive := aDummyNode asVisualPrimitive.
	matcher := (SBVPPatternMatcher input: currentPrimitive pattern: self input) strategy: self strategy.
	iteration := 0.
	[(match := matcher getNextMatch) notNil and: [(iteration := iteration + 1) < aNumber]] whileTrue: [
		currentPrimitive := matcher build: self output fromBinding: match.
		matcher input: currentPrimitive].
	^ aDummyNode class fromVisualPrimitive: currentPrimitive
]

{ #category : #accessing }
SBVPCase >> replaceAll [

	^ replaceAll
]

{ #category : #accessing }
SBVPCase >> replaceAll: anObject [

	replaceAll := anObject.
	anObject ifNotNil: [self color: (anObject ifTrue: [Color seaFoam] ifFalse: [Color spindrift])]
]

{ #category : #'as yet unclassified' }
SBVPCase >> replaceAllMatches [

	^ self replaceAllMatches: self input findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPCase >> replaceAllMatches: aDummyNode [

	| matcher currentPrimitive match |
	currentPrimitive := aDummyNode asVisualPrimitive.
	matcher := (SBVPPatternMatcher input: currentPrimitive pattern: self input) strategy: self strategy.
	[match := matcher getNextMatch] whileNotNil: [
		currentPrimitive := matcher build: self output fromBinding: match.
		matcher input: currentPrimitive].
	^ aDummyNode class fromVisualPrimitive: currentPrimitive
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
SBVPCase >> toggleStrategy: aSymbol [

	self strategy at: aSymbol put: (self strategy at: aSymbol) not.
	self addToggleButtonFor: aSymbol
]

{ #category : #'as yet unclassified' }
SBVPCase >> value [

	^ self value: self input findOriginRoot
]

{ #category : #'as yet unclassified' }
SBVPCase >> value: aDummyNode [

	| matcher match |
	matcher := (SBVPPatternMatcher
		input: aDummyNode asVisualPrimitive
		pattern: self input) strategy: self strategy.
	match := matcher getNextMatch.
	^ match
		ifNil: [aDummyNode]
		ifNotNil: [aDummyNode class fromVisualPrimitive: (matcher build: self output fromBinding: match)]
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
	
	self replaceAll ifNotNil: [
		aStream nextPutAll: ' replaceAll: '.
		self replaceAll storeOn: aStream].
	
	aStream nextPut: $)
]
