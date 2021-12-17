Class {
	#name : #SBVPExecuter,
	#superclass : #SBStSubstitution,
	#instVars : [
		'input',
		'case',
		'output',
		'inputBlock',
		'caseBlock',
		'outputBlock'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPExecuter class >> case: aVPCase input: aVisualizer strategy: aDict [
	"marker"

	^ self new
		case: aVPCase;
		input: aVisualizer;
		strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeap [

	^ SBVPExecuter
		case: (SBVPCase
			input: (SBVPGroupPattern patterns: {
				SBVPBindingPattern bindingIndex: 1 connections: {
					SBVPEllipsisPattern bindingIndex: 2.
					SBVPBindingPattern bindingIndex: 3 connections: {SBVPEllipsisPattern bindingIndex: 5}.
					SBVPEllipsisPattern bindingIndex: 4}.
				SBVPConstraintPattern constraint: [:a :b :c :d :e | c label asInteger < a label asInteger]})
			output: (SBVPGroupPattern patterns: {
				SBVPBindingPattern bindingIndex: 3 connections: {
					SBVPEllipsisPattern bindingIndex: 2.
					SBVPBindingPattern bindingIndex: 1 connections: {SBVPEllipsisPattern bindingIndex: 5}.
					SBVPEllipsisPattern bindingIndex: 4}}))
		input: (SBVPVisualizer
			code: [SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}]
			showCode: true)
		strategy: {#explicitRootMatching -> false} asDictionary
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleWithConstants [

	| salzstangen |
	SBVPVisualizer code: [SBVPDummyNode buildTree: {9 -> {10 -> {8}}}] showCode: false.
	SBVPVisualizer
		code: [
			salzstangen := SBVPDummyNode buildTree: {9 -> {10 -> {8}}}.
			SBVPCase
				input: (SBVPGroupPattern patterns: {
					SBVPBindingPattern
						constant: salzstangen
						connections: {SBVPBindingPattern bindingIndex: 1 connections: {SBVPEllipsisPattern bindingIndex: 2}}})
				output: (SBVPGroupPattern patterns: {
					SBVPBindingPattern bindingIndex: 1 connections: {
						SBVPBindingPattern
							constant: salzstangen
							connections: {SBVPEllipsisPattern bindingIndex: 2}}})
				strategy: {#explicitRootMatching -> false} asDictionary
				replaceAll: true]
		showCode: true
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleWithConstants: salzstangen [

	| case |
	case := SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				constant: salzstangen
				connections: {SBVPBindingPattern bindingIndex: 1 connections: {SBVPEllipsisPattern bindingIndex: 2}}})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: 1 connections: {
				SBVPBindingPattern
					constant: salzstangen
					connections: {SBVPEllipsisPattern bindingIndex: 2}}})
		strategy: {#explicitRootMatching -> false} asDictionary.
	^ case replaceAllMatches: salzstangen
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [aBlock selector = 'case:input:strategy:']
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> newFor: aBlock [

	^ self
		case: aBlock arguments first
		input: aBlock arguments second
		strategy: aBlock arguments third evaluate
]

{ #category : #accessing }
SBVPExecuter >> case [

	^ case
]

{ #category : #accessing }
SBVPExecuter >> case: aMorph [

	case := aMorph.
	self caseBlock removeAllMorphs.
	self caseBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVPExecuter >> caseBlock [

	^ caseBlock
]

{ #category : #accessing }
SBVPExecuter >> caseBlock: anObject [

	^ caseBlock := anObject
]

{ #category : #'as yet unclassified' }
SBVPExecuter >> evaluationContext [

	^ nil
]

{ #category : #'as yet unclassified' }
SBVPExecuter >> evaluationReceiver [

	^ self
]

{ #category : #accessing }
SBVPExecuter >> execute [
	<action>

	self outputBlock removeAllMorphs.
	(self case value: self input code firstSubmorph evaluate value) asVisualPrimitiveIn: self outputBlock
]

{ #category : #accessing }
SBVPExecuter >> executeAll [
	<action>

	self outputBlock removeAllMorphs.
	(self case replaceAllMatches: self input code firstSubmorph evaluate value) asVisualPrimitiveIn: self outputBlock
]

{ #category : #accessing }
SBVPExecuter >> initialize [

	super initialize.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6;
		addMorphBack: (SBTextBubble new contents: 'Executer');
		addMorphBack: (SBRow new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				layoutInset: 6;
				addMorphBack: (SBTextBubble new contents: 'Input');
				addMorphBack: (inputBlock := SBSandboxPasteUpMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					borderColor: Color black;
					when: #reportError send: #reportError: to: self));
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				addMorphBack: (SBTextBubble new contents: 'Transformation');
				addMorphBack: (caseBlock := SBSandboxPasteUpMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					borderColor: Color black;
					when: #reportError send: #reportError: to: self));
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				layoutInset: 6;
				addMorphBack: (SBTextBubble new contents: 'Output');
				addMorphBack: (outputBlock := SBSandboxPasteUpMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					borderColor: Color black;
					layoutInset: 6;
					when: #reportError send: #reportError: to: self)))
]

{ #category : #accessing }
SBVPExecuter >> input [

	^ input
]

{ #category : #accessing }
SBVPExecuter >> input: aMorph [

	input := aMorph.
	self inputBlock removeAllMorphs.
	self inputBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVPExecuter >> inputBlock [

	^ inputBlock
]

{ #category : #accessing }
SBVPExecuter >> inputBlock: anObject [

	^ inputBlock := anObject
]

{ #category : #accessing }
SBVPExecuter >> output [

	^ output
]

{ #category : #accessing }
SBVPExecuter >> output: aMorph [

	output := aMorph.
	self outputBlock removeAllMorphs.
	self outputBlock addMorphBack: aMorph
]

{ #category : #accessing }
SBVPExecuter >> outputBlock [

	^ outputBlock
]

{ #category : #accessing }
SBVPExecuter >> outputBlock: anObject [

	^ outputBlock := anObject
]

{ #category : #accessing }
SBVPExecuter >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	
]

{ #category : #accessing }
SBVPExecuter >> strategy [

	^ self case strategy
]

{ #category : #accessing }
SBVPExecuter >> strategy: aDict [

	self case strategy: aDict
]

{ #category : #'as yet unclassified' }
SBVPExecuter >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPExecuter case: '.
	self case writeSourceOn: aStream.
	aStream nextPutAll: ' input: '.
	self input writeSourceOn: aStream.
	aStream nextPutAll: ' strategy: '.
	self strategy storeOn: aStream.
	aStream nextPut: $)
]
