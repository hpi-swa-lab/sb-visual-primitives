Class {
	#name : #SBVPBindingPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'firstChildOffset',
		'canMatchAllChildren',
		'constant',
		'bindingIndex',
		'writeBackClosure',
		'writeBackClosureString',
		'labelBindingDict'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingIndex: anObject [

	^ self bindingIndex: anObject connections: {}
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingIndex: anObject connections: aCollection [

	^ self new
		bindingIndex: anObject;
		connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingIndex: anObject labelBindingDict: aCollection [

	^ self new
		bindingIndex: anObject;
		labelBindingDict: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingIndex: anObject labelBindingDict: aCollection connections: anotherCollection [

	^ self new
		bindingIndex: anObject;
		connections: anotherCollection;
		labelBindingDict: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingIndex: anObject labelDict: aCollection [

	^ self new
		bindingIndex: anObject;
		addPropertyMappings: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingIndex: anObject labelDict: aCollection connections: anotherCollection [

	^ self new
		bindingIndex: anObject;
		connections: anotherCollection;
		addPropertyMappings: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> constant: anObject [

	^ self constant: anObject connections: {}
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> constant: anObject connections: aCollection [

	^ self new
		constant: anObject;
		connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> matches: aBlock [

	^ {#bindingIndex:. #constant:. #writeBackClosure:. #bindingIndex:labelDict:. #bindingIndex:labelBindingDict:} anySatisfy: [:methodName | (self selector: methodName receiverMatches: aBlock) or: [self selector: methodName, #connections: receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> newFor: aBlock [

	^ aBlock arguments size > 2
		ifTrue: [
			self
				perform: aBlock selector asSymbol
				with: aBlock arguments first
				with: aBlock arguments second evaluate
				with: aBlock arguments third childSandblocks]
		ifFalse: [
			aBlock arguments size > 1
				ifTrue: [
					(aBlock selector endsWith: 'connections:')
						ifTrue: [
							self
								perform: aBlock selector asSymbol
								with: aBlock arguments first
								with: aBlock arguments second childSandblocks]
						ifFalse: [
							self
								perform: aBlock selector asSymbol
								with: aBlock arguments first
								with: aBlock arguments second evaluate]]
				ifFalse: [self perform: aBlock selector asSymbol with: aBlock arguments first]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> registerShortcuts: aProvider [

	aProvider
		registerShortcut: Character backspace do: #deleteSubtree;
		registerShortcut: Character delete do: #deleteSubtree;
		registerShortcut: Character space do: #addNewChild;
		registerShortcut: Character space shift do: #addNewParent
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> writeBackClosure: aClosure [
	"should look like [:var | yourVariable := var]"

	^ self writeBackClosure: aClosure connections: {}
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> writeBackClosure: aClosure connections: aCollection [
	"should look like [:var | yourVariable := var]"

	^ self new
		writeBackClosure: aClosure;
		connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> addImplicitChildren: aDict [

	| addImplicitChild implicitChildrenIndices implicitChildrenCount oldConnections |
	self connections do: [:connection | connection addImplicitChildren: aDict].
	implicitChildrenIndices := aDict at: self bindingIndex ifAbsent: [^ self].
	implicitChildrenCount := 0.
	addImplicitChild := [:index | | implicitChild |
		implicitChildrenCount >= implicitChildrenIndices size ifTrue: [^ self].
		implicitChild := SBVPEllipsisPattern bindingIndex: (implicitChildrenIndices at: implicitChildrenCount + 1).
		implicitChild isImplicitChild: true.
		self addConnection: implicitChild afterIndex: index + implicitChildrenCount.
		self owner addMorphBack: implicitChild.
		implicitChildrenCount := implicitChildrenCount + 1].
	
	oldConnections := self connections copy.
	(self connections isEmpty or: [self connections first wantsImplicitNeighbors]) ifTrue: [addImplicitChild value: 0].
	
	oldConnections withIndexDo: [:connection :index |
		(connection wantsImplicitNeighbors and: [
			oldConnections
				at: index + 1
				ifPresent: [:nextChild | nextChild wantsImplicitNeighbors]
				ifAbsent: [true]]) ifTrue: [addImplicitChild value: index]].
	
	[implicitChildrenCount < implicitChildrenIndices size] whileTrue: [addImplicitChild value: oldConnections size]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> addNewChild [
	<action>

	| newChild |
	newChild := self class bindingIndex: self root nextIdentifier.
	self addConnection: newChild.
	self owner addMorphBack: newChild.
	self root attachTreeDecorator.
	self root layout
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> addNewParent [
	<action>

	| newParent |
	newParent := self class bindingIndex: self root nextIdentifier.
	self parent ifNotNil: [
		self parent addConnection: newParent afterIndex: self siblingIndex.
		self parent removeConnection: self].
	newParent addConnection: self.
	self owner addMorphBack: newParent.
	self allPatternsDo: [:pattern | pattern detachDecorators: SBTreeDecorator].
	self root attachTreeDecorator.
	self root layout
]

{ #category : #accessing }
SBVPBindingPattern >> addToWorld: aWorld [

	self connections do: [:child | child addToWorld: aWorld].
	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> allPatternsDo: aBlock [

	aBlock value: self.
	super allPatternsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> bindingBlock [

	^ self innerLabel
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> bindingFor: aVisualPrimitive [

	^ self getCurrentPrimitive: aVisualPrimitive
]

{ #category : #accessing }
SBVPBindingPattern >> bindingIndex [

	^ bindingIndex
]

{ #category : #accessing }
SBVPBindingPattern >> bindingIndex: anObject [

	| label |
	bindingIndex := anObject isSandblock
		ifTrue: [[anObject evaluate] on: Error do: [anObject sourceString]]
		ifFalse: [anObject].
	label := SBStName new
		autoCast: self bindingIndexAutoCast;
		behavior: SBStDeclarationForBlock new;
		contents: bindingIndex asString.
	label when: #contentsChanged send: #bindingIndexChanged to: self.
	self innerLabel: label.
	self labelDict removeKey: #innerLabel
]

{ #category : #accessing }
SBVPBindingPattern >> bindingIndexAutoCast [

	^ [:name :owner | | case |
		case := self parentCase.
		(case notNil and: [name hasOwner: case input])
			ifTrue: [name behaviorClass: SBStDeclarationForVPBinding]
			ifFalse: [name behaviorClass: SBStBinding]]
]

{ #category : #accessing }
SBVPBindingPattern >> bindingIndexChanged [

	self bindingIndex: self innerLabel contents asSymbol
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildChildrenFromBinding: aDict [

	^ self connections gather: [:pattern | pattern buildFromBinding: aDict]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildFromBinding: aDict [

	| output |
	output := self constant
		ifNotNil: [self constant asVisualPrimitive]
		ifNil: [(aDict at: self bindingIndex) copy].
	output connections: (self buildChildrenFromBinding: aDict).
	output labelDict addAll: self labelDict.
	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName | output labelDict at: labelPosition put: (aDict at: bindingName)].
	^ {output}
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildImplicitChildren: aDict [

	| implicitChildren nextIndex oldConnections addImplicitChild |
	implicitChildren := OrderedCollection new.
	nextIndex := ((aDict collect: [:subArray | subArray size])
		ifEmpty: [0]
		ifNotEmpty: [:guy | guy sum]) + 1.
	
	oldConnections := self connections copy.
	
	addImplicitChild := [:index | | implicitChild bindingIndex |
		bindingIndex := self root nextIdentifier.
		implicitChild := SBVPEllipsisPattern bindingIndex: bindingIndex.
		implicitChild isImplicitChild: true.
		self addConnection: implicitChild afterIndex: index + implicitChildren size.
		self owner addMorphBack: implicitChild.
		implicitChildren add: bindingIndex.
		nextIndex := nextIndex + 1].
	
	(self connections isEmpty or: [self connections first wantsImplicitNeighbors]) ifTrue: [addImplicitChild value: 0].
	
	oldConnections withIndexDo: [:connection :index |
		(connection wantsImplicitNeighbors and: [
			oldConnections
				at: index + 1
				ifPresent: [:nextChild | nextChild wantsImplicitNeighbors]
				ifAbsent: [true]]) ifTrue: [addImplicitChild value: index]].
	
	aDict at: self bindingIndex put: implicitChildren asArray.
	
	oldConnections do: [:connections | connections buildImplicitChildren: aDict]
]

{ #category : #accessing }
SBVPBindingPattern >> canMatchAllChildren [

	^ canMatchAllChildren
]

{ #category : #accessing }
SBVPBindingPattern >> canMatchAllChildren: anObject [

	canMatchAllChildren := anObject
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> childrenInCurrentMatch [

	| offsetSum |
	offsetSum := self connections
		inject: 0
		into: [:sum :connection | sum + connection indexOffset].
	^ self connections size + offsetSum
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> collectBindingsInto: aCollection [

	super collectBindingsInto: aCollection.
	aCollection add: self bindingBlock
]

{ #category : #accessing }
SBVPBindingPattern >> constant [

	^ constant
]

{ #category : #accessing }
SBVPBindingPattern >> constant: anObject [

	constant := anObject isSandblock
		ifTrue: [
			self innerLabel: anObject.
			self labelDict removeKey: #innerLabel.
			anObject evaluate ifNil: [#placeholder]]
		ifFalse: [anObject]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> couldMatch: aVisualPrimitive [

	^ self childrenInCurrentMatch = aVisualPrimitive connections size and: [self constant isNil or: [self constant = aVisualPrimitive origin]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> deleteSubtree [
	<action>

	self parent ifNotNil: [self parent removeConnection: self].
	self allPatternsDo: [:block | block abandon]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> drawOn: aCanvas [

	self writeBackClosure ifNotNil: [aCanvas frameOval: (self bounds outsetBy: 5) width: 2 color: Color black].
	super drawOn: aCanvas.
	aCanvas frameRectangle: (self bounds outsetBy: 1) width: 2 color: color
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> enoughChildren: aVisualPrimitive [

	^ self childrenInCurrentMatch <= aVisualPrimitive connections size
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> findConstant [

	^ self constant ifNil: [super findConstant]
]

{ #category : #accessing }
SBVPBindingPattern >> firstChildOffset [

	^ firstChildOffset
]

{ #category : #accessing }
SBVPBindingPattern >> firstChildOffset: anObject [

	firstChildOffset := anObject
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> getCurrentPrimitive: aVisualPrimitive [

	^ aVisualPrimitive
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> getNext: aVisualPrimitive [

	| currentPrimitive |
	currentPrimitive := self getCurrentPrimitive: aVisualPrimitive.
	(self enoughChildren: currentPrimitive) ifTrue: [ | offset |
		offset := 0.
		self connections withIndexDo: [:connection :index |
			((connection getNext: (connection searchRootFor: currentPrimitive at: index + offset)) and: [self enoughChildren: currentPrimitive])
				ifTrue: [^ true]
				ifFalse: [connection reset].
			offset := offset + connection indexOffset]].
	^ false
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> indexOffset [

	^ 0
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> initialize [

	super initialize.
	self labelBindingDict: Dictionary new
]

{ #category : #accessing }
SBVPBindingPattern >> labelBindingChanged [

	self labelBindingDict copy keysAndValuesDo: [:key :value | self labelBindingDict at: key put: ((self labelContentAt: key) as: value class)]
]

{ #category : #accessing }
SBVPBindingPattern >> labelBindingDict [

	^ labelBindingDict
]

{ #category : #accessing }
SBVPBindingPattern >> labelBindingDict: anObject [

	labelBindingDict := anObject.
	self flag: #TODO.
	"Use Name instead of TextBubble once replacing works"
	labelBindingDict keysAndValuesDo: [:key :value |
		(self setLabelAt: key to: value)
			when: #contentsChanged
			send: #labelBindingChanged
			to: self]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> matches: aVisualPrimitive withBinding: aCollection [

	| offset |
	offset := 0.
	self labelDict keysAndValuesDo: [:position :value | (aVisualPrimitive labelDict at: position ifAbsent: [^ false]) = value ifFalse: [^ false]].
	^ self connections withIndexAllSatisfy: [:connection :index | | wasSuccessful |
		wasSuccessful := connection
			matches: (connection searchRootFor: (self getCurrentPrimitive: aVisualPrimitive) at: index + offset)
			withBinding: aCollection.
		offset := offset + connection indexOffset.
		wasSuccessful]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> noteNewOwner: newOwner [

	super noteNewOwner: newOwner.
	self parentCase ifNotNil: [:case | case defaultPatternVisualizationClass ifNotNil: [:visClass | self addPropertyMappings: visClass staticVisualPrimitiveMapping]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> parentCase [

	| case |
	case := self root parentSandblock.
	^ (case isKindOf: SBVPCase) ifTrue: [case] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> preferredColor [

	^ self color
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> reset [

	self resetChildren
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> resetChildren [

	self connections do: [:connection | connection reset]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> searchRootFor: aVisualPrimitive at: anIndex [

	^ self indexOffset < 0
		ifTrue: [aVisualPrimitive]
		ifFalse: [aVisualPrimitive connections at: anIndex]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> setBindingFor: aVisualPrimitive in: aDict [

	| currentPrimitive setBinding |
	setBinding := [:bindingName :binding |
		aDict
			at: bindingName
			ifPresent: [:previousValue | previousValue = binding ifFalse: [^ false]]
			ifAbsent: [aDict at: bindingName put: binding]].
	currentPrimitive := self getCurrentPrimitive: aVisualPrimitive.
	self bindingIndex ifNotNil: [setBinding value: self bindingIndex value: (self bindingFor: aVisualPrimitive)].
	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName | setBinding value: bindingName value: (aVisualPrimitive labelDict at: labelPosition)].
	self writeBackClosure ifNotNil: [self writeBackClosure value: currentPrimitive origin].
	^ (self couldMatch: currentPrimitive) and: [self setConnectionBindingFor: currentPrimitive in: aDict]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> setConnectionBindingFor: aVisualPrimitive in: aDict [

	| offset |
	offset := 0.
	^ self connections withIndexAllSatisfy: [:connection :index | | wasSuccessful |
		wasSuccessful := connection
			setBindingFor: (connection searchRootFor: (self getCurrentPrimitive: aVisualPrimitive) at: index + offset)
			in: aDict.
		offset := offset + connection indexOffset.
		wasSuccessful]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> typeNewLine [
	<action>

	self halt
]

{ #category : #accessing }
SBVPBindingPattern >> writeBackClosure [

	^ writeBackClosure
]

{ #category : #accessing }
SBVPBindingPattern >> writeBackClosure: anObject [

	writeBackClosure := anObject isSandblock
		ifTrue: [ | variableBlock |
			variableBlock := anObject statements first receiver copy.
			self innerLabel: variableBlock.
			self labelDict removeKey: #innerLabel.
			self writeBackClosureString: anObject sourceString.
			anObject evaluate]
		ifFalse: [anObject]
]

{ #category : #accessing }
SBVPBindingPattern >> writeBackClosureString [

	^ writeBackClosureString
]

{ #category : #accessing }
SBVPBindingPattern >> writeBackClosureString: aString [

	writeBackClosureString := aString
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> writeLabelDictOn: aStream [
	"Currently only works when we have text bubbles. Otherwise we need to get a smart solution for this."

	| staticMapping |
	staticMapping := self parentCase defaultPatternVisualizationClass staticVisualPrimitiveMapping.
	aStream nextPutAll: ' labelDict: {'.
	self blockDict keysAndValuesDo: [:position :block | | value |
		((position = #innerLabel) not
			and: [block submorphs notEmpty]
			and: [(staticMapping anySatisfy: [:association | association key = position]) not]) ifTrue: [
			"We avoid the innerlabel as it is enclosed in the shape morph and is currently used as bindingIndex."
			value := block firstSubmorph contents.
			position printOn: aStream.
			aStream nextPutAll: ' -> ('.
			value printOn: aStream.
			aStream nextPutAll: ').']].
	aStream nextPutAll: '}'
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> writeSourceOn: aStream [

	self isImplicitChild ifTrue: [^ nil].
	aStream
		nextPut: $(;
		nextPutAll: self class name.
	
	self bindingIndex ifNotNil: [
		aStream nextPutAll: ' bindingIndex: '.
		self bindingIndex printOn: aStream].
	
	self constant ifNotNil: [
		aStream
			nextPutAll: ' constant: ';
			nextPutAll: (self blockDict at: #innerLabel) firstSubmorph firstSubmorph contents].
	
	self writeBackClosure ifNotNil: [
		aStream
			nextPutAll: ' writeBackClosure: ';
			nextPutAll: self writeBackClosureString].
	
	self labelDict ifNotEmpty: [self writeLabelDictOn: aStream].
	
	self labelBindingDict ifNotEmpty: [
		aStream nextPutAll: ' labelBindingDict: '.
		self labelBindingDict storeOn: aStream].
	
	self connections ifNotEmpty: [
		aStream nextPutAll: ' connections: {'.
		(self connections reject: [:connection | connection isImplicitChild]) do: [:connection |
			connection writeSourceOn: aStream.
			aStream nextPut: $.].
		aStream nextPut: $}].
	aStream nextPut: $)
]
