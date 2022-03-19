"
An SBDomainBlock is the visual representation of an object. It can also be used to display various patterns. When originating from an object, this object's class domainBlockMapping will be used as a directive on how to map from object properties to properties of the visual primitive (vpProperty). 
See SBPropertyMappings for the different ways of mapping.

Instance Variables
	blockDict:				Dictionary
	sourceObject:			Object

blockDict
	- (#blockPosition -> SBBlock)
	- stores the blocks that the labels or shape blocks are inserted into

sourceObject
	- the object the primitive is build for
	- may be nil if the SBDomainBlock is a pattern

"
Class {
	#name : #SBDomainBlock,
	#superclass : #SBStSubstitution,
	#instVars : [
		'blockDict',
		'sourceObject'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBDomainBlock class >> buildTree: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(self new: element key) patternChildren: (self buildTree: element value)]
			ifFalse: [self new: element]]
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> matches: aBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> newFromObject: anObject [

	| domainBlock |
	domainBlock := self new.
	domainBlock sourceObject: anObject.
	domainBlock addPropertyMappings: anObject class domainBlockMapping.
	^ domainBlock
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> newFromObject: anObject in: aMorph [

	| domainBlock |
	domainBlock := self new.
	aMorph addMorphBack: domainBlock.
	domainBlock sourceObject: anObject.
	domainBlock addPropertyMappings: anObject class domainBlockMapping.
	^ domainBlock
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> registerShortcuts: aProvider [

	aProvider
		registerShortcut: Character space do: #addNewChild;
		registerShortcut: Character space shift do: #addNewParent
]

{ #category : #'as yet unclassified' }
SBDomainBlock class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #'adding/removing' }
SBDomainBlock >> addChild: aDomainBlock [

	self addChild: aDomainBlock afterIndex: self patternChildren size
]

{ #category : #'adding/removing' }
SBDomainBlock >> addChild: aDomainBlock afterIndex: aNumber [

	aDomainBlock patternParent ifNotNil: [aDomainBlock patternParent removeChild: aDomainBlock].
	self addConnectorLineTo: aDomainBlock afterIndex: aNumber
]

{ #category : #'adding/removing' }
SBDomainBlock >> addConnectorLineTo: aDomainBlock afterIndex: aNumber [

	| connector previousConnector |
	self canCreateConnectors
		ifTrue: [
			connector := (SBDomainBlockConnector
				connect: self
				align: #bottom
				to: aDomainBlock
				align: #top)
				connectorType: #line;
				lineWidth: 1;
				color: Color black.
			aNumber = 0 ifTrue: [self owner addMorphFront: connector] ifFalse: [
				previousConnector := (Array streamContents: [:stream | self outgoingConnectionsDo: [:m | stream nextPut: m]]) at: aNumber.
				self owner addMorph: connector after: previousConnector].
			self owner addMorph: aDomainBlock]
		ifFalse: [
			self flag: #TODO.
			"Consider index here. Would be nice but probably doesn't actually change anything"
			self attachDecorator: (SBFutureConnectionDecorator new to: aDomainBlock)]
]

{ #category : #actions }
SBDomainBlock >> addLabel [
	<action>
	<actionValidIf: #supportsLabels>

	| index notSetProperties |
	notSetProperties := self missingProperties.
	index := UIManager default chooseFrom: (notSetProperties collect: [:propertyMapping | propertyMapping name]).
	index > 0 ifTrue: [ | dbProperty newBlock |
		dbProperty := (notSetProperties at: index) dbProperty.
		self sandblockEditor do: (SBDoItCommand new
			do: [
				self setLabelAt: dbProperty to: (newBlock := self newLabelBlockAt: dbProperty).
				self afterAddLabel: newBlock.
				newBlock];
			undo: [self removeLabelAt: dbProperty])]
]

{ #category : #actions }
SBDomainBlock >> addNewChild [
	<action>

	| newChild |
	self sandblockEditor do: (SBInsertDomainBlockCommand new
		index: self owner submorphCount + 1;
		patternParent: self;
		container: self owner;
		morph: (newChild := self buildNewInstance);
		shouldMergeWithNext: false;
		yourself).
	newChild inputContainedUnknown
]

{ #category : #actions }
SBDomainBlock >> addNewParent [
	<action>

	| newChild |
	self sandblockEditor do: (SBInsertDomainBlockCommand new
		index: self owner submorphCount + 1;
		patternParent: self patternParent;
		container: self owner;
		patternSiblingIndex: self patternSiblingIndex;
		patternChildren: {self};
		morph: (newChild := self buildNewInstance);
		shouldMergeWithNext: false;
		yourself).
	newChild inputContainedUnknown
]

{ #category : #'adding/removing' }
SBDomainBlock >> addPropertyMapping: anSBPropertyMapping [

	| value propertyMapping newChild |
	propertyMapping := anSBPropertyMapping asPropertyMapping.
	value := self valueFromPropertyMapping: propertyMapping.
	
	propertyMapping dbProperty
		caseOf: {
			[#shape] -> [self shape: (propertyMapping getMorphForValue: value)].
			[#patternChildren] -> [
				self patternChildren: OrderedCollection new.
				value do: [:child |
					newChild := self owner
						ifNil: [child asDomainBlock]
						ifNotNil: [SBDomainBlock newFromObject: child in: self owner].
					self addChild: newChild]]}
		otherwise: [(self labelPositions includes: propertyMapping dbProperty) ifTrue: [(self blockDict at: propertyMapping dbProperty) addDBLabel: (propertyMapping getMorphFor: self sourceObject)]]
]

{ #category : #'adding/removing' }
SBDomainBlock >> addPropertyMappings: aCollection [

	aCollection do: [:mappingEntry | self addPropertyMapping: mappingEntry]
]

{ #category : #'adding/removing' }
SBDomainBlock >> addToWorld: aWorld [

	^ self subclassResponsibility
]

{ #category : #'adding/removing' }
SBDomainBlock >> afterAddLabel: aBlock [

	
]

{ #category : #utilities }
SBDomainBlock >> allChildrenDo: aBlock [

	aBlock value: self.
	self patternChildren do: [:child | child allChildrenDo: aBlock]
]

{ #category : #'*Sandblocks-DomainBlocks' }
SBDomainBlock >> asDomainBlock [

	^ self
]

{ #category : #accessing }
SBDomainBlock >> blockDict [

	^ blockDict
]

{ #category : #accessing }
SBDomainBlock >> blockDict: aDict [

	blockDict := aDict
]

{ #category : #accessing }
SBDomainBlock >> blockPositions [

	^ self topLabelPositions, self middleBlockPositions, self bottomLabelPositions
]

{ #category : #accessing }
SBDomainBlock >> bottomLabelPositions [

	^ {#bottomLeftLabel. #bottomCenterLabel. #bottomRightLabel}
]

{ #category : #initialization }
SBDomainBlock >> buildNewInstance [

	^ self sourceObject
		ifNotNil: [self sourceObject class new asDomainBlock]
		ifNil: [self class new]
]

{ #category : #initialization }
SBDomainBlock >> buildObject [

	| anObject |
	anObject := self sourceObject copy.
	anObject class domainBlockMapping do: [:propertyMapping |
		(propertyMapping isPropertyMapping
			ifFalse: [SBPropertyMapping fromAssociation: propertyMapping]
			ifTrue: [propertyMapping]) setter
			value: anObject
			value: self].
	
	^ anObject
]

{ #category : #testing }
SBDomainBlock >> canCreateConnectors [

	^ self patternParent notNil or: [(self ownerThatIsA: SBDomainBlockContainer) notNil]
]

{ #category : #accessing }
SBDomainBlock >> centerChild [

	^ self patternChildren
		ifEmpty: [nil]
		ifNotEmpty: [self patternChildren at: self patternChildren size + 1 / 2]
]

{ #category : #accessing }
SBDomainBlock >> constantSuggestionsFor: anSBUnknownLabel [

	| dbProperty suggestionConstant constantString suggestionConstantBlock |
	dbProperty := self labelPositionOf: anSBUnknownLabel.
	suggestionConstant := self suggestionConstantAt: dbProperty.
	suggestionConstantBlock := self suggestionConstantBlockAt: dbProperty.
	constantString := String streamContents: [:stream |
		stream
			nextPut: $[;
			store: suggestionConstant;
			nextPut: $]].
	^ (SBBlockSuggestionItem selector: constantString label: 'constant') builder: [suggestionConstantBlock]
]

{ #category : #layout }
SBDomainBlock >> defaultShape [

	^ CircleMorph new layoutInset: 4
]

{ #category : #actions }
SBDomainBlock >> deleteBlock [

	self sandblockEditor do: (SBDeleteSubtreeCommand new target: self)
]

{ #category : #accessing }
SBDomainBlock >> domainBlockMappingAt: aSymbol [

	^ self domainBlockMappings
		detect: [:mapping | mapping key = aSymbol]
		ifFound: [:mapping | mapping asPropertyMapping]
		ifNone: [nil]
]

{ #category : #accessing }
SBDomainBlock >> domainBlockMappings [

	^ self sourceObject class domainBlockMapping collect: [:mappingOrAssoc |
		mappingOrAssoc isPropertyMapping
			ifTrue: [mappingOrAssoc]
			ifFalse: [SBPropertyMapping fromAssociation: mappingOrAssoc]]
]

{ #category : #accessing }
SBDomainBlock >> getLabelMorph: anObject [

	^ (anObject isString or: [anObject isNumber])
		ifTrue: [SBTextBubble new contents: anObject asString]
		ifFalse: [anObject]
]

{ #category : #initialization }
SBDomainBlock >> initialize [

	super initialize.
	
	self
		blockDict: Dictionary new;
		initializeLabelBlocks;
		shape: self defaultShape.
	self blockDict at: #innerLabel put: self shape.
	
	self
		addAllMorphs: {
			SBRow new
				addAllMorphs: (self topLabelPositions collect: [:position | self blockDict at: position]);
				hResizing: #spaceFill.
			SBRow new
				addAllMorphs: (self middleBlockPositions collect: [:position | self blockDict at: position]);
				cellPositioning: #center;
				hResizing: #spaceFill;
				yourself.
			SBRow new
				addAllMorphs: (self bottomLabelPositions collect: [:position | self blockDict at: position]);
				hResizing: #spaceFill};
		changeTableLayout;
		shrinkWrap
]

{ #category : #initialization }
SBDomainBlock >> initializeLabelBlocks [

	self blockPositions do: [:blockPosition |
		self blockDict at: blockPosition put: (SBColumn new
			changeTableLayout;
			vResizing: #shrinkWrap;
			hResizing: #spaceFill;
			wrapCentering: #center;
			yourself)]
]

{ #category : #accessing }
SBDomainBlock >> innerLabel [

	^ (self blockDict at: #innerLabel ifAbsent: [nil]) firstSubmorphOrNil
]

{ #category : #accessing }
SBDomainBlock >> innerLabel: aMorph [

	self shape
		removeAllMorphs;
		addMorphBack: aMorph
]

{ #category : #'*Sandblocks-DomainBlocks' }
SBDomainBlock >> isDomainBlock [

	^ true
]

{ #category : #testing }
SBDomainBlock >> isExpression [

	^ false
]

{ #category : #testing }
SBDomainBlock >> isTreeLayoutRoot [

	^ self patternParent isNil
]

{ #category : #accessing }
SBDomainBlock >> label [

	^ self innerLabel ifNotNil: [:label | label contents] ifNil: [nil]
]

{ #category : #accessing }
SBDomainBlock >> label: anObject [

	^ self innerLabel: (SBTextBubble new contents: anObject asString)
]

{ #category : #accessing }
SBDomainBlock >> labelContentAt: aSymbol [

	^ (self blockDict at: aSymbol) firstSubmorph contents
]

{ #category : #accessing }
SBDomainBlock >> labelPositionOf: aMorph [

	self blockDict keysAndValuesDo: [:position :block | (aMorph hasOwner: block) ifTrue: [^ position]].
	^ nil
]

{ #category : #accessing }
SBDomainBlock >> labelPositions [

	^ self topLabelPositions, self middleLabelPositions, self bottomLabelPositions
]

{ #category : #accessing }
SBDomainBlock >> labelSuggestionsFor: anSBUnknownLabel [

	^ {self constantSuggestionsFor: anSBUnknownLabel}
]

{ #category : #layout }
SBDomainBlock >> layoutInset [

	^ 0
]

{ #category : #accessing }
SBDomainBlock >> leftSibling [

	| index |
	self patternParent ifNil: [^ nil].
	index := self patternSiblingIndex.
	^ index > 1 ifTrue: [self patternParent patternChildren at: index - 1]
]

{ #category : #accessing }
SBDomainBlock >> middleBlockPositions [

	^ {#leftLabel. #shape. #rightLabel}
]

{ #category : #accessing }
SBDomainBlock >> middleLabelPositions [

	^ {#leftLabel. #innerLabel. #rightLabel}
]

{ #category : #accessing }
SBDomainBlock >> missingProperties [

	^ self domainBlockMappings select: [:mapping |
		(self labelPositions includes: mapping dbProperty)
			ifTrue: [
				(self blockDict
					at: mapping dbProperty
					ifPresent: [:block | block firstSubmorphOrNil]
					ifAbsent: [nil]) isNil]
			ifFalse: [false]]
]

{ #category : #accessing }
SBDomainBlock >> morphAt: aSymbol [

	(self labelPositions includes: aSymbol) ifTrue: [^ self blockDict at: aSymbol ifPresent: [:block | block firstSubmorphOrNil] ifAbsent: [nil]].
	aSymbol = #patternChildren ifTrue: [^ self patternChildren].
	aSymbol = #shape ifTrue: [^ self shape]
]

{ #category : #actions }
SBDomainBlock >> moveCursorDown [
	<action>

	self floating
		ifTrue: [self centerChild ifNotNil: #select ifNil: [self selectBottomToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorDown]
]

{ #category : #actions }
SBDomainBlock >> moveCursorLeft [
	<action>

	self floating
		ifTrue: [self leftSibling ifNotNil: #select ifNil: [self selectLeftToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorLeft]
]

{ #category : #actions }
SBDomainBlock >> moveCursorRight [
	<action>

	self floating
		ifTrue: [self rightSibling ifNotNil: #select ifNil: [self selectRightToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorRight]
]

{ #category : #actions }
SBDomainBlock >> moveCursorUp [
	<action>

	self floating
		ifTrue: [self patternParent ifNotNil: #select ifNil: [self selectTopToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorUp]
]

{ #category : #accessing }
SBDomainBlock >> newLabelBlockAt: aSymbol [

	^ self suggestionConstantBlockAt: aSymbol
]

{ #category : #initialization }
SBDomainBlock >> newUnknown [

	^ SBUnknownLabel new grammarHandler: SBStGrammarHandler new
]

{ #category : #accessing }
SBDomainBlock >> objectInterface [

	^ self patternParent objectInterfaceNear: self at: #replace
]

{ #category : #'object interface' }
SBDomainBlock >> objectInterfaceNear: aBlock at: aSymbol [

	^ {[:o | o isKindOf: SBDomainBlock]}
]

{ #category : #actions }
SBDomainBlock >> pasteReplace [
	<action>

	| position editor |
	editor := self sandblockEditor.
	position := editor cursor cursorPosition.
	editor
		copyBufferForContext: ((position isKindOf: SBCursorInsert)
			ifTrue: [position objectInterface]
			ifFalse: [self objectInterface])
		reversed: ((position isKindOf: SBCursorInsert) and: [position adjacent notNil])
		do: [:block :index :isLast |
			(position isKindOf: SBCursorInsert)
				ifTrue: [
					editor do: ((position container
						insertCommandRequest: block
						near: position adjacent
						before: position before) shouldMergeWithNext: isLast not)]
				ifFalse: [
					index = 1 ifTrue: [
						editor do: (SBCombinedCommand newWith: {
							SBDeleteSubtreeCommand new target: self.
							SBInsertDomainBlockCommand new
								index: self owner submorphCount + 1;
								patternParent: self patternParent;
								container: self owner;
								patternSiblingIndex: self patternSiblingIndex;
								morph: block;
								shouldMergeWithNext: false;
								yourself})]]]
		ifWrappingDo: [:block | self wrapSelectionWith: block]
]

{ #category : #accessing }
SBDomainBlock >> patternChildren [

	^ ((self decorators select: [:dec | dec isKindOf: SBFutureConnectionDecorator]) collect: [:dec | dec to])
		addAll: self connectedBlocks;
		yourself
]

{ #category : #accessing }
SBDomainBlock >> patternChildren: aCollection [

	self outgoingConnectionsDo: [:connector |
		connector to abandon.
		connector abandon].
	self detachDecorators: SBFutureConnectionDecorator.
	aCollection do: [:child | self addChild: child]
]

{ #category : #'pattern hierarchy' }
SBDomainBlock >> patternParent [

	self owner ifNil: [^ nil].
	self owner submorphsDo: [:sibling |
		sibling isSandblock ifTrue: [
			sibling decorators
				detect: [:dec | (dec isKindOf: SBFutureConnectionDecorator) and: [dec to = self]]
				ifFound: [:dec | ^ dec morph]
				ifNone: []]].
	self incomingConnectionsDo: [:parentPattern | ^ parentPattern from].
	^ nil
]

{ #category : #'colors and color policies' }
SBDomainBlock >> prefersNoBorder [

	^ true
]

{ #category : #printing }
SBDomainBlock >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' innerLabel: ';
		nextPutAll: self label asString
]

{ #category : #accessing }
SBDomainBlock >> propertyAt: aSymbol [

	(self labelPositions includes: aSymbol) ifTrue: [
		^ self blockDict
			at: aSymbol
			ifPresent: [:block | (self domainBlockMappingAt: aSymbol) getLabelContents: block]
			ifAbsent: [nil]].
	aSymbol = #patternChildren ifTrue: [^ self patternChildren collect: #buildObject].
	aSymbol = #shape ifTrue: [^ self shape]
]

{ #category : #'adding/removing' }
SBDomainBlock >> removeChild: aDomainBlock [

	aDomainBlock delete.
	self allConnections do: #checkAutoDelete
]

{ #category : #'adding/removing' }
SBDomainBlock >> removeLabelAt: aSymbol [

	(self blockDict at: aSymbol) removeAllMorphs
]

{ #category : #accessing }
SBDomainBlock >> rightSibling [

	| index |
	self patternParent ifNil: [^ nil].
	index := self patternSiblingIndex.
	^ self patternParent patternChildren at: index + 1 ifAbsent: [nil]
]

{ #category : #accessing }
SBDomainBlock >> setLabelAt: aSymbol to: anObject [

	| morph positionBlock |
	morph := self getLabelMorph: anObject.
	positionBlock := self blockDict at: aSymbol.
	positionBlock
		removeAllMorphs;
		addMorphBack: morph.
	^ morph
]

{ #category : #accessing }
SBDomainBlock >> shape [

	^ (self blockDict at: #shape) firstSubmorphOrNil
]

{ #category : #accessing }
SBDomainBlock >> shape: aMorph [

	| innerBlockWrapper innerBlock innerLabel |
	aMorph layoutPolicy ifNil: [
		aMorph
			changeTableLayout;
			listCentering: #center;
			wrapCentering: #center;
			shrinkWrap].
	innerBlockWrapper := self blockDict at: #shape.
	innerLabel := self innerLabel.
	self blockDict at: #innerLabel put: aMorph.
	innerBlockWrapper removeAllMorphs.
	innerBlock := aMorph.
	innerBlockWrapper addMorphBack: innerBlock.
	innerLabel ifNotNil: [:label | innerBlock addDBLabel: label]
]

{ #category : #accessing }
SBDomainBlock >> sourceObject [

	^ sourceObject
]

{ #category : #accessing }
SBDomainBlock >> sourceObject: anObject [

	sourceObject := anObject
]

{ #category : #accessing }
SBDomainBlock >> suggestionConstantAt: aSymbol [

	| anSBPropertyMapping |
	anSBPropertyMapping := self domainBlockMappingAt: aSymbol.
	^ anSBPropertyMapping ifNotNil: #suggestionConstant ifNil: [#a]
]

{ #category : #accessing }
SBDomainBlock >> suggestionConstantBlockAt: aSymbol [

	| suggestionConstant anSBPropertyMapping |
	anSBPropertyMapping := self domainBlockMappingAt: aSymbol.
	suggestionConstant := self suggestionConstantAt: aSymbol.
	^ anSBPropertyMapping
		ifNotNil: [anSBPropertyMapping getMorphForValue: suggestionConstant]
		ifNil: [#a]
]

{ #category : #testing }
SBDomainBlock >> supportsLabels [

	^ true
]

{ #category : #accessing }
SBDomainBlock >> topLabelPositions [

	^ {#topLeftLabel. #topCenterLabel. #topRightLabel}
]

{ #category : #accessing }
SBDomainBlock >> valueFromPropertyMapping: aPropertyMapping [

	^ aPropertyMapping value: self sourceObject
]

{ #category : #printing }
SBDomainBlock >> writeSourceOn: aStream [

	
]
