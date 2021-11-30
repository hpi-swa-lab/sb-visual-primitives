Class {
	#name : #SBVPCase,
	#superclass : #SBStSubstitution,
	#instVars : [
		'input',
		'output'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPCase class >> input: anInputVisualizer output: anOutputVisualizer [
	" marker "

	^ self new input: anInputVisualizer output: anOutputVisualizer
]

{ #category : #'as yet unclassified' }
SBVPCase class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [aBlock selector = 'input:output:']
]

{ #category : #'as yet unclassified' }
SBVPCase class >> newFor: aBlock [

	^ self new input: aBlock arguments first output: aBlock arguments second
]

{ #category : #'as yet unclassified' }
SBVPCase >> addSubPattern: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBVPCase >> buildOutput: aPattern fromBinding: anArray [

	^ aPattern buildFromBinding: anArray
]

{ #category : #'as yet unclassified' }
SBVPCase >> colorDifferences [

	| inputRoot outputRoot inputBindingDict outputBindingDict colors |
	inputRoot := self input patterns first.
	outputRoot := self output patterns first.
	
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
			code: [ | root n1 n2 |
				root := SBVPDummyNode new.
				root key: 'Carl-Friedrich'.
				n1 := SBVPDummyNode new.
				n1 key: 'gadaitdd'.
				
				n2 := SBVPDummyNode new.
				n2 key: 'ghlplplph'.
				root
					left: n1;
					right: n2.
				root]
			extent: 300 @ 300)
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
			extent: 300 @ 300)
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithBindingPattern [

	SBVPCase
		input: (SBVPGroupPattern patterns: {SBVPBindingPattern label: 1 connections: {}. SBVPConstraintPattern constraint: [:b | b label = 20]})
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
			extent: 300 @ 300)
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithBindingPatterns [

	SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				label: 1
				connections: {SBVPBindingPattern label: 2 connections: {}. SBVPBindingPattern label: 3 connections: {}}.
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
			extent: 300 @ 300)
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithEllipsisAndWildcardPattern [

	SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				label: 1
				connections: {SBVPEllipsisPattern label: 2 connections: {}. SBVPWildcardPattern label: 3 connections: {}}.
			SBVPConstraintPattern constraint: [:b | b label = 20]})
		output: (SBVPBindingPattern
			label: 1
			connections: {SBVPEllipsisPattern label: 2 connections: {}. SBVPWildcardPattern label: 3 connections: {}})
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithPatterns [

	^ SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				label: 1
				connections: {SBVPBindingPattern label: 2 connections: {}. SBVPBindingPattern label: 3 connections: {}}.
			SBVPConstraintPattern constraint: [:c :b :a | true]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				label: 1
				connections: {SBVPBindingPattern label: 3 connections: {}. SBVPBindingPattern label: 2 connections: {}}})
]

{ #category : #'as yet unclassified' }
SBVPCase >> exampleWithPatterns: aDummyNode [

	^ (SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				label: 1
				connections: {SBVPBindingPattern label: 2 connections: {}. SBVPBindingPattern label: 3 connections: {}}.
			SBVPConstraintPattern constraint: [:a :b :c | true]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				label: 1
				connections: {SBVPBindingPattern label: 3 connections: {}. SBVPBindingPattern label: 2 connections: {}}})) value: aDummyNode
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

{ #category : #'as yet unclassified' }
SBVPCase >> initialize [

	super initialize.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6
]

{ #category : #accessing }
SBVPCase >> input [

	^ input
]

{ #category : #accessing }
SBVPCase >> input: anObject [

	input := anObject
]

{ #category : #'as yet unclassified' }
SBVPCase >> input: aSBBlock output: anotherSBBlock [

	self
		addMorph: (SBRow new
			addMorphBack: aSBBlock;
			addMorphBack: SBIcon iconArrowRight;
			addMorphBack: anotherSBBlock);
		input: aSBBlock;
		output: anotherSBBlock;
		colorDifferences
]

{ #category : #accessing }
SBVPCase >> output [

	^ output
]

{ #category : #accessing }
SBVPCase >> output: anObject [

	output := anObject
]

{ #category : #'as yet unclassified' }
SBVPCase >> replaceAllMatches: aDummyNode [

	^ self replaceAllMatches: aDummyNode strategy: #exact
]

{ #category : #'as yet unclassified' }
SBVPCase >> replaceAllMatches: aDummyNode strategy: aSymbol [

	| matcher currentPrimitive match |
	currentPrimitive := aDummyNode asVisualPrimitive.
	matcher := (SBVPPatternMatcher input: currentPrimitive pattern: self input) strategy: aSymbol.
	[match := matcher getNextMatch] whileNotNil: [
		currentPrimitive := matcher build: self output fromBinding: match.
		matcher input: currentPrimitive].
	^ aDummyNode class fromVisualPrimitive: currentPrimitive
]

{ #category : #'as yet unclassified' }
SBVPCase >> value: aDummyNode [

	^ self value: aDummyNode strategy: #exact
]

{ #category : #'as yet unclassified' }
SBVPCase >> value: aDummyNode strategy: aSymbol [

	| matcher match |
	matcher := (SBVPPatternMatcher
		input: aDummyNode asVisualPrimitive
		pattern: self input) strategy: aSymbol.
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
	aStream nextPut: $).
	self reloadArtefact
]
