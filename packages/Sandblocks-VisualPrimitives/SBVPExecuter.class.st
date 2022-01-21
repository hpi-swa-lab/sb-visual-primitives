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
SBVPExecuter class >> case: aVPCase input: aVisualizer [
	"marker"

	^ self new
		case: aVPCase;
		input: aVisualizer
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeap [

	^ SBVPExecuter
		case: (SBVPCase
			input: (SBVPGroupPattern patterns: {
				SBVPBindingPattern bindingIndex: #a connections: {
					SBVPEllipsisPattern bindingIndex: #b.
					SBVPBindingPattern
						bindingIndex: #boi
						connections: {SBVPEllipsisPattern bindingIndex: #e}.
					SBVPEllipsisPattern bindingIndex: #d}.
				SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger < (bindings at: #boi) label asInteger]})
			output: (SBVPGroupPattern patterns: {
				SBVPBindingPattern bindingIndex: #boi connections: {
					SBVPEllipsisPattern bindingIndex: #b.
					SBVPBindingPattern
						bindingIndex: #a
						connections: {SBVPEllipsisPattern bindingIndex: #e}.
					SBVPEllipsisPattern bindingIndex: #d}})
			strategy: (Dictionary new
				add: #explicitRootMatching -> false;
				add: #explicitChildrenMatching -> true;
				yourself))
		input: (SBVPVisualizer
			code: [SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}]
			showCode: true)
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeap: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #a connections: {
				SBVPEllipsisPattern bindingIndex: #b.
				SBVPBindingPattern
					bindingIndex: #boi
					connections: {SBVPEllipsisPattern bindingIndex: #e}.
				SBVPEllipsisPattern bindingIndex: #d}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger < (bindings at: #boi) label asInteger]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #boi connections: {
				SBVPEllipsisPattern bindingIndex: #b.
				SBVPBindingPattern
					bindingIndex: #a
					connections: {SBVPEllipsisPattern bindingIndex: #e}.
				SBVPEllipsisPattern bindingIndex: #d}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapBrokenBindings: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #g connections: {
				SBVPEllipsisPattern bindingIndex: #b.
				SBVPBindingPattern
					bindingIndex: #boi
					connections: {SBVPEllipsisPattern bindingIndex: #e}.
				SBVPEllipsisPattern bindingIndex: #d}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger < (bindings at: #boi) label asInteger]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #boi connections: {
				SBVPEllipsisPattern bindingIndex: #dude.
				SBVPBindingPattern
					bindingIndex: #a
					connections: {SBVPEllipsisPattern bindingIndex: #e}.
				SBVPEllipsisPattern bindingIndex: #d}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapStrings: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPStringDummyNode buildTree: {
					'b' -> {
						'asda' -> {
							'asd' -> {'ös' -> {'rt4'. 'bbbbbb'}. 'ghui' -> {'dödö'}}.
							'alk' -> {'rüdiger' -> {'britta'. 'wante'}. 'onkqel' -> {'baum'}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #a connections: {
				SBVPEllipsisPattern bindingIndex: #b.
				SBVPBindingPattern
					bindingIndex: #boi
					connections: {SBVPEllipsisPattern bindingIndex: #e}.
				SBVPEllipsisPattern bindingIndex: #d}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label < (bindings at: #boi) label]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #boi connections: {
				SBVPEllipsisPattern bindingIndex: #b.
				SBVPBindingPattern
					bindingIndex: #a
					connections: {SBVPEllipsisPattern bindingIndex: #e}.
				SBVPEllipsisPattern bindingIndex: #d}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapTest: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #a labelDict: {} connections: {
				SBVPEllipsisPattern bindingIndex: #'i_a' labelDict: {}.
				SBVPBindingPattern
					bindingIndex: #boi
					labelDict: {}
					connections: {SBVPEllipsisPattern bindingIndex: #'i_c' labelDict: {}}.
				SBVPEllipsisPattern bindingIndex: #'i_b' labelDict: {}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label < (bindings at: #boi) label and: [(bindings at: #'i_c') size < 2]]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #boi labelDict: {} connections: {
				SBVPEllipsisPattern bindingIndex: #'i_c' labelDict: {}.
				SBVPBindingPattern bindingIndex: #a labelDict: {} connections: {
					SBVPEllipsisPattern bindingIndex: #'i_a' labelDict: {}.
					SBVPEllipsisPattern bindingIndex: #'i_b' labelDict: {}}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapWithImplicitChildren [

	^ SBVPExecuter
		case: (SBVPCase
			input: (SBVPGroupPattern patterns: {
				SBVPBindingPattern
					bindingIndex: #a
					connections: {SBVPBindingPattern bindingIndex: #b connections: {}}.
				SBVPConstraintPattern constraint: [:bindings | (bindings at: #b) label asInteger < (bindings at: #a) label asInteger]})
			output: (SBVPGroupPattern patterns: {
				SBVPBindingPattern
					bindingIndex: #b
					connections: {SBVPBindingPattern bindingIndex: #a connections: {}}})
			strategy: {#explicitRootMatching -> false. #explicitChildrenMatching -> false} asDictionary)
		input: (SBVPVisualizer
			code: [SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}]
			showCode: true)
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleGrammarRuleMergeRepeat: aGrammarObject [

	| bio |
	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPTomGrammarObject new
					type: 'SEQ';
					members: {
						SBVPTomGrammarObject new
							type: 'SYMBOL';
							objectName: 'aahh'.
						SBVPTomGrammarObject new
							type: 'REPEAT';
							content: (SBVPTomGrammarObject new
								type: 'SYMBOL';
								objectName: 'aahh')}) showAsVisualPrimitive}]
		label: 'example'.
	bio := SBVPTomGrammarObject new.
	bio type: 'REPEAT1'.
	^ (SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #a labelDict: {#topLeftLabel -> 'SEQ'} connections: {
				SBVPBindingPattern bindingIndex: #b labelDict: {#topLeftLabel -> 'SYMBOL'}.
				SBVPBindingPattern
					bindingIndex: #c
					labelDict: {#topLeftLabel -> 'REPEAT'}
					connections: {SBVPBindingPattern bindingIndex: #d labelDict: {#topLeftLabel -> 'SYMBOL'}}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #b) origin objectName = (bindings at: #d) origin objectName]})
		output: (SBVPGroupPattern patterns: {SBVPBindingPattern constant: bio connections: {SBVPBindingPattern bindingIndex: #b}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)) replaceAllMatches: aGrammarObject
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleGrammarRuleWeird: aGrammarObject [

	| bio |
	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPTomGrammarObject new
					type: 'SEQ';
					members: {
						SBVPTomGrammarObject new
							type: 'SYMBOL';
							objectName: 'aahh'.
						SBVPTomGrammarObject new
							type: 'REPEAT';
							content: (SBVPTomGrammarObject new
								type: 'SYMBOL';
								objectName: 'aahh')}) showAsVisualPrimitive}]
		label: 'example'.
	bio := SBVPTomGrammarObject new.
	bio type: 'REPEAT1'.
	^ (SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #a labelDict: {#topLeftLabel -> 'SEQ'} connections: {
				SBVPBindingPattern bindingIndex: #b labelBindingDict: (Dictionary new
					add: #topLeftLabel -> #type;
					yourself).
				SBVPBindingPattern
					bindingIndex: #c
					labelDict: {#topLeftLabel -> 'REPEAT'}
					connections: {SBVPBindingPattern bindingIndex: #d labelDict: {#topLeftLabel -> 'SYMBOL'}}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #b) origin objectName = (bindings at: #d) origin objectName]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingIndex: #c
				labelBindingDict: (Dictionary new
					add: #topLeftLabel -> #type;
					yourself)
				connections: {SBVPBindingPattern bindingIndex: #b}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)) replaceAllMatches: aGrammarObject
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleOrPattern [

	^ SBVPExecuter
		case: (SBVPCase
			input: (SBVPOrGroupPattern patterns: {
				SBVPBindingPattern bindingIndex: #a connections: {
					SBVPBindingPattern
						bindingIndex: #b
						connections: {SBVPEllipsisPattern bindingIndex: #c}}.
				SBVPGroupPattern patterns: {
					SBVPBindingPattern
						bindingIndex: #a
						connections: {SBVPEllipsisPattern bindingIndex: #c}.
					SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) label asInteger = 3]}})
			output: (SBVPGroupPattern patterns: {
				SBVPBindingPattern
					bindingIndex: #a
					labelDict: {#innerLabel -> 42}
					connections: {SBVPEllipsisPattern bindingIndex: #c}})
			strategy: (Dictionary new
				add: #explicitRootMatching -> false;
				add: #explicitChildrenMatching -> true;
				yourself))
		input: (SBVPVisualizer
			code: [SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}]
			showCode: true)
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleWithConstants [

	| salzstangen |
	SBVPVisualizer code: [SBVPDummyNode buildTree: {9 -> {10 -> {8}}}] showCode: false.
	SBVPVisualizer
		code: [
			salzstangen := SBVPDummyNode buildTree: {9 -> {10 -> {8}}}.
			(SBVPCase
				input: (SBVPGroupPattern patterns: {
					SBVPBindingPattern constant: salzstangen connections: {
						SBVPBindingPattern
							bindingIndex: #a
							connections: {SBVPEllipsisPattern bindingIndex: #b}}})
				output: (SBVPGroupPattern patterns: {
					SBVPBindingPattern bindingIndex: #a connections: {
						SBVPBindingPattern
							constant: salzstangen
							connections: {SBVPEllipsisPattern bindingIndex: #b}}})
				strategy: {#explicitRootMatching -> false} asDictionary) replaceAllMatches]
		showCode: true
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleWithConstants: salzstangen [

	| case |
	case := SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern constant: salzstangen connections: {
				SBVPBindingPattern
					bindingIndex: #a
					connections: {SBVPEllipsisPattern bindingIndex: #b}}})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingIndex: #a connections: {
				SBVPBindingPattern
					constant: salzstangen
					connections: {SBVPEllipsisPattern bindingIndex: #b}}})
		strategy: {#explicitRootMatching -> false. #explicitChildrenMatching -> true} asDictionary.
	^ case replaceAllMatches: salzstangen
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [aBlock selector = 'case:input:']
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> newFor: aBlock [

	^ self case: aBlock arguments first input: aBlock arguments second
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

	self showOutput: (self case value: self input code firstSubmorph evaluate value)
]

{ #category : #accessing }
SBVPExecuter >> execute100Times [
	<action>

	self showOutput: (self case replace: 100 matches: self input code firstSubmorph evaluate value)
]

{ #category : #accessing }
SBVPExecuter >> executeAll [
	<action>

	self showOutput: (self case replaceAllMatches: self input code firstSubmorph evaluate value)
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
			cellInset: 3;
			addMorphBack: (SBButton new label: 'execute once' shortcut: nil do: [self execute]);
			addMorphBack: (SBButton new label: 'execute 100 times' shortcut: nil do: [self execute100Times]);
			addMorphBack: (SBButton new label: 'execute all' shortcut: nil do: [self executeAll]));
		addMorphBack: (SBRow new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			cellInset: 3;
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				cellInset: 3;
				addMorphBack: (SBTextBubble new contents: 'Input');
				addMorphBack: (inputBlock := SBRow new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap));
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				cellInset: 3;
				addMorphBack: (SBTextBubble new contents: 'Transformation');
				addMorphBack: (caseBlock := SBRow new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap));
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				cellInset: 3;
				addMorphBack: (SBTextBubble new contents: 'Output');
				addMorphBack: (outputBlock := SBBlock new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					cellInset: 3)))
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
SBVPExecuter >> showOutput: anObject [

	| vp |
	self outputBlock removeAllMorphs.
	vp := SBVisualPrimitive newFromObject: anObject in: self outputBlock.
	vp attachTreeDecorator.
	vp layout
]

{ #category : #'as yet unclassified' }
SBVPExecuter >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVPExecuter case: '.
	self case writeSourceOn: aStream.
	aStream nextPutAll: ' input: '.
	self input writeSourceOn: aStream.
	aStream nextPut: $)
]
