"
An SBGroupPattern creates and contains SBBindingPatterns and SBConstraintPatterns. The patterns are seperated with an 'and'.

Instance Variables
	row:					SBRow
	isOutputPattern: 	Boolean

row
	- container for SBBindingPatterns, SBConstraintPatterns and the seperator strings

isOutputPattern
	- indicates whether this SBGGroupPattern is an output pattern

"
Class {
	#name : #SBGroupPattern,
	#superclass : #SBPattern,
	#instVars : [
		'row',
		'isOutputPattern'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBGroupPattern class >> matches: aBlock [

	^ self selector: #patterns: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBGroupPattern class >> newFor: aBlock [

	^ self new children: aBlock arguments first submorphs
]

{ #category : #'as yet unclassified' }
SBGroupPattern class >> patterns: aCollection [

	^ self new children: aCollection
]

{ #category : #accessing }
SBGroupPattern >> addChild: aPattern afterIndex: aNumber [

	super addChild: aPattern afterIndex: aNumber.
	self openPatternAsChild: aPattern
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addImplicitChildren: anArray [

	self children do: [:pattern | pattern addImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewBindingPattern [

	self addChild: SBBindingPattern new
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewChild [
	<action>

	| selectedIndex options |
	options := {#addNewBindingPattern. #addNewConstraintPattern}.
	selectedIndex := UIManager default chooseFrom: options.
	self perform: (options at: selectedIndex ifAbsent: [])
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewConstraintPattern [

	| newPattern |
	newPattern := SBConstraintPattern constraint: [:bindings | true].
	
	self sandblockEditor do: (SBInsertDomainBlockCommand new
		index: self owner submorphCount + 1;
		parent: self;
		container: self owner;
		morph: newPattern;
		shouldMergeWithNext: false;
		yourself)
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewParent [
	"Do nothing yet"

	
]

{ #category : #accessing }
SBGroupPattern >> addSeparatorsAround: aPattern [

	(aPattern submorphAfter
		ifNil: [false]
		ifNotNil: [(aPattern submorphAfter isKindOf: SBTextBubble) not]) ifTrue: [self row addMorph: (SBTextBubble new contents: self separatorString) after: aPattern].
	
	(aPattern submorphBefore
		ifNil: [false]
		ifNotNil: [(aPattern submorphBefore isKindOf: SBTextBubble) not]) ifTrue: [self row addMorph: (SBTextBubble new contents: self separatorString) inFrontOf: aPattern]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addToWorld: aWorld [

	self children do: [:pattern | pattern addToWorld: aWorld].
	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> allChildrenDo: aBlock [

	self children do: [:child | child allChildrenDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> buildFromBinding: anArray [

	self flag: #TODO.
	"Support multiple children"
	^ self children first buildFromBinding: anArray
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> buildImplicitChildren: anArray [

	self children do: [:pattern | pattern buildImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> deleteCommandFor: aBlock [

	| primitive |
	primitive := aBlock isDomainBlock
		ifTrue: [aBlock]
		ifFalse: [aBlock submorphThat: [:morph | morph isDomainBlock and: [morph parent = self]] ifNone: [nil]].
	
	^ SBDeleteDomainBlockCommand new target: primitive
]

{ #category : #accessing }
SBGroupPattern >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> getNext: aDomainBlock [

	self children do: [:pattern | (pattern getNext: aDomainBlock) ifFalse: [pattern reset] ifTrue: [^ true]].
	^ false
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> initialize [

	super initialize.
	self removeAllMorphs.
	
	isOutputPattern := false.
	
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
SBGroupPattern >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	| insertCommand |
	insertCommand := SBRelInsertDomainBlockCommand new
		near: aBlock before: aBoolean in: self morph: aMorph;
		yourself.
	^ self isOutputPattern not
		ifTrue: [insertCommand]
		ifFalse: [self row submorphs isEmpty ifTrue: [insertCommand] ifFalse: [nil]]
]

{ #category : #accessing }
SBGroupPattern >> isOutputPattern [

	^ isOutputPattern
]

{ #category : #accessing }
SBGroupPattern >> isOutputPattern: aBoolean [

	isOutputPattern := aBoolean
]

{ #category : #accessing }
SBGroupPattern >> label [

	^ nil
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> matches: aDomainBlock withBinding: aCollection [

	^ self children allSatisfy: [:pattern | pattern matches: aDomainBlock withBinding: aCollection]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	
	self resetVisualization
]

{ #category : #accessing }
SBGroupPattern >> openPatternAsChild: aPattern [

	| isBindingPattern insertPosition addedBlock |
	insertPosition := aPattern siblingIndex * 2 - 1.
	
	isBindingPattern := SBBindingPattern withAllSubclasses anySatisfy: [:subclass | subclass = aPattern class].
	isBindingPattern
		ifTrue: [
			addedBlock := SBBlock new
				layoutPolicy: SBTreeLayoutPolicy new;
				shrinkWrap;
				layoutInset: 6;
				when: #reportError send: #reportError: to: self.
			
			self row addMorph: addedBlock atIndex: insertPosition.
			
			aPattern addToWorld: addedBlock.
			aPattern addConnectorLinesIn: addedBlock]
		ifFalse: [
			self row addMorph: aPattern atIndex: insertPosition.
			addedBlock := aPattern].
	
	self addSeparatorsAround: addedBlock
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> rebuild [

	self allChildrenDo: [:child | child rebuild]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> removeChild: aPattern [

	super removeChild: aPattern.
	self resetVisualization
]

{ #category : #accessing }
SBGroupPattern >> removeImplicitChildren [

	self children do: [:child | child removeImplicitChildren]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> reset [

	self children do: [:pattern | pattern reset]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> resetVisualization [

	self patternContainer ifNotNil: [
		self row removeAllMorphs.
		self children do: [:aPattern | self openPatternAsChild: aPattern]]
]

{ #category : #accessing }
SBGroupPattern >> row [

	^ row
]

{ #category : #accessing }
SBGroupPattern >> separatorString [

	^ ' and '
]

{ #category : #accessing }
SBGroupPattern >> setBindingFor: aDomainBlock in: aCollection [

	^ self children allSatisfy: [:pattern | pattern setBindingFor: aDomainBlock in: aCollection]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(', self class name, ' patterns: {'.
	(self children reject: [:pattern | pattern isImplicitChild]) do: [:pattern |
		pattern writeSourceOn: aStream.
		aStream nextPut: $.].
	aStream nextPutAll: '})'
]
