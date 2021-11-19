Class {
	#name : #SBPropertyInspector,
	#superclass : #SBBlock,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBPropertyInspector class >> newFor: anSBBlock [

	^ self basicNew initializeFor: anSBBlock
]

{ #category : #'as yet unclassified' }
SBPropertyInspector >> color [

	^ Color veryVeryLightGray
]

{ #category : #'as yet unclassified' }
SBPropertyInspector >> filterEvent: anEvent for: anObject [

	(anEvent isMouse and: [anEvent isMouseDown and: [(self containsPoint: anEvent position) not]]) ifTrue: [
		self delete.
		^ anEvent ignore].
	^ anEvent
]

{ #category : #'as yet unclassified' }
SBPropertyInspector >> initializeFor: anSBBlock [

	| codeWindow |
	self initialize.
	
	codeWindow := (SBStPlayground newFromSource: 'target' named: 'Code for:') hResizing: #spaceFill.
	(codeWindow createBinding: 'target') binding value: anSBBlock.
	
	self
		addMouseCaptureFilter: self;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 8;
		cellGap: 8;
		attachDecorator: SBForceMoveDecorator newConfigured.
	
	anSBBlock inspectableProperties do: [:aProperty |
		self addMorphBack: (SBRow new
			cellGap: 8;
			addMorphBack: (SBTextBubble new
				layoutInset: 4;
				colored: false;
				color: Color white;
				contents: aProperty asString);
			addMorphBack: (anSBBlock perform: aProperty) asSandblock)].
	
	self addMorphBack: codeWindow
]

{ #category : #'as yet unclassified' }
SBPropertyInspector >> isAttractedTo: aMorph [

	^ false
]
