Class {
	#name : #SBVPExecuter,
	#superclass : #SBBlock,
	#instVars : [
		'input',
		'case',
		'output',
		'inputBlock',
		'caseBlock',
		'outputBlock',
		'strategy'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleHeapItThenKeepIt [

	^ SBVPExecuter new
		case: (SBVPCase
			input: SBVPPatternMatcherTest new examplePatternChildSmallerThanParent
			output: SBVPPatternMatcherTest new examplePatternChildSmallerThanParentOutput);
		input: (SBVPVisualizer
			code: [SBVPDummyNode fromVisualPrimitive: (SBVPPatternMatcherTest new buildTree: {42 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) first]
			extent: 300 @ 300);
		strategy: #subTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleSort [

	^ SBVPExecuter new
		case: (SBVPCase
			input: SBVPPatternMatcherTest new examplePatternSortTree
			output: SBVPPatternMatcherTest new examplePatternSortTreeOutput);
		input: (SBVPVisualizer
			code: [SBVPDummyNode fromVisualPrimitive: (SBVPPatternMatcherTest new buildTree: {42 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) first]
			extent: 300 @ 300)
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
SBVPExecuter >> exampleBuildHeap [

	^ SBVPExecuter new
		case: (SBVPCase
			input: (SBVPGroupPattern patterns: {
				SBVPBindingPattern label: 1 connections: {
					SBVPEllipsisPattern label: 2.
					SBVPBindingPattern label: 3 connections: {SBVPEllipsisPattern label: 5}.
					SBVPEllipsisPattern label: 4}.
				SBVPConstraintPattern constraint: [:a :b :c :d :e | c label asInteger < a label asInteger]})
			output: (SBVPGroupPattern patterns: {
				SBVPBindingPattern label: 3 connections: {
					SBVPEllipsisPattern label: 2.
					SBVPBindingPattern label: 1 connections: {SBVPEllipsisPattern label: 5}.
					SBVPEllipsisPattern label: 4}}));
		input: (SBVPVisualizer
			code: [SBVPDummyNode fromVisualPrimitive: (SBVPPatternMatcherTest new buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) first]
			extent: 300 @ 300);
		strategy: #subTree
]

{ #category : #accessing }
SBVPExecuter >> exampleNumberOne [

	^ SBVPExecuter new
		case: (SBVPCase
			input: SBVPPatternMatcherTest new examplePatternSortTree
			output: SBVPPatternMatcherTest new examplePatternSortTreeOutput);
		input: (SBVPVisualizer
			code: [SBVPDummyNode fromVisualPrimitive: (SBVPPatternMatcherTest new buildTree: {42 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) first]
			extent: 300 @ 300)
]

{ #category : #accessing }
SBVPExecuter >> execute [
	<action>

	self outputBlock removeAllMorphs.
	(self case value: self input code firstSubmorph evaluate value strategy: self strategy) asVisualPrimitiveIn: self outputBlock
]

{ #category : #accessing }
SBVPExecuter >> executeAll [
	<action>

	self outputBlock removeAllMorphs.
	(self case
		replaceAllMatches: self input code firstSubmorph evaluate value
		strategy: self strategy) asVisualPrimitiveIn: self outputBlock
]

{ #category : #accessing }
SBVPExecuter >> initialize [

	super initialize.
	
	self
		strategy: #exact;
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
SBVPExecuter >> isArtefact [

	^ true
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

	^ strategy
]

{ #category : #accessing }
SBVPExecuter >> strategy: anObject [

	strategy := anObject
]
