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
		'labelBindingDict',
		'labelExpressionDict'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingDict: aDict [

	^ self new bindingDict: aDict asDictionary
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingDict: aDict connections: aCollection [

	^ self new
		bindingDict: aDict asDictionary;
		connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingDict: aDict expressionDict: anotherDict [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> bindingDict: aDict expressionDict: anotherDict connections: aCollection [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary;
		connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> expressionDict: aDict [

	^ self new expressionDict: aDict asDictionary
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> expressionDict: aDict bindingDict: anotherDict [

	^ self new
		expressionDict: aDict asDictionary;
		bindingDict: anotherDict asDictionary
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> expressionDict: aDict connections: aCollection [

	^ self new
		expressionDict: aDict asDictionary;
		connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> identityName [

	^ #identity
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> matches: aBlock [

	^ {#bindingDict:. #expressionDict:. #bindingDict:expressionDict:} anySatisfy: [:methodName | (self selector: methodName receiverMatches: aBlock) or: [self selector: methodName, #connections: receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> newFor: aBlock [

	^ aBlock arguments size > 2
		ifTrue: [
			self
				perform: aBlock selector asSymbol
				with: aBlock arguments first evaluate
				with: aBlock arguments second evaluate
				with: aBlock arguments third childSandblocks]
		ifFalse: [
			aBlock arguments size > 1
				ifTrue: [
					(aBlock selector endsWith: 'connections:')
						ifTrue: [
							self
								perform: aBlock selector asSymbol
								with: aBlock arguments first evaluate
								with: aBlock arguments second childSandblocks]
						ifFalse: [
							self
								perform: aBlock selector asSymbol
								with: aBlock arguments first evaluate
								with: aBlock arguments second evaluate]]
				ifFalse: [
					self perform: aBlock selector asSymbol with: ([aBlock arguments first evaluate]
						on: Error
						do: [{#identity -> aBlock sourceString}])]]
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
		implicitChild := SBVPEllipsisPattern bindingDict: {self class identityName -> (implicitChildrenIndices at: implicitChildrenCount + 1)}.
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
SBVPBindingPattern >> addLabel [
	<action>

	| index |
	index := UIManager default chooseFrom: self labelPositions.
	index > 0 ifTrue: [ | unknown |
		self sandblockEditor do: (SBDoItCommand new
			do: [
				self setLabelAt: (self labelPositions at: index) to: (unknown := self newUnknown).
				self layout.
				unknown startInput];
			undo: [
				self removeLabelAt: (self labelPositions at: index).
				self layout])]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self.
	self connections do: [:child | child addToWorld: aWorld]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> bindingDict: aDict [

	(aDict includesKey: self class identityName) ifTrue: [
		self bindingIndex: (aDict at: self class identityName).
		aDict removeKey: self class identityName].
	self labelBindingDict: aDict
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> bindingFor: aVisualPrimitive [

	^ self getCurrentPrimitive: aVisualPrimitive
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> bindingIndex [

	^ bindingIndex
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> bindingIndex: anObject [

	bindingIndex := anObject isSandblock
		ifTrue: [[anObject evaluate] on: Error do: [anObject sourceString]]
		ifFalse: [anObject]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> bindingIndexAutoCast [

	^ [:name :owner | | case |
		case := self parentCase.
		(case notNil and: [name hasOwner: case input])
			ifTrue: [name behaviorClass: SBStDeclarationForVPBinding]
			ifFalse: [name behaviorClass: SBStBinding]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> bindingLabelBlockFrom: aString [

	^ SBStName new
		autoCast: self bindingIndexAutoCast;
		behavior: SBStDeclarationForBlock new;
		contents: aString
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildChildrenFromBinding: aDict [

	^ self connections gather: [:pattern | pattern buildFromBinding: aDict]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildFromBinding: aDict [

	| output |
	output := self constant
		ifNotNil: [self constant value asVisualPrimitive]
		ifNil: [(aDict at: self bindingIndex) copy].
	output connections: (self buildChildrenFromBinding: aDict).
	self dynamicLabelDict associationsDo: [:assoc | output addPropertyMapping: assoc].
	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName | output addPropertyMapping: labelPosition -> (aDict at: bindingName)].
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
	
	addImplicitChild := [:index | | implicitChild identifier |
		identifier := self root nextIdentifier.
		implicitChild := SBVPEllipsisPattern bindingDict: {self class identityName -> identifier}.
		implicitChild isImplicitChild: true.
		self addConnection: implicitChild afterIndex: index + implicitChildren size.
		self owner addMorphBack: implicitChild.
		implicitChildren add: identifier.
		nextIndex := nextIndex + 1].
	
	(self connections isEmpty or: [self connections first wantsImplicitNeighbors]) ifTrue: [addImplicitChild value: 0].
	
	oldConnections withIndexDo: [:connection :index |
		(connection wantsImplicitNeighbors and: [
			oldConnections
				at: index + 1
				ifPresent: [:nextChild | nextChild wantsImplicitNeighbors]
				ifAbsent: [true]]) ifTrue: [addImplicitChild value: index]].
	
	aDict at: self bindingIndex put: implicitChildren asArray.
	
	oldConnections do: [:connection | connection buildImplicitChildren: aDict]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildNewInstance [

	^ self class bindingDict: {self class identityName -> self root nextIdentifier}
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> canMatchAllChildren [

	^ canMatchAllChildren
]

{ #category : #'as yet unclassified' }
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
	
	aCollection add: (self propertyAt: self identityLabelPosition)
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> constant [

	^ constant
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> constant: aBlock [

	constant := aBlock
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> convertToEllipsisPattern [
	<action>

	self sandblockEditor do: (SBCombinedCommand newWith: {
		SBVPDeleteCommand new target: self.
		SBVPInsertCommand new
			index: self owner submorphCount + 1;
			parent: self parent;
			siblingIndex: self siblingIndex;
			morph: (SBVPEllipsisPattern bindingDict: {self class identityName -> self bindingIndex} asDictionary);
			shouldMergeWithNext: false;
			yourself})
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> couldMatch: aVisualPrimitive [

	^ self childrenInCurrentMatch = aVisualPrimitive connections size and: [self constant isNil or: [self constant value = aVisualPrimitive origin]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> drawOn: aCanvas [

	self writeBackClosure ifNotNil: [aCanvas frameOval: (self bounds outsetBy: 5) width: 2 color: Color black].
	super drawOn: aCanvas.
	aCanvas frameRectangle: (self bounds outsetBy: 1) width: 2 color: color
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> dynamicLabelDict [

	| dict |
	dict := Dictionary new.
	self labelDict keysAndValuesDo: [:position :value | (self staticVisualPrimitiveMapping anySatisfy: [:association | association key = position]) ifFalse: [dict at: position put: value]].
	^ dict
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> enoughChildren: aVisualPrimitive [

	^ self childrenInCurrentMatch <= aVisualPrimitive connections size
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> expressionDict: aDict [

	(aDict includesKey: self class identityName) ifTrue: [
		self constant: (aDict at: self class identityName).
		aDict removeKey: self class identityName].
	
	self labelExpressionDict: aDict
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> findConstant [

	^ self constant value ifNil: [super findConstant]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> firstChildOffset [

	^ firstChildOffset
]

{ #category : #'as yet unclassified' }
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
SBVPBindingPattern >> identityLabelPosition [

	^ self staticVisualPrimitiveMapping
		detect: [:mapping | mapping key = #identityLabelPosition]
		ifFound: [:mapping | mapping patternValue]
		ifNone: [#innerLabel]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> indexOffset [

	^ 0
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> initialize [

	super initialize.
	self labelBindingDict: Dictionary new.
	self labelExpressionDict: Dictionary new
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> labelBindingChanged [

	self labelBindingDict copy keysAndValuesDo: [:key :value | self labelBindingDict at: key put: ((self labelContentAt: key) as: value class)]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> labelBindingDict [

	^ labelBindingDict
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> labelBindingDict: aDict [

	labelBindingDict := aDict
]

{ #category : #accessing }
SBVPBindingPattern >> labelExpressionDict [

	^ labelExpressionDict
]

{ #category : #accessing }
SBVPBindingPattern >> labelExpressionDict: anObject [

	labelExpressionDict := anObject
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> matches: aVisualPrimitive withBinding: aCollection [

	| offset |
	offset := 0.
	self dynamicLabelDict keysAndValuesDo: [:position :value | (aVisualPrimitive labelDict at: position ifAbsent: [^ false]) = value ifFalse: [^ false]].
	^ self connections withIndexAllSatisfy: [:connection :index | | wasSuccessful |
		wasSuccessful := connection
			matches: (connection searchRootFor: (self getCurrentPrimitive: aVisualPrimitive) at: index + offset)
			withBinding: aCollection.
		offset := offset + connection indexOffset.
		wasSuccessful]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> newEmptyChildNear: aBlock before: aBoolean [

	^ self newUnknown
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> newUnknown [

	^ SBVPUnknownLabel new grammarHandler: SBStGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> noteNewOwner: newOwner [

	super noteNewOwner: newOwner.
	self parentCase ifNotNil: [:case |
		self addPropertyMappings: self staticVisualPrimitiveMapping.
		self addPropertyMappings: (self labelExpressionDict associations collect: [:association |
			SBVPPropertyMappingExpression
				expression: association value
				vpProperty: association key]).
		self labelBindingDict keysAndValuesDo: [:key :value |
			(self setLabelAt: key to: (self bindingLabelBlockFrom: value))
				when: #contentsChanged
				send: #labelBindingChanged
				to: self].
		self constant ifNotNil: [self setLabelAt: self identityLabelPosition to: self constant asSandblock].
		self bindingIndex ifNotNil: [
			self
				setLabelAt: self identityLabelPosition
				to: (self bindingLabelBlockFrom: self bindingIndex asString)].
		(self constant isNil and: [self bindingIndex isNil]) ifTrue: [ | unkown |
			self setLabelAt: self identityLabelPosition to: (unkown := self newUnknown).
			unkown startInput]]
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
SBVPBindingPattern >> staticVisualPrimitiveMapping [

	^ self parentCase ifNil: {} ifNotNil: [:case |
		(case defaultPatternVisualizationClass
			ifNil: {}
			ifNotNil: #visualPrimitiveMapping)
			collect: [:mappingOrAssoc |
				mappingOrAssoc isPropertyMapping
					ifTrue: [mappingOrAssoc]
					ifFalse: [SBVPPropertyMapping fromAssociation: mappingOrAssoc]]
			thenSelect: [:mapping | mapping patternValue notNil]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> suggestAlways [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> suggestions [

	^ {SBSuggestionItem selector: 'text' label: 'a'}
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> valueFromPropertyMapping: aPropertyMapping [

	^ aPropertyMapping patternValue
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> writeBackClosure [

	^ writeBackClosure
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> writeBackClosureString [

	^ writeBackClosureString
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> writeBackClosureString: aString [

	writeBackClosureString := aString
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> writeSourceOn: aStream [

	| bindings expressions staticMapping |
	staticMapping := self staticVisualPrimitiveMapping.
	self isImplicitChild ifTrue: [^ nil].
	aStream
		nextPut: $(;
		nextPutAll: self class name.
	
	expressions := Dictionary new.
	bindings := Dictionary new.
	
	self blockDict keysAndValuesDo: [:position :value |
		(value hasSubmorphs
			and: [(staticMapping anySatisfy: [:association | association key = position]) not]
			and: [self labelPositions includes: position]) ifTrue: [
			value firstSubmorph isBlockBody
				ifTrue: [expressions at: position put: value firstSubmorph]
				ifFalse: [bindings at: position put: value firstSubmorph]]].
	
	self writeBackClosure ifNotNil: [
		aStream
			nextPutAll: ' writeBackClosure: ';
			nextPutAll: self writeBackClosureString].
	
	bindings ifNotEmpty: [
		aStream nextPutAll: ' bindingDict: {'.
		bindings keysAndValuesDo: [:key :value |
			key = self identityLabelPosition
				ifTrue: [self class identityName storeOn: aStream]
				ifFalse: [key storeOn: aStream].
			aStream nextPutAll: ' -> ('.
			value contents asSymbol storeOn: aStream.
			aStream nextPutAll: ').'].
		aStream nextPut: $}].
	
	expressions ifNotEmpty: [
		aStream nextPutAll: ' expressionDict: {'.
		expressions keysAndValuesDo: [:key :value |
			key = self identityLabelPosition
				ifTrue: [self class identityName storeOn: aStream]
				ifFalse: [key storeOn: aStream].
			aStream nextPutAll: ' -> ('.
			value writeSourceOn: aStream.
			aStream nextPutAll: ').'].
		aStream nextPut: $}].
	
	self connections ifNotEmpty: [
		aStream nextPutAll: ' connections: {'.
		(self connections reject: [:connection | connection isImplicitChild]) do: [:connection |
			connection writeSourceOn: aStream.
			aStream nextPut: $.].
		aStream nextPut: $}].
	aStream nextPut: $)
]
