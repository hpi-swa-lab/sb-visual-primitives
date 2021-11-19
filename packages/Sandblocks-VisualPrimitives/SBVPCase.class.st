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

	SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPConstraintPattern constraint: [:a | a label = 10].
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
SBVPCase >> input: aSBStMessageSend output: anotherSBStMessageSend [

	self
		addMorph: (SBRow new
			addMorphBack: aSBStMessageSend;
			addMorphBack: SBIcon iconArrowRight;
			addMorphBack: anotherSBStMessageSend);
		input: aSBStMessageSend;
		output: anotherSBStMessageSend
	"
	aSBStMessageSend do: [:m | self addSubPattern: m arg]"
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

	| matcher currentPrimitive match |
	currentPrimitive := aDummyNode asVisualPrimitive.
	matcher := SBVPPatternMatcher input: currentPrimitive pattern: self input.
	[match := matcher getNextMatch] whileNotNil: [
		currentPrimitive := (self output buildFromBinding: match) first.
		matcher input: currentPrimitive].
	^ aDummyNode class fromVisualPrimitive: currentPrimitive
]

{ #category : #'as yet unclassified' }
SBVPCase >> value: aDummyNode [

	| matcher match |
	matcher := SBVPPatternMatcher input: aDummyNode asVisualPrimitive pattern: self input.
	match := matcher getNextMatch.
	^ match
		ifNil: [aDummyNode]
		ifNotNil: [aDummyNode class fromVisualPrimitive: (self output buildFromBinding: match) first]
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
