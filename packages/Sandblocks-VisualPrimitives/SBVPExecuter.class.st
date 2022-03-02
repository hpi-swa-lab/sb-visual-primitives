"
An SBVPExecuter is used to wrap a single SBVPCase with input to easily execute the case on the input.
"
Class {
	#name : #SBVPExecuter,
	#superclass : #SBStSubstitution,
	#instVars : [
		'case',
		'caseBlock',
		'input',
		'inputBlock',
		'outputBlock'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPExecuter class >> anExample: anExampleTree [

	self
		example: [SBVPExecuter]
		args: [{(SBVPDummyNode buildTree: {9 -> {10}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #a}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = 10]})
		output: (SBVPGroupPattern patterns: {SBVPBindingPattern bindingDict: {#identity -> #a}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: anExampleTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> case: aVPCase input: aVisualizer [
	"marker"

	^ self new
		case: aVPCase;
		input: aVisualizer
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeap: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ self exampleBuildHeapCase replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapBrokenBindings: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #g} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #b}.
				SBVPBindingPattern
					bindingDict: {#identity -> #boi}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #boi} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #dude}.
				SBVPBindingPattern
					bindingDict: {#identity -> #a}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapCase [

	^ SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #a} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #b}.
				SBVPBindingPattern
					bindingDict: {#identity -> #boi}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #boi} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #b}.
				SBVPBindingPattern
					bindingDict: {#identity -> #a}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapChain: aTree [

	| maxHeap |
	self
		example: [SBVPExecuter]
		args: [
			{
				((SBVPDummyNode key: 9) left: ((SBVPDummyNode key: 10)
					left: ((SBVPDummyNode key: 3)
						left: ((SBVPDummyNode key: 1)
							left: (SBVPDummyNode key: 0);
							right: (SBVPDummyNode key: 1));
						right: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 5)));
					right: ((SBVPDummyNode key: 7)
						left: ((SBVPDummyNode key: 5)
							left: (SBVPDummyNode key: 5);
							right: (SBVPDummyNode key: 5));
						right: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 8))))) showAsVisualPrimitive}]
		label: 'example'.
	maxHeap := self exampleBuildHeapCase replaceAllMatches: aTree.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBVPEllipsisPattern bindingDict: {#identity -> #b}.
					SBVPBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
					SBVPEllipsisPattern bindingDict: {#identity -> #d}}
				visualizingClass: SBVPDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key > (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #boi} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #b}.
				SBVPBindingPattern
					bindingDict: {#identity -> #a}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: maxHeap
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapSpecialShape: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPSpecialShapeFixture buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #a} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #b}.
				SBVPBindingPattern
					bindingDict: {#identity -> #boi}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #boi} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #b}.
				SBVPBindingPattern
					bindingDict: {#identity -> #a}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPSpecialShapeFixture) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapStrings: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPStringDummyNode buildTree: {
					'a' -> {'b' -> {'cre' -> {'dko' -> {'e'. 'f'}. 'ghui' -> {'h'}}. 'alk' -> {'i' -> {'j'. 'k'}. 'l' -> {'m'}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #a} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #b}.
				SBVPBindingPattern
					bindingDict: {#identity -> #boi}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> #boi} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> #b}.
				SBVPBindingPattern
					bindingDict: {#identity -> #a}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #e}}.
				SBVPEllipsisPattern bindingDict: {#identity -> #d}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPStringDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleBuildHeapTest: aTree [

	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> 'a'} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> 'aa'}.
				SBVPBindingPattern
					bindingDict: {#identity -> 'boi'}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> 'ac'}}.
				SBVPEllipsisPattern bindingDict: {#identity -> 'ab'}}.
			SBVPConstraintPattern constraint: [:bindings | false].
			SBVPBindingPattern bindingDict: {#identity -> 'a'}})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern bindingDict: {#identity -> 'boi'} children: {
				SBVPEllipsisPattern bindingDict: {#identity -> 'aa'}.
				SBVPBindingPattern
					bindingDict: {#identity -> 'a'}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> 'ac'}}.
				SBVPEllipsisPattern bindingDict: {#identity -> 'ab'}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleGrammarRuleMergeRepeat: aGrammarObject [

	| biop rüdigerString |
	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPGrammarObject new
					objectName: '';
					type: 'SEQ';
					members: {
						SBVPGrammarObject new
							objectName: 'aahh';
							type: 'SYMBOL';
							members: {}.
						SBVPGrammarObject new
							objectName: 'bbbb ';
							type: 'REPEAT';
							members: {
								SBVPGrammarObject new
									objectName: 'aahh';
									type: 'SYMBOL';
									members: {}};
							content: (SBVPGrammarObject new
								objectName: 'aahh';
								type: 'SYMBOL';
								members: {})}) showAsVisualPrimitive}]
		label: 'example'.
	biop := SBVPGrammarObject new.
	biop type: 'REPEAT1'.
	rüdigerString := 'SEQ'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#topLeftLabel -> [rüdigerString]}
				children: {
					SBVPBindingPattern
						bindingDict: {#identity -> #b}
						expressionDict: {#topLeftLabel -> ['SYMBOL']}.
					SBVPBindingPattern
						bindingDict: {#identity -> #c}
						expressionDict: {#topLeftLabel -> ['REPEAT']}
						children: {
							SBVPBindingPattern
								bindingDict: {#identity -> #d}
								expressionDict: {#topLeftLabel -> ['SYMBOL']}}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #b) objectName = (bindings at: #d) objectName]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #c}
				expressionDict: {#topLeftLabel -> ['REPEAT1']}
				children: {SBVPBindingPattern bindingDict: {#identity -> #b}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPGrammarObject) replaceAllMatches: aGrammarObject
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleGrammarRuleWeird: aGrammarObject [

	| bio |
	self
		example: [SBVPExecuter]
		args: [
			{
				(SBVPGrammarObject new
					type: 'SEQ';
					members: {
						SBVPGrammarObject new
							type: 'SYMBOL';
							objectName: 'aahh'.
						SBVPGrammarObject new
							type: 'REPEAT';
							content: (SBVPGrammarObject new
								type: 'SYMBOL';
								objectName: 'aahh')}) showAsVisualPrimitive}]
		label: 'example'.
	bio := SBVPGrammarObject new.
	bio type: 'REPEAT1'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#topLeftLabel -> ['SEQ']}
				children: {
					SBVPBindingPattern bindingDict: {#identity -> #b. #topLeftLabel -> #type}.
					SBVPBindingPattern
						bindingDict: {#identity -> #c}
						expressionDict: {#topLeftLabel -> ['REPEAT']}
						children: {
							SBVPBindingPattern
								bindingDict: {#identity -> #d}
								expressionDict: {#topLeftLabel -> ['SYMBOL']}}}.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #b) objectName = (bindings at: #d) objectName]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #c. #topLeftLabel -> #type}
				children: {SBVPBindingPattern bindingDict: {#identity -> #b}}})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPGrammarObject) replaceAllMatches: aGrammarObject
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleOrPattern [

	^ SBVPExecuter
		case: (SBVPTransformation
			input: (SBVPOrGroupPattern patterns: {
				SBVPBindingPattern bindingDict: {#identity -> #a} children: {
					SBVPBindingPattern
						bindingDict: {#identity -> #b}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #c}}}.
				SBVPGroupPattern patterns: {
					SBVPBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #c}}.
					SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key = 3]}})
			output: (SBVPGroupPattern patterns: {
				SBVPBindingPattern
					bindingDict: {#identity -> #a}
					expressionDict: {#innerLabel -> [42]}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #c}}})
			strategy: (Dictionary new
				add: #explicitRootMatching -> false;
				add: #explicitChildrenMatching -> true;
				yourself)
			visualizePatternsAs: SBVPDummyNode)
		input: (SBVPVisualizer
			code: [SBVPDummyNode buildTree: {9 -> {10 -> {3 -> {1 -> {0. 1}. 2 -> {5}}. 7 -> {5 -> {5. 5}. 2 -> {8}}}}}]
			showCode: true)
]

{ #category : #'as yet unclassified' }
SBVPExecuter class >> exampleWithConstants: aDummyNode [

	| salzstangen |
	self
		example: [SBVPExecuter]
		args: [{(SBVPDummyNode buildTree: {9 -> {10 -> {8}}}) showAsVisualPrimitive}]
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
SBVPExecuter >> case: snSBVPCase [

	case := snSBVPCase.
	self caseBlock removeAllMorphs.
	self caseBlock addMorphBack: snSBVPCase
]

{ #category : #accessing }
SBVPExecuter >> caseBlock [

	^ caseBlock
]

{ #category : #'as yet unclassified' }
SBVPExecuter >> evaluationReceiver [

	^ self
]

{ #category : #accessing }
SBVPExecuter >> execute [
	<action>

	self showOutput: (self case value: self inputCodeValue)
]

{ #category : #accessing }
SBVPExecuter >> execute100Times [
	<action>

	self showOutput: (self case replace: 100 matches: self inputCodeValue)
]

{ #category : #accessing }
SBVPExecuter >> executeAll [
	<action>

	self showOutput: (self case replaceAllMatches: self inputCodeValue)
]

{ #category : #accessing }
SBVPExecuter >> initialize [

	| cellInset |
	super initialize.
	cellInset := 3.
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		shrinkWrap;
		changeTableLayout;
		layoutInset: 6;
		addMorphBack: (SBTextBubble new contents: 'Executer');
		addMorphBack: (SBRow new
			cellInset: cellInset;
			addMorphBack: (SBButton new label: 'execute once' shortcut: nil do: [self execute]);
			addMorphBack: (SBButton new label: 'execute 100 times' shortcut: nil do: [self execute100Times]);
			addMorphBack: (SBButton new label: 'execute all' shortcut: nil do: [self executeAll]));
		addMorphBack: (SBRow new
			shrinkWrap;
			cellInset: cellInset;
			addMorphBack: (SBColumn new
				shrinkWrap;
				cellInset: cellInset;
				addMorphBack: (SBTextBubble new contents: 'Input');
				addMorphBack: (inputBlock := SBRow new shrinkWrap));
			addMorphBack: (SBColumn new
				shrinkWrap;
				cellInset: cellInset;
				addMorphBack: (SBTextBubble new contents: 'Transformation');
				addMorphBack: (caseBlock := SBRow new shrinkWrap));
			addMorphBack: (SBColumn new
				shrinkWrap;
				cellInset: cellInset;
				addMorphBack: (SBTextBubble new contents: 'Output');
				addMorphBack: (outputBlock := SBBlock new
					shrinkWrap;
					cellInset: cellInset)))
]

{ #category : #accessing }
SBVPExecuter >> input [

	^ input
]

{ #category : #accessing }
SBVPExecuter >> input: anSBVPVisualizer [

	input := anSBVPVisualizer.
	self inputBlock removeAllMorphs.
	self inputBlock addMorphBack: anSBVPVisualizer
]

{ #category : #accessing }
SBVPExecuter >> inputBlock [

	^ inputBlock
]

{ #category : #accessing }
SBVPExecuter >> inputCodeValue [

	^ self input code firstSubmorph evaluate value
]

{ #category : #accessing }
SBVPExecuter >> outputBlock [

	^ outputBlock
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
