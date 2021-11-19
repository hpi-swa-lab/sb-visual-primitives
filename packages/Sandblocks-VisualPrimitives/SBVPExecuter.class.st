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
		addMorphBack: (SBRow new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			addMorphBack: (TransformMorph new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				changeTableLayout;
				addMorph: (inputBlock := SBSandboxPasteUpMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					when: #reportError send: #reportError: to: self));
			addMorphBack: (TransformMorph new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				changeTableLayout;
				addMorph: (caseBlock := SBSandboxPasteUpMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					when: #reportError send: #reportError: to: self));
			addMorphBack: (TransformMorph new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				changeTableLayout;
				addMorph: (outputBlock := SBSandboxPasteUpMorph new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
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
SBVPExecuter >> reportError: anError [

	Transcript showln: anError. self halt
]
