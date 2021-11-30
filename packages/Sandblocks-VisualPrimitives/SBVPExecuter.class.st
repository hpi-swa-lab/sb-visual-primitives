Class {
	#name : #SBVPExecuter,
	#superclass : #SBBlock,
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
	(self case value: self input code firstSubmorph evaluate value) asVisualPrimitiveIn: self outputBlock
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
		addMorphBack: (SBTextBubble new contents: 'Executioner');
		addMorphBack: (SBRow new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				addMorphBack: (SBTextBubble new contents: 'Input');
				addMorphBack: (TransformMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					changeTableLayout;
					addMorph: (inputBlock := SBSandboxPasteUpMorph new
						hResizing: #shrinkWrap;
						vResizing: #shrinkWrap;
						when: #reportError send: #reportError: to: self)));
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				addMorphBack: (SBTextBubble new contents: 'Transformation');
				addMorphBack: (TransformMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					changeTableLayout;
					addMorph: (caseBlock := SBSandboxPasteUpMorph new
						hResizing: #shrinkWrap;
						vResizing: #shrinkWrap;
						when: #reportError send: #reportError: to: self)));
			addMorphBack: (SBColumn new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				addMorphBack: (SBTextBubble new contents: 'Output');
				addMorphBack: (TransformMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					changeTableLayout;
					addMorph: (outputBlock := SBSandboxPasteUpMorph new
						hResizing: #shrinkWrap;
						vResizing: #shrinkWrap;
						layoutInset: 6;
						when: #reportError send: #reportError: to: self))))
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
