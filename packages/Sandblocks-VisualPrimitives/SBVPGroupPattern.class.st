Class {
	#name : #SBVPGroupPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'row'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> matches: aBlock [

	^ self selector: #patterns: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> newFor: aBlock [

	^ self new connections: aBlock arguments first childSandblocks
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> patterns: aCollection [

	^ self new connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> registerShortcuts: aProvider [

	aProvider registerShortcut: Character space do: #addNewPattern
]

{ #category : #accessing }
SBVPGroupPattern >> addConnection: aPattern [

	super addConnection: aPattern.
	self openPatternAsChild: aPattern.
	aPattern parent: self
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addImplicitChildren: anArray [

	self connections do: [:pattern | pattern addImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addNewBindingPattern [

	| newPattern |
	newPattern := SBVPBindingPattern bindingDict: {#identity -> #a} connections: {}.
	
	self addConnection: newPattern
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addNewConstraintPattern [

	| newPattern |
	newPattern := SBVPConstraintPattern constraint: [:bindings | true].
	
	self addConnection: newPattern
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addNewPattern [
	<action>

	| selectedIndex options |
	options := {#addNewBindingPattern. #addNewConstraintPattern}.
	selectedIndex := UIManager default chooseFrom: options.
	self perform: (options at: selectedIndex ifAbsent: [])
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addToWorld: aWorld [

	self connections do: [:pattern | pattern addToWorld: aWorld].
	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> attachTreeDecorator [

	self connections do: [:child | child attachTreeDecorator]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> buildFromBinding: anArray [

	^ self connections first buildFromBinding: anArray
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> buildImplicitChildren: anArray [

	self connections do: [:pattern | pattern buildImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> findConstant [

	self connections do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> getNext: aVisualPrimitive [

	self connections do: [:pattern |
		(pattern getNext: aVisualPrimitive)
			ifFalse: [pattern reset]
			ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> initialize [

	super initialize.
	self removeAllMorphs.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 4;
		addMorphBack: (row := SBRow new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			cellInset: 3;
			cellPositioning: #center)
]

{ #category : #accessing }
SBVPGroupPattern >> label [

	^ nil
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self connections allSatisfy: [:pattern | pattern matches: aVisualPrimitive withBinding: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	
	self resetVisualization
]

{ #category : #accessing }
SBVPGroupPattern >> openPatternAsChild: aPattern [

	| isBindingPattern |
	isBindingPattern := SBVPBindingPattern withAllSubclasses anySatisfy: [:subclass | subclass = aPattern class].
	aPattern siblingIndex > 1 ifTrue: [self row addMorphBack: (SBTextBubble new contents: self seperatorString)].
	isBindingPattern
		ifTrue: [ | patternContainer |
			patternContainer := SBBlock new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				layoutInset: 6;
				when: #reportError send: #reportError: to: self.
			self row addMorphBack: (SBRow new
				addMorphBack: patternContainer;
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap).
			aPattern
				addToWorld: patternContainer;
				attachTreeDecorator;
				layout]
		ifFalse: [self row addMorphBack: aPattern]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> removeConnection: aPattern [

	super removeConnection: aPattern.
	self halt.
	self resetVisualization
]

{ #category : #accessing }
SBVPGroupPattern >> removeImplicitChildren [

	self connections do: [:child | child removeImplicitChildren]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> reset [

	self connections do: [:pattern | pattern reset]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> resetVisualization [

	self parentCase ifNotNil: [
		self row removeAllMorphs.
		self connections do: [:aPattern | self openPatternAsChild: aPattern]]
]

{ #category : #accessing }
SBVPGroupPattern >> row [

	^ row
]

{ #category : #accessing }
SBVPGroupPattern >> row: anObject [

	row := anObject
]

{ #category : #accessing }
SBVPGroupPattern >> seperatorString [

	^ ' and '
]

{ #category : #accessing }
SBVPGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ self connections allSatisfy: [:pattern | pattern setBindingFor: aVisualPrimitive in: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(', self class name, ' patterns: {'.
	(self connections reject: [:pattern | pattern isImplicitChild]) do: [:pattern |
		pattern writeSourceOn: aStream.
		aStream nextPut: $.].
	aStream nextPutAll: '})'
]
