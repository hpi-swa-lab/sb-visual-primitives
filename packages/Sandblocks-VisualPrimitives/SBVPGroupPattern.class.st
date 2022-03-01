Class {
	#name : #SBVPGroupPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'row'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> matches: aBlock [

	^ self selector: #patterns: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> newFor: aBlock [

	^ self new children: aBlock arguments first submorphs
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern class >> patterns: aCollection [

	^ self new children: aCollection
]

{ #category : #accessing }
SBVPGroupPattern >> addChild: aPattern afterIndex: aNumber [

	super addChild: aPattern afterIndex: aNumber.
	self openPatternAsChild: aPattern
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addImplicitChildren: anArray [

	self children do: [:pattern | pattern addImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addNewBindingPattern [

	| newPattern |
	newPattern := SBVPBindingPattern new.
	
	self addChild: newPattern
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addNewChild [
	<action>

	| selectedIndex options |
	options := {#addNewBindingPattern. #addNewConstraintPattern}.
	selectedIndex := UIManager default chooseFrom: options.
	self perform: (options at: selectedIndex ifAbsent: [])
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addNewConstraintPattern [

	| newPattern |
	newPattern := SBVPConstraintPattern constraint: [:bindings | true].
	
	self sandblockEditor do: (SBVPInsertCommand new
		index: self owner submorphCount + 1;
		parent: self;
		container: self owner;
		morph: newPattern;
		shouldMergeWithNext: false;
		yourself)
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addNewParent [
	"Do nothing yet"

	
]

{ #category : #accessing }
SBVPGroupPattern >> addSeperatorsAround: aPattern [

	(aPattern submorphAfter
		ifNil: [false]
		ifNotNil: [(aPattern submorphAfter isKindOf: SBTextBubble) not]) ifTrue: [self row addMorph: (SBTextBubble new contents: self seperatorString) after: aPattern].
	
	(aPattern submorphBefore
		ifNil: [false]
		ifNotNil: [(aPattern submorphBefore isKindOf: SBTextBubble) not]) ifTrue: [self row addMorph: (SBTextBubble new contents: self seperatorString) inFrontOf: aPattern]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> addToWorld: aWorld [

	self children do: [:pattern | pattern addToWorld: aWorld].
	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> allChildrenDo: aBlock [

	self children do: [:child | child allChildrenDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> attachTreeDecorator [

	self children do: [:child | child attachTreeDecorator]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> buildFromBinding: anArray [

	self flag: #TODO.
	"Support multiple children"
	^ self children first buildFromBinding: anArray
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> buildImplicitChildren: anArray [

	self children do: [:pattern | pattern buildImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> deleteCommandFor: aBlock [

	| primitive |
	primitive := aBlock isVisualPrimitive
		ifTrue: [aBlock]
		ifFalse: [aBlock submorphThat: [:morph | morph isVisualPrimitive and: [morph parent = self]] ifNone: [nil]].
	
	^ SBVPDeleteCommand new target: primitive
]

{ #category : #accessing }
SBVPGroupPattern >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> getNext: aVisualPrimitive [

	self children do: [:pattern |
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
		shrinkWrap;
		changeTableLayout;
		layoutInset: 4;
		addMorphBack: (row := SBRow new
			shrinkWrap;
			cellInset: 3;
			cellPositioning: #center)
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	^ SBVPRelInsertCommand new
		near: aBlock before: aBoolean in: self morph: aMorph;
		yourself
]

{ #category : #accessing }
SBVPGroupPattern >> label [

	^ nil
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ self children allSatisfy: [:pattern | pattern matches: aVisualPrimitive withBinding: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	
	self resetVisualization
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> objectInterfaceNear: aBlock at: aSymbol [

	^ {[:o | o isKindOf: SBVisualPrimitive]}
]

{ #category : #accessing }
SBVPGroupPattern >> openPatternAsChild: aPattern [

	| isBindingPattern insertPosition addedBlock |
	insertPosition := aPattern siblingIndex * 2 - 1.
	
	isBindingPattern := SBVPBindingPattern withAllSubclasses anySatisfy: [:subclass | subclass = aPattern class].
	isBindingPattern
		ifTrue: [ | patternContainer |
			patternContainer := SBBlock new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				layoutInset: 6;
				when: #reportError send: #reportError: to: self.
			
			self row
				addMorph: (addedBlock := SBRow new
					addMorphBack: patternContainer;
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap)
				atIndex: insertPosition.
			
			aPattern
				addToWorld: patternContainer;
				attachTreeDecorator;
				layout]
		ifFalse: [
			self row addMorph: aPattern atIndex: insertPosition.
			addedBlock := aPattern].
	
	self addSeperatorsAround: addedBlock
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> rebuild [

	self allChildrenDo: [:child | child rebuild]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> removeChild: aPattern [

	super removeChild: aPattern.
	self resetVisualization
]

{ #category : #accessing }
SBVPGroupPattern >> removeImplicitChildren [

	self children do: [:child | child removeImplicitChildren]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> reset [

	self children do: [:pattern | pattern reset]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> resetVisualization [

	self patternContainer ifNotNil: [
		self row removeAllMorphs.
		self children do: [:aPattern | self openPatternAsChild: aPattern]]
]

{ #category : #accessing }
SBVPGroupPattern >> row [

	^ row
]

{ #category : #accessing }
SBVPGroupPattern >> seperatorString [

	^ ' and '
]

{ #category : #accessing }
SBVPGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ self children allSatisfy: [:pattern | pattern setBindingFor: aVisualPrimitive in: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPGroupPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(', self class name, ' patterns: {'.
	(self children reject: [:pattern | pattern isImplicitChild]) do: [:pattern |
		pattern writeSourceOn: aStream.
		aStream nextPut: $.].
	aStream nextPutAll: '})'
]
