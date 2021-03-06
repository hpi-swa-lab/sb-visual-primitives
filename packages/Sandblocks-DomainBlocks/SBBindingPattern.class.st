"
An SBBindingPattern is used to represent a single object. It's patternChildren are visualized as well recursively.

Instance Variables
	bindingDict:			Dictionary
	expressionDict:	Dictionary
	visualizingClass:	Class

bindingDict
	- dictionary of label positions and their bindings

expressionDict
	- dictionary of label positions and their values

visualizingClass
	- the class to be visualized
"
Class {
	#name : #SBBindingPattern,
	#superclass : #SBDomainBlock,
	#instVars : [
		'bindingDict',
		'expressionDict',
		'visualizingClass'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #replacements }
SBBindingPattern class >> bindingDict: aDict [

	^ self new bindingDict: aDict asDictionary
]

{ #category : #replacements }
SBBindingPattern class >> bindingDict: aDict expressionDict: anotherDict [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary
]

{ #category : #replacements }
SBBindingPattern class >> bindingDict: aDict expressionDict: anotherDict patternChildren: aCollection [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary;
		patternChildren: aCollection
]

{ #category : #replacements }
SBBindingPattern class >> bindingDict: aDict expressionDict: anotherDict patternChildren: aCollection visualizingClass: aClass [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary;
		patternChildren: aCollection;
		visualizingClass: aClass
]

{ #category : #replacements }
SBBindingPattern class >> bindingDict: aDict expressionDict: anotherDict visualizingClass: aClass [

	^ self new
		bindingDict: aDict asDictionary;
		expressionDict: anotherDict asDictionary;
		visualizingClass: aClass
]

{ #category : #replacements }
SBBindingPattern class >> bindingDict: aDict patternChildren: aCollection [

	^ self new
		bindingDict: aDict asDictionary;
		patternChildren: aCollection
]

{ #category : #replacements }
SBBindingPattern class >> bindingDict: aDict patternChildren: aCollection visualizingClass: aClass [

	^ self new
		bindingDict: aDict asDictionary;
		patternChildren: aCollection;
		visualizingClass: aClass
]

{ #category : #replacements }
SBBindingPattern class >> bindingDict: aDict visualizingClass: aClass [

	^ self new
		bindingDict: aDict asDictionary;
		visualizingClass: aClass
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> defaultVisualizedAs: aClass [

	^ SBBindingPattern new visualizingClass: aClass
]

{ #category : #replacements }
SBBindingPattern class >> expressionDict: aDict [

	^ self new expressionDict: aDict asDictionary
]

{ #category : #replacements }
SBBindingPattern class >> expressionDict: aDict bindingDict: anotherDict [

	^ self new
		expressionDict: aDict asDictionary;
		bindingDict: anotherDict asDictionary
]

{ #category : #replacements }
SBBindingPattern class >> expressionDict: aDict bindingDict: anotherDict visualizingClass: aClass [

	^ self new
		expressionDict: aDict asDictionary;
		bindingDict: anotherDict asDictionary;
		visualizingClass: aClass
]

{ #category : #replacements }
SBBindingPattern class >> expressionDict: aDict patternChildren: aCollection [

	^ self new
		expressionDict: aDict asDictionary;
		patternChildren: aCollection
]

{ #category : #replacements }
SBBindingPattern class >> expressionDict: aDict patternChildren: aCollection visualizingClass: aClass [

	^ self new
		expressionDict: aDict asDictionary;
		patternChildren: aCollection;
		visualizingClass: aClass
]

{ #category : #replacements }
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

	^ (({#bindingDict:. #expressionDict:. #bindingDict:expressionDict:} gather: [:symbol | {symbol. symbol, #patternChildren:}]) gather: [:symbol | {symbol. symbol, #visualizingClass:}]) anySatisfy: [:methodName | self selector: methodName receiverMatches: aBlock]
]

{ #category : #'as yet unclassified' }
SBBindingPattern class >> newFor: aBlock [

	| selectors arguments |
	selectors := aBlock selector findTokens: ':'.
	arguments := aBlock arguments with: selectors collect: [:argument :selector |
		selector = 'patternChildren' ifTrue: [argument childSandblocks] ifFalse: [
			selector = 'writeBackClosure'
				ifTrue: [argument]
				ifFalse: [[argument evaluate] on: Error do: [{self identityName -> aBlock sourceString}]]]].
	
	^ self perform: aBlock selector asSymbol withArguments: arguments
]

{ #category : #'adding/removing' }
SBBindingPattern >> addImplicitChildWithIdentifier: aString at: aNumber [

	| implicitChild |
	implicitChild := SBEllipsisPattern bindingDict: {self class identityName -> aString}.
	self addChild: implicitChild afterIndex: aNumber.
	implicitChild isImplicitChild: true.
	self owner ifNotNil: [:morph | morph addMorphBack: implicitChild]
]

{ #category : #'adding/removing' }
SBBindingPattern >> addImplicitChildren: aDict [

	| addImplicitChild implicitChildrenCount implicitChildrenIndices oldChildren |
	self patternChildren do: [:child | child addImplicitChildren: aDict].
	implicitChildrenIndices := aDict at: self bindingName ifAbsent: [^ self].
	implicitChildrenCount := 0.
	
	addImplicitChild := [:index |
		implicitChildrenCount >= implicitChildrenIndices size ifTrue: [^ self].
		(self patternChildren notEmpty and: [self patternChildren last wantsImplicitNeighbors not]) ifFalse: [
			self
				addImplicitChildWithIdentifier: (implicitChildrenIndices at: implicitChildrenCount + 1)
				at: index + implicitChildrenCount].
		implicitChildrenCount := implicitChildrenCount + 1].
	
	oldChildren := self patternChildren copy.
	(self patternChildren isEmpty or: [self patternChildren first wantsImplicitNeighbors]) ifTrue: [addImplicitChild value: 0].
	
	self updateChildren: oldChildren with: addImplicitChild.
	
	[implicitChildrenCount < implicitChildrenIndices size] whileTrue: [addImplicitChild value: oldChildren size]
]

{ #category : #'initialize-release' }
SBBindingPattern >> addToWorld: aWorld [

	aWorld addMorphBack: self.
	self patternChildren do: [:child | child addToWorld: aWorld]
]

{ #category : #'adding/removing' }
SBBindingPattern >> afterAddLabel: aBlock [

	aBlock
		startInput;
		queueUpdateSuggestionsFocused: true
]

{ #category : #accessing }
SBBindingPattern >> bindingDict [

	^ bindingDict
]

{ #category : #accessing }
SBBindingPattern >> bindingDict: aDict [

	bindingDict := aDict
]

{ #category : #accessing }
SBBindingPattern >> bindingFor: aDomainBlock [

	^ self getCurrentDomainBlock: aDomainBlock
]

{ #category : #accessing }
SBBindingPattern >> bindingLabelBlockFrom: aString [

	^ SBStName new
		autoCast: self bindingNameAutoCast;
		behavior: SBStDeclarationForBlock new;
		contents: aString
]

{ #category : #accessing }
SBBindingPattern >> bindingName [

	^ self bindingDict at: self class identityName ifAbsent: nil
]

{ #category : #accessing }
SBBindingPattern >> bindingName: anObject [

	self labelBindingDict at: self class identityName put: (anObject isSandblock
		ifTrue: [[anObject evaluate] on: Error do: [anObject sourceString]]
		ifFalse: [anObject])
]

{ #category : #'initialize-release' }
SBBindingPattern >> bindingNameAutoCast [

	^ [:name :morph | | container |
		container := self patternContainer.
		(container notNil and: [name hasOwner: container pattern])
			ifTrue: [name behaviorClass: SBStDeclarationForDBBinding]
			ifFalse: [name behaviorClass: SBStBinding]]
]

{ #category : #accessing }
SBBindingPattern >> bindingNameWithImplicitPrefix: aBoolean [

	^ self bindingName
]

{ #category : #'pattern matching' }
SBBindingPattern >> buildChildrenFromBinding: aDict [

	^ self patternChildren gather: [:pattern | pattern buildFromBinding: aDict]
]

{ #category : #'pattern matching' }
SBBindingPattern >> buildFromBinding: aDict [

	| output |
	output := self constant
		ifNotNil: [self constant value asDomainBlock]
		ifNil: [(aDict at: self bindingName) copy].
	output patternChildren: (self buildChildrenFromBinding: aDict).
	output addPropertyMappings: self expressionMappings.
	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName | output addPropertyMapping: labelPosition -> (aDict at: bindingName)].
	^ {output}
]

{ #category : #'pattern matching' }
SBBindingPattern >> buildImplicitChildren: aDict [

	| addImplicitChild implicitChildren oldChildren |
	implicitChildren := OrderedCollection new.
	oldChildren := self patternChildren copy.
	
	addImplicitChild := [:index | | identifier |
		identifier := self patternContainer nextIdentifier.
		self addImplicitChildWithIdentifier: identifier at: index + implicitChildren size.
		implicitChildren add: identifier].
	
	(self patternChildren isEmpty or: [self patternChildren first wantsImplicitNeighbors]) ifTrue: [addImplicitChild value: 0].
	
	(self updateChildren: oldChildren with: addImplicitChild) do: [:child | child buildImplicitChildren: aDict].
	
	aDict at: self bindingName put: implicitChildren asArray
]

{ #category : #actions }
SBBindingPattern >> buildNewInstance [

	^ SBBindingPattern new
]

{ #category : #accessing }
SBBindingPattern >> canDeleteChild: aBlock [

	^ true
]

{ #category : #actions }
SBBindingPattern >> changeVisualizingClass [
	<action>

	UIManager default chooseClassOrTrait ifNotNil: [:class |
		self sandblockEditor do: (SBMutatePropertyCommand new
			target: self;
			selector: #visualizingClass;
			mutateSelector: #visualizingClass:;
			value: class)]
]

{ #category : #accessing }
SBBindingPattern >> childrenInCurrentMatch [

	| offsetSum |
	offsetSum := self patternChildren
		inject: 0
		into: [:sum :child | sum + child indexOffset].
	^ self patternChildren size + offsetSum
]

{ #category : #'pattern matching' }
SBBindingPattern >> collectBindingsInto: aCollection [

	self patternChildren do: [:child | child collectBindingsInto: aCollection].
	self blockDict keysAndValuesDo: [:position :value | (value firstSubmorphOrNil satisfies: #(#notNil #isSandblock #isName #isBlockBinding)) ifTrue: [aCollection add: value firstSubmorph]]
]

{ #category : #'pattern matching' }
SBBindingPattern >> collectIdentityBindingsInto: aCollection [

	self patternChildren do: [:child | child collectBindingsInto: aCollection].
	(self blockDict at: self identityLabelPosition ifAbsent: [nil]) firstSubmorphOrNil ifNotNil: [:bindingIndex | aCollection add: bindingIndex]
]

{ #category : #accessing }
SBBindingPattern >> constant [

	^ self expressionDict at: self class identityName ifAbsent: nil
]

{ #category : #actions }
SBBindingPattern >> convertToEllipsisPattern [
	<action>

	self convertToPatternClass: SBEllipsisPattern
]

{ #category : #converting }
SBBindingPattern >> convertToPatternClass: aClass [
	"Only suitable for conversion from ellipsis to binding and vice versa."

	self sandblockEditor do: (SBCombinedCommand newWith: {
		SBDeleteSubtreeCommand new target: self.
		SBInsertDomainBlockCommand new
			index: self owner submorphCount + 1;
			patternParent: self patternParent;
			container: self owner;
			patternSiblingIndex: self patternSiblingIndex;
			morph: (aClass bindingDict: {self class identityName -> self bindingName} asDictionary);
			shouldMergeWithNext: false;
			yourself})
]

{ #category : #actions }
SBBindingPattern >> convertToWildcardPattern [
	<action>

	self convertToPatternClass: SBWildcardPattern
]

{ #category : #'pattern matching' }
SBBindingPattern >> couldMatch: aDomainBlock [

	^ self childrenInCurrentMatch = aDomainBlock patternChildren size and: [self constant isNil or: [self constant value = aDomainBlock sourceObject]]
]

{ #category : #accessing }
SBBindingPattern >> domainBlockMapping [

	^ self visualizingClass ifNil: [{}] ifNotNil: #domainBlockMapping
]

{ #category : #accessing }
SBBindingPattern >> domainBlockMappings [

	^ self domainBlockMapping collect: [:mappingOrAssoc |
		mappingOrAssoc isPropertyMapping
			ifTrue: [mappingOrAssoc]
			ifFalse: [SBPropertyMapping fromAssociation: mappingOrAssoc]]
]

{ #category : #accessing }
SBBindingPattern >> enoughChildren: aDomainBlock [

	^ self childrenInCurrentMatch <= aDomainBlock patternChildren size
]

{ #category : #accessing }
SBBindingPattern >> expressionDict [

	^ expressionDict
]

{ #category : #accessing }
SBBindingPattern >> expressionDict: aDict [

	expressionDict := aDict
]

{ #category : #accessing }
SBBindingPattern >> expressionMappings [

	^ self labelExpressionDict associations collect: [:association |
		SBPropertyMappingExpression
			expression: association value
			dbProperty: association key
			originalMapping: (self originalPropertyMappingAt: association key)]
]

{ #category : #accessing }
SBBindingPattern >> findConstant [

	^ self constant value ifNil: [
		self patternChildren do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
		nil]
]

{ #category : #'pattern matching' }
SBBindingPattern >> findOriginRoot [

	^ self findConstant asDomainBlock patternRoot sourceObject
]

{ #category : #'pattern matching' }
SBBindingPattern >> getCurrentDomainBlock: aDomainBlock [

	^ aDomainBlock
]

{ #category : #'pattern matching' }
SBBindingPattern >> getNext: aDomainBlock [
	"Updates the domain block the pattern will bind to and returns whether a new binding was found. Whether the binding is correct needs to be checked with matches: withBinding:."

	| currentDomainBlock |
	currentDomainBlock := self getCurrentDomainBlock: aDomainBlock.
	(self enoughChildren: currentDomainBlock) ifTrue: [ | offset |
		offset := 0.
		self patternChildren withIndexDo: [:child :index |
			((child getNext: (child searchRootFor: currentDomainBlock at: index + offset)) and: [self enoughChildren: currentDomainBlock])
				ifTrue: [^ true]
				ifFalse: [child reset].
			offset := offset + child indexOffset]].
	^ false
]

{ #category : #accessing }
SBBindingPattern >> identityLabelPosition [

	^ self staticDomainBlockMapping
		detect: [:mapping | mapping key = #identityLabelPosition]
		ifFound: [:mapping | mapping patternValue]
		ifNone: [#innerLabel]
]

{ #category : #accessing }
SBBindingPattern >> indexOffset [

	^ 0
]

{ #category : #'initialize-release' }
SBBindingPattern >> initialize [

	super initialize.
	self bindingDict: Dictionary new.
	self expressionDict: Dictionary new
]

{ #category : #'*Sandblocks-DomainBlocks' }
SBBindingPattern >> isBindingPattern [

	^ true
]

{ #category : #accessing }
SBBindingPattern >> isImplicitChild [

	^ false
]

{ #category : #accessing }
SBBindingPattern >> isPatternBlock [

	^ true
]

{ #category : #accessing }
SBBindingPattern >> isTreeLayoutRoot [

	^ self patternParent isBindingPattern not
]

{ #category : #accessing }
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

{ #category : #accessing }
SBBindingPattern >> labelSuggestionsFor: aSBUnknownLabel [

	^ {
		SBSuggestionItem selector: self patternContainer nextIdentifier label: 'binding'.
		
		(SBBlockSuggestionItem selector: '[myVar]' label: 'variable') builder: ['[myVar]' parseAsSandblock].
		self constantSuggestionsFor: aSBUnknownLabel}
]

{ #category : #'pattern matching' }
SBBindingPattern >> matches: aDomainBlock withBinding: aCollection [

	| offset |
	offset := 0.
	self labelExpressionDict keysAndValuesDo: [:position :value | (aDomainBlock propertyAt: position) = value value ifFalse: [^ false]].
	
	^ self patternChildren withIndexAllSatisfy: [:child :index | | wasSuccessful |
		wasSuccessful := child
			matches: (child searchRootFor: (self getCurrentDomainBlock: aDomainBlock) at: index + offset)
			withBinding: aCollection.
		offset := offset + child indexOffset.
		wasSuccessful]
]

{ #category : #accessing }
SBBindingPattern >> newEmptyChildNear: aBlock before: aBoolean [

	^ self newUnknown
]

{ #category : #accessing }
SBBindingPattern >> newLabelBlockAt: aDBProperty [

	^ self newUnknown
]

{ #category : #callbacks }
SBBindingPattern >> noteNewOwner: newOwner [

	super noteNewOwner: newOwner.
	self rebuild
]

{ #category : #accessing }
SBBindingPattern >> originalPropertyMappingAt: aDomainBlockProperty [

	^ self domainBlockMapping
		detect: [:mapping | mapping key = aDomainBlockProperty]
		ifFound: [:mapping | mapping asPropertyMapping]
		ifNone: [nil]
]

{ #category : #'pattern hierarchy' }
SBBindingPattern >> patternParent [

	self owner ifNil: [^ nil].
	super patternParent ifNotNil: [:parent | ^ parent].
	^ self owner owner isPatternBlock ifTrue: [self owner owner]
]

{ #category : #accessing }
SBBindingPattern >> preferredColor [

	^ self color
]

{ #category : #'initialize-release' }
SBBindingPattern >> rebuild [

	self blockPositions do: [:position | (self blockDict at: position) removeAllMorphs].
	self blockDict at: #innerLabel put: nil.
	self shape: self defaultShape.
	self addPropertyMappings: self staticDomainBlockMapping.
	self addPropertyMappings: self expressionMappings.
	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName | self setLabelAt: labelPosition to: (self bindingLabelBlockFrom: bindingName)].
	self constant ifNotNil: [self setLabelAt: self identityLabelPosition to: self constant asSandblock].
	self bindingName ifNotNil: [
		self
			setLabelAt: self identityLabelPosition
			to: (self bindingLabelBlockFrom: self bindingName asString)].
	(self constant isNil and: [self bindingName isNil]) ifTrue: [ | unknown |
		self setLabelAt: self identityLabelPosition to: (unknown := self newUnknown).
		self sandblockEditor ifNotNil: [unknown startInput]]
]

{ #category : #'adding/removing' }
SBBindingPattern >> removeImplicitChildren [

	self patternChildren select: #isImplicitChild thenDo: #delete.
	self allConnections do: #checkAutoDelete.
	self patternChildren do: #removeImplicitChildren
]

{ #category : #'initialize-release' }
SBBindingPattern >> reset [

	self resetChildren
]

{ #category : #'initialize-release' }
SBBindingPattern >> resetChildren [

	self patternChildren do: [:child | child reset]
]

{ #category : #accessing }
SBBindingPattern >> searchRootFor: aDomainBlock at: anIndex [

	^ self indexOffset < 0
		ifTrue: [aDomainBlock]
		ifFalse: [aDomainBlock patternChildren at: anIndex]
]

{ #category : #accessing }
SBBindingPattern >> setBindingFor: aDomainBlock in: aDict [

	| currentDomainBlock setBinding |
	setBinding := [:bindingName :binding |
		aDict
			at: bindingName
			ifPresent: [:previousValue | previousValue = binding ifFalse: [^ false]]
			ifAbsent: [aDict at: bindingName put: binding]].
	currentDomainBlock := self getCurrentDomainBlock: aDomainBlock.
	self bindingName ifNotNil: [setBinding value: self bindingName value: (self bindingFor: aDomainBlock)].
	self setLabelBindingsFor: aDomainBlock in: aDict using: setBinding.
	^ (self couldMatch: currentDomainBlock) and: [self setChildBindingFor: currentDomainBlock in: aDict]
]

{ #category : #accessing }
SBBindingPattern >> setChildBindingFor: aDomainBlock in: aDict [

	| offset |
	offset := 0.
	^ self patternChildren withIndexAllSatisfy: [:child :index | | wasSuccessful |
		wasSuccessful := child
			setBindingFor: (child searchRootFor: (self getCurrentDomainBlock: aDomainBlock) at: index + offset)
			in: aDict.
		offset := offset + child indexOffset.
		wasSuccessful]
]

{ #category : #accessing }
SBBindingPattern >> setLabelBindingsFor: aDomainBlock in: aDict using: aBlockClosure [

	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName | aBlockClosure value: bindingName value: (aDomainBlock propertyAt: labelPosition)]
]

{ #category : #accessing }
SBBindingPattern >> staticDomainBlockMapping [

	^ self domainBlockMappings select: [:mapping | mapping patternValue notNil]
]

{ #category : #updating }
SBBindingPattern >> updateChildren: aCollection with: aBlockClosure [

	aCollection withIndexDo: [:child :index |
		(child wantsImplicitNeighbors and: [
			aCollection
				at: index + 1
				ifPresent: [:nextChild | nextChild wantsImplicitNeighbors]
				ifAbsent: [true]]) ifTrue: [aBlockClosure value: index]].
	^ aCollection
]

{ #category : #accessing }
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

{ #category : #accessing }
SBBindingPattern >> visualizingClassBasic [

	^ visualizingClass
]

{ #category : #accessing }
SBBindingPattern >> wantsImplicitNeighbors [

	^ true
]

{ #category : #printing }
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

{ #category : #printing }
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
	
	self patternChildren ifNotEmpty: [
		aStream nextPutAll: ' patternChildren: {'.
		(self patternChildren reject: [:child | child isImplicitChild]) do: [:child |
			child writeSourceOn: aStream.
			aStream nextPut: $.].
		aStream nextPut: $}].
	
	self visualizingClassBasic ifNotNil: [
		aStream
			nextPutAll: ' visualizingClass: ';
			store: self visualizingClassBasic].
	aStream nextPut: $)
]
