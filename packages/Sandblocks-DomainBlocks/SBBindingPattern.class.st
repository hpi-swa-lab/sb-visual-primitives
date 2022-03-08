"
An SBBindingPattern is used to represent a single object visual. It's children are visualized as well recursively.

Instance Variables
	bindingIndex:					Object
	constant:						SBBlock
	labelBindingDict:				Dictionary
	labelExpressionDict:			Dictionary
	visualizingClass:				Class
	writeBackClosure:			BlockClosure
	writeBackClosureString:		String

bindingIndex
	- the primitive's binding 
	
constant
	- stores value of sourceObject if it's a constant
	- can be nil if there is no underlying sourceObject

labelBindingDict
	- dictionary of label positions and their bindings

labelExpressionDict
	- dictionary of label positions and their values

visualizingClass
	- the class to be visualized

writeBackClosure
	- xxxxx

writeBackClosureString
	- xxxxx

"
Class {
	#name : #SBBindingPattern,
	#superclass : #SBPattern,
	#instVars : [
		'bindingDict',
		'expressionDict',
		'visualizingClass',
		'writeBackClosure',
		'writeBackClosureString'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBBindingPattern class >> bindingDict: aDict [

	^ self new bindingDict: aDict asDictionary
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> bindingDict: aDict children: aCollection [

	^ self new
		bindingDict: aDict asDictionary;
		children: aCollection
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> bindingDict: aDict children: aCollection visualizingClass: aClass [

	^ self new
		bindingDict: aDict asDictionary;
		children: aCollection;
		visualizingClass: aClass
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> bindingDict: aDict expressionDict: anotherDict [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> bindingDict: aDict expressionDict: anotherDict children: aCollection [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary;
		children: aCollection
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> bindingDict: aDict expressionDict: anotherDict children: aCollection visualizingClass: aClass [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary;
		children: aCollection;
		visualizingClass: aClass
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> bindingDict: aDict expressionDict: anotherDict visualizingClass: aClass [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary;
		visualizingClass: aClass
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> bindingDict: aDict visualizingClass: aClass [

	^ self new
		bindingDict: aDict asDictionary;
		visualizingClass: aClass
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> expressionDict: aDict [

	^ self new expressionDict: aDict asDictionary
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> expressionDict: aDict bindingDict: anotherDict [

	^ self new
		expressionDict: aDict asDictionary;
		bindingDict: anotherDict asDictionary
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> expressionDict: aDict bindingDict: anotherDict visualizingClass: aClass [

	^ self new
		expressionDict: aDict asDictionary;
		bindingDict: anotherDict asDictionary;
		visualizingClass: aClass
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> expressionDict: aDict children: aCollection [

	^ self new
		expressionDict: aDict asDictionary;
		children: aCollection
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> expressionDict: aDict children: aCollection visualizingClass: aClass [

	^ self new
		expressionDict: aDict asDictionary;
		children: aCollection;
		visualizingClass: aClass
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> expressionDict: aDict visualizingClass: aClass [

	^ self new
		expressionDict: aDict asDictionary;
		visualizingClass: aClass
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> identityName [

	^ #identity
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> matches: aBlock [
	"match any resonable combination of constructor arguments"

	^ (({#bindingDict:. #expressionDict:. #bindingDict:expressionDict:} gather: [:symbol | {symbol. symbol, #children:}]) gather: [:symbol | {symbol. symbol, #visualizingClass:}]), {#writeBackClosure:. #writeBackClosure:children:} anySatisfy: [:methodName | self selector: methodName receiverMatches: aBlock]
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> newFor: aBlock [

	| selectors arguments |
	selectors := aBlock selector findTokens: ':'.
	arguments := aBlock arguments with: selectors collect: [:argument :selector |
		selector = 'children' ifTrue: [argument childSandblocks] ifFalse: [
			selector = 'writeBackClosure'
				ifTrue: [argument]
				ifFalse: [[argument evaluate] on: Error do: [{self identityName -> aBlock sourceString}]]]].
	
	^ self perform: aBlock selector asSymbol withArguments: arguments
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> writeBackClosure: aClosure [
	"should look like [:var | yourVariable := var]"

	^ self writeBackClosure: aClosure children: {}
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> writeBackClosure: aClosure children: aCollection [
	"should look like [:var | yourVariable := var]"

	^ self new
		writeBackClosure: aClosure;
		children: aCollection
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> addImplicitChildren: aDict [

	| addImplicitChild implicitChildrenIndices implicitChildrenCount oldChildren |
	self children do: [:child | child addImplicitChildren: aDict].
	implicitChildrenIndices := aDict at: self bindingIndex ifAbsent: [^ self].
	implicitChildrenCount := 0.
	addImplicitChild := [:index | | implicitChild |
		implicitChildrenCount >= implicitChildrenIndices size ifTrue: [^ self].
		implicitChild := SBEllipsisPattern bindingDict: {self class identityName -> (implicitChildrenIndices at: implicitChildrenCount + 1)}.
		self addChild: implicitChild afterIndex: index + implicitChildrenCount.
		implicitChild isImplicitChild: true.
		self owner ifNotNil: [:morph | morph addMorphBack: implicitChild].
		implicitChildrenCount := implicitChildrenCount + 1].
	
	oldChildren := self children copy.
	(self children isEmpty or: [self children first wantsImplicitNeighbors]) ifTrue: [addImplicitChild value: 0].
	
	oldChildren withIndexDo: [:child :index |
		(child wantsImplicitNeighbors and: [
			oldChildren
				at: index + 1
				ifPresent: [:nextChild | nextChild wantsImplicitNeighbors]
				ifAbsent: [true]]) ifTrue: [addImplicitChild value: index]].
	
	[implicitChildrenCount < implicitChildrenIndices size] whileTrue: [addImplicitChild value: oldChildren size]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self.
	self children do: [:child | child addToWorld: aWorld]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> afterAddLabel: aBlock [

	aBlock
		startInput;
		queueUpdateSuggestionsFocused: true
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> bindingDict [

	^ bindingDict
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> bindingDict: aDict [

	bindingDict := aDict
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> bindingFor: aDomainBlock [

	^ self getCurrentPrimitive: aDomainBlock
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> bindingIndex [

	^ self bindingDict at: self class identityName ifAbsent: nil
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> bindingIndex: anObject [

	self labelBindingDict at: self class identityName put: (anObject isSandblock
		ifTrue: [[anObject evaluate] on: Error do: [anObject sourceString]]
		ifFalse: [anObject])
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> bindingIndexAutoCast [

	^ [:name :morph| | case |
		case := self patternContainer.
		(case notNil and: [name hasOwner: case pattern])
			ifTrue: [name behaviorClass: SBStDeclarationForVPBinding]
			ifFalse: [name behaviorClass: SBStBinding]]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> bindingIndexWithImplicitPrefix: aBoolean [

	^ self bindingIndex
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> bindingLabelBlockFrom: aString [

	^ SBStName new
		autoCast: self bindingIndexAutoCast;
		behavior: SBStDeclarationForBlock new;
		contents: aString
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> buildChildrenFromBinding: aDict [

	^ self children gather: [:pattern | pattern buildFromBinding: aDict]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> buildFromBinding: aDict [

	| output |
	output := self constant
		ifNotNil: [self constant value asDomainBlock]
		ifNil: [(aDict at: self bindingIndex) copy].
	output children: (self buildChildrenFromBinding: aDict).
	output addPropertyMappings: self expressionMappings.
	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName | output addPropertyMapping: labelPosition -> (aDict at: bindingName)].
	^ {output}
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> buildImplicitChildren: aDict [

	| implicitChildren nextIndex oldChildren addImplicitChild |
	implicitChildren := OrderedCollection new.
	nextIndex := ((aDict collect: [:subArray | subArray size])
		ifEmpty: [0]
		ifNotEmpty: #sum) + 1.
	
	oldChildren := self children copy.
	
	addImplicitChild := [:index | | implicitChild identifier |
		identifier := self root nextIdentifier.
		implicitChild := SBEllipsisPattern bindingDict: {self class identityName -> identifier}.
		self addChild: implicitChild afterIndex: index + implicitChildren size.
		implicitChild isImplicitChild: true.
		self owner ifNotNil: [:morph | morph addMorphBack: implicitChild].
		implicitChildren add: identifier.
		nextIndex := nextIndex + 1].
	
	(self children isEmpty or: [self children first wantsImplicitNeighbors]) ifTrue: [addImplicitChild value: 0].
	
	oldChildren withIndexDo: [:child :index |
		(child wantsImplicitNeighbors and: [
			oldChildren
				at: index + 1
				ifPresent: [:nextChild | nextChild wantsImplicitNeighbors]
				ifAbsent: [true]]) ifTrue: [addImplicitChild value: index]].
	
	aDict at: self bindingIndex put: implicitChildren asArray.
	
	oldChildren do: [:child | child buildImplicitChildren: aDict]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> buildNewInstance [

	^ SBBindingPattern new
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> changeVisualizingClass [
	<action>

	UIManager default chooseClassOrTrait ifNotNil: [:class |
		self sandblockEditor do: (SBMutatePropertyCommand new
			target: self;
			selector: #visualizingClass;
			mutateSelector: #visualizingClass:;
			value: class)]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> childrenInCurrentMatch [

	| offsetSum |
	offsetSum := self children inject: 0 into: [:sum :child | sum + child indexOffset].
	^ self children size + offsetSum
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> collectBindingsInto: aCollection [

	super collectBindingsInto: aCollection.
	self blockDict keysAndValuesDo: [:position :value | (value firstSubmorphOrNil satisfies: #(#notNil #isSandblock #isName #isBlockBinding)) ifTrue: [aCollection add: value firstSubmorph]]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> constant [

	^ self expressionDict at: self class identityName ifAbsent: nil
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> convertToEllipsisPattern [
	<action>

	self convertToPatternClass: SBEllipsisPattern
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> convertToPatternClass: aClass [
	"Only suitable for conversion from ellipsis to binding and vice versa."

	self sandblockEditor do: (SBCombinedCommand newWith: {
		SBDeleteDomainBlockCommand new target: self.
		SBInsertDomainBlockCommand new
			index: self owner submorphCount + 1;
			parent: self parent;
			container: self owner;
			siblingIndex: self siblingIndex;
			morph: (aClass bindingDict: {self class identityName -> self bindingIndex} asDictionary);
			shouldMergeWithNext: false;
			yourself})
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> couldMatch: aDomainBlock [

	^ self childrenInCurrentMatch = aDomainBlock children size and: [self constant isNil or: [self constant value = aDomainBlock sourceObject]]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> domainBlockMapping [

	^ self visualizingClass ifNil: [{}] ifNotNil: #domainBlockMapping
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> domainBlockMappings [

	^ self domainBlockMapping collect: [:mappingOrAssoc |
		mappingOrAssoc isPropertyMapping
			ifTrue: [mappingOrAssoc]
			ifFalse: [SBPropertyMapping fromAssociation: mappingOrAssoc]]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> drawOn: aCanvas [

	self writeBackClosure ifNotNil: [aCanvas frameOval: (self bounds outsetBy: 5) width: 2 color: Color black].
	super drawOn: aCanvas.
	aCanvas frameRectangle: (self bounds outsetBy: 1) width: 2 color: color
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> enoughChildren: aDomainBlock [

	^ self childrenInCurrentMatch <= aDomainBlock children size
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> expressionDict [

	^ expressionDict
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> expressionDict: aDict [

	expressionDict := aDict
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> expressionMappings [

	^ self labelExpressionDict associations collect: [:association |
		SBPropertyMappingExpression
			expression: association value
			vpProperty: association key
			originalMapping: (self originalPropertyMappingAt: association key)]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> findConstant [

	^ self constant value ifNil: [super findConstant]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> getCurrentPrimitive: aDomainBlock [

	^ aDomainBlock
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> getNext: aDomainBlock [

	| currentPrimitive |
	currentPrimitive := self getCurrentPrimitive: aDomainBlock.
	(self enoughChildren: currentPrimitive) ifTrue: [ | offset |
		offset := 0.
		self children withIndexDo: [:child :index |
			((child getNext: (child searchRootFor: currentPrimitive at: index + offset)) and: [self enoughChildren: currentPrimitive])
				ifTrue: [^ true]
				ifFalse: [child reset].
			offset := offset + child indexOffset]].
	^ false
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> identityLabelPosition [

	^ self staticDomainBlockMapping
		detect: [:mapping | mapping key = #identityLabelPosition]
		ifFound: [:mapping | mapping patternValue]
		ifNone: [#innerLabel]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> indexOffset [

	^ 0
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> initialize [

	super initialize.
	self bindingDict: Dictionary new.
	self expressionDict: Dictionary new
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> isBindingPattern [
	
	^ true
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> isTreeLayoutRoot [

	^ self parent isBindingPattern not
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> labelBindingChanged [

	self labelBindingDict copy keysAndValuesDo: [:labelPosition :bindingName |
		self labelBindingDict
			at: labelPosition
			put: ((self labelContentAt: labelPosition) as: bindingName class)]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> labelBindingDict [

	^ self bindingDict copy
		removeKey: #identity ifAbsent: [];
		yourself
]

{ #category : #accessing }
SBBindingPattern >> labelExpressionDict [

	^ self expressionDict copy
		removeKey: #identity ifAbsent: [];
		yourself
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> labelSuggestionsFor: aSBUnknownLabel [

	^ {
		SBSuggestionItem selector: self root nextIdentifier label: 'binding'.
		
		(SBBlockSuggestionItem selector: '[myVar]' label: 'variable') builder: ['[myVar]' parseAsSandblock].
		self constantSuggestionsFor: aSBUnknownLabel}
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> matches: aDomainBlock withBinding: aCollection [

	| offset |
	offset := 0.
	self labelExpressionDict keysAndValuesDo: [:position :value | (aDomainBlock propertyAt: position) = value value ifFalse: [^ false]].
	
	^ self children withIndexAllSatisfy: [:child :index | | wasSuccessful |
		wasSuccessful := child
			matches: (child searchRootFor: (self getCurrentPrimitive: aDomainBlock) at: index + offset)
			withBinding: aCollection.
		offset := offset + child indexOffset.
		wasSuccessful]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> newEmptyChildNear: aBlock before: aBoolean [

	^ self newUnknown
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> newLabelBlockAt: aVPProperty [

	^ self newUnknown
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> noteNewOwner: newOwner [

	super noteNewOwner: newOwner.
	self patternContainer ifNotNil: [self rebuild]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> originalPropertyMappingAt: aVPProperty [

	^ self domainBlockMapping
		detect: [:mapping | mapping key = aVPProperty]
		ifFound: [:mapping | mapping asPropertyMapping]
		ifNone: [nil]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> preferredColor [

	^ self color
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> rebuild [

	self blockPositions do: [:position | (self blockDict at: position) removeAllMorphs].
	self shape: self defaultShape.
	self addPropertyMappings: self staticDomainBlockMapping.
	self addPropertyMappings: self expressionMappings.
	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName |
		(self setLabelAt: labelPosition to: (self bindingLabelBlockFrom: bindingName))
			when: #contentsChanged
			send: #labelBindingChanged
			to: self].
	self constant ifNotNil: [self setLabelAt: self identityLabelPosition to: self constant asSandblock].
	self bindingIndex ifNotNil: [
		self
			setLabelAt: self identityLabelPosition
			to: (self bindingLabelBlockFrom: self bindingIndex asString)].
	(self constant isNil and: [self bindingIndex isNil]) ifTrue: [ | unknown |
		self setLabelAt: self identityLabelPosition to: (unknown := self newUnknown).
		self sandblockEditor ifNotNil: [unknown startInput]]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> reset [

	self resetChildren
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> resetChildren [

	self children do: [:child | child reset]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> searchRootFor: aDomainBlock at: anIndex [

	^ self indexOffset < 0
		ifTrue: [aDomainBlock]
		ifFalse: [aDomainBlock children at: anIndex]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> setBindingFor: aDomainBlock in: aDict [

	| currentPrimitive setBinding |
	setBinding := [:bindingName :binding |
		aDict
			at: bindingName
			ifPresent: [:previousValue | previousValue = binding ifFalse: [^ false]]
			ifAbsent: [aDict at: bindingName put: binding]].
	currentPrimitive := self getCurrentPrimitive: aDomainBlock.
	self bindingIndex ifNotNil: [setBinding value: self bindingIndex value: (self bindingFor: aDomainBlock)].
	self setLabelBindingsFor: aDomainBlock in: aDict using: setBinding.
	self writeBackClosure ifNotNil: [self writeBackClosure value: currentPrimitive sourceObject].
	^ (self couldMatch: currentPrimitive) and: [self setChildBindingFor: currentPrimitive in: aDict]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> setChildBindingFor: aDomainBlock in: aDict [

	| offset |
	offset := 0.
	^ self children withIndexAllSatisfy: [:child :index | | wasSuccessful |
		wasSuccessful := child
			setBindingFor: (child searchRootFor: (self getCurrentPrimitive: aDomainBlock) at: index + offset)
			in: aDict.
		offset := offset + child indexOffset.
		wasSuccessful]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> setLabelBindingsFor: aDomainBlock in: aDict using: aBlockClosure [

	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName | aBlockClosure value: bindingName value: (aDomainBlock propertyAt: labelPosition)]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> staticDomainBlockMapping [

	^ self domainBlockMappings select: [:mapping | mapping patternValue notNil]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> supportsLabels [

	^ true
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> valueFromPropertyMapping: aPropertyMapping [

	^ aPropertyMapping patternValue
]

{ #category : #accessing }
SBBindingPattern >> visualizingClass [

	^ visualizingClass ifNil: [self patternContainer ifNotNil: #defaultVisualizationClass]
]

{ #category : #accessing }
SBBindingPattern >> visualizingClass: aClass [

	visualizingClass := aClass.
	self owner ifNotNil: [self rebuild]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> writeBackClosure [

	^ writeBackClosure
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> writeBackClosure: anObject [

	writeBackClosure := anObject isSandblock
		ifTrue: [ | variableBlock |
			variableBlock := anObject statements first receiver copy.
			self innerLabel: variableBlock.
			self writeBackClosureString: anObject sourceString.
			anObject evaluate]
		ifFalse: [anObject]
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> writeBackClosureString [

	^ writeBackClosureString
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> writeBackClosureString: aString [

	writeBackClosureString := aString
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> writeDict: aDict on: aStream using: aBlock [

	aStream nextPut: ${.
	aDict keysAndValuesDo: [:key :value |
		key = self identityLabelPosition
			ifTrue: [self class identityName storeOn: aStream]
			ifFalse: [key storeOn: aStream].
		aStream nextPutAll: ' -> ('.
		aBlock value: key value: value.
		aStream nextPutAll: ').'].
	aStream nextPut: $}
]

{ #category : #'as yet unclassified' }
SBBindingPattern >> writeSourceOn: aStream [

	| bindings expressions staticMapping |
	staticMapping := self staticDomainBlockMapping.
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
			value firstSubmorph isName
				ifTrue: [bindings at: position put: value firstSubmorph]
				ifFalse: [expressions at: position put: value firstSubmorph]]].
	
	self writeBackClosure ifNotNil: [
		aStream
			nextPutAll: ' writeBackClosure: ';
			nextPutAll: self writeBackClosureString].
	
	bindings ifNotEmpty: [
		aStream nextPutAll: ' bindingDict: '.
		self writeDict: bindings on: aStream using: [:key :value | value contents asSymbol storeOn: aStream]].
	
	expressions ifNotEmpty: [
		aStream nextPutAll: ' expressionDict: '.
		self writeDict: expressions on: aStream using: [:key :value |
			value isBlockBody ifTrue: [value writeSourceOn: aStream] ifFalse: [
				(self originalPropertyMappingAt: key)
					ifNil: [aStream nextPutAll: '[]']
					ifNotNil: [:mapping | mapping writeExpression: value on: aStream]]]].
	
	self children ifNotEmpty: [
		aStream nextPutAll: ' children: {'.
		(self children reject: [:child | child isImplicitChild]) do: [:child |
			child writeSourceOn: aStream.
			aStream nextPut: $.].
		aStream nextPut: $}].
	
	self visualizingClass ifNotNil: [
		aStream
			nextPutAll: ' visualizingClass: ';
			store: self visualizingClass].
	aStream nextPut: $)
]
