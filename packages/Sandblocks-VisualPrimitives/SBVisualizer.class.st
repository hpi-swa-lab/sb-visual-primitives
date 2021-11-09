"
Visualizes the return value of the code block.
"
Class {
	#name : #SBVisualizer,
	#superclass : #SBStSubstitution,
	#instVars : [
		'visual',
		'code'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVisualizer class >> code: aCode extent: aPoint [
	" marker "

	
]

{ #category : #'as yet unclassified' }
SBVisualizer class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ (aBlock receiver satisfies: #(#notNil #isBinding))
		and: [aBlock receiver contents = self name]
		and: [aBlock selector = 'code:extent:']
]

{ #category : #'as yet unclassified' }
SBVisualizer class >> newFor: aBlock [

	^ self new code: aBlock arguments first extent: aBlock arguments second contents
]

{ #category : #accessing }
SBVisualizer >> code [

	^ code
]

{ #category : #accessing }
SBVisualizer >> code: anObject [

	code := anObject
]

{ #category : #accessing }
SBVisualizer >> code: aCodeBlock extent: aPoint [

	| content |
	self code addMorphBack: aCodeBlock.
	content := aCodeBlock evaluate value asVisualPrimitiveIn: self visual.
	content withDecorator: SBTreeDecorator do: [:dec|dec layout].
	self visual extent: aPoint
]

{ #category : #accessing }
SBVisualizer >> example [

	SBVisualizer
		code: [
			| root n1 n2 |
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
		extent: 300@300
]

{ #category : #accessing }
SBVisualizer >> initialize [

	super initialize.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6;
		addMorphBack: (TransformMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addMorph: (visual := SBSandboxPasteUpMorph new
				when: #reportError
				send: #reportError:
				to: self));
		addMorphBack: (code := SBColumn new layoutInset: 0)
]

{ #category : #accessing }
SBVisualizer >> visual [

	^ visual
]

{ #category : #accessing }
SBVisualizer >> visual: anObject [

	visual := anObject
]
