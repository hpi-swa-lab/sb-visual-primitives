"
An SBGroupPattern creates and contains SBBindingPatterns, SBConstraintPatterns and SBOrGroupPatterns. The patterns are seperated with an 'and'.

Instance Variables
	isOutputPattern: 	Boolean

isOutputPattern
	- indicates whether this SBGroupPattern is an output pattern

"
Class {
	#name : #SBGroupPattern,
	#superclass : #SBStSubstitution,
	#instVars : [
		'isOutputPattern'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #'as yet unclassified' }
SBGroupPattern class >> default [

	^ self patterns: {SBBindingPattern new. SBConstraintPattern default}
]

{ #category : #'as yet unclassified' }
SBGroupPattern class >> defaultVisualizedAs: aClass [

	^ self patterns: {SBBindingPattern defaultVisualizedAs: aClass. SBConstraintPattern default}
]

{ #category : #'as yet unclassified' }
SBGroupPattern class >> matches: aBlock [

	^ self selector: #patterns: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBGroupPattern class >> newFor: aBlock [

	^ self new patternChildren: (aBlock arguments first submorphs select: #isPatternBlock)
]

{ #category : #'as yet unclassified' }
SBGroupPattern class >> patterns: aCollection [

	^ self new patternChildren: aCollection
]

{ #category : #'as yet unclassified' }
SBGroupPattern class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #'insert/delete' }
SBGroupPattern >> addChild: aDomainBlock afterIndex: aNumber [

	aDomainBlock patternParent ifNotNil: [aDomainBlock patternParent removeChild: aDomainBlock].
	self openPatternAsChild: aDomainBlock afterIndex: aNumber
]

{ #category : #'insert/delete' }
SBGroupPattern >> addImplicitChildren: anArray [

	self patternChildren do: [:pattern | pattern addImplicitChildren: anArray]
]

{ #category : #actions }
SBGroupPattern >> addNewAndPattern [

	self insertNewPattern: SBGroupPattern default
]

{ #category : #actions }
SBGroupPattern >> addNewBindingPattern [

	self flag: #todo.
	"position of bindingPattern is wrong. Corrects itself when another pattern is deleted"
	self insertNewPattern: SBBindingPattern new
]

{ #category : #actions }
SBGroupPattern >> addNewChild [
	<action>

	| selectedIndex options |
	options := {#addNewBindingPattern. #addNewConstraintPattern. #addNewAndPattern. #addNewOrPattern}.
	selectedIndex := UIManager default chooseFrom: options.
	self perform: (options at: selectedIndex ifAbsent: [])
]

{ #category : #actions }
SBGroupPattern >> addNewConstraintPattern [

	self insertNewPattern: SBConstraintPattern default
]

{ #category : #actions }
SBGroupPattern >> addNewOrPattern [

	self insertNewPattern: SBOrGroupPattern default
]

{ #category : #'adding/removing' }
SBGroupPattern >> addSeparatorsAround: aPattern [

	(aPattern submorphAfter
		ifNil: [false]
		ifNotNil: [(aPattern submorphAfter isKindOf: SBTextBubble) not]) ifTrue: [self addMorph: (SBTextBubble new contents: self separatorString) after: aPattern].
	
	(aPattern submorphBefore
		ifNil: [false]
		ifNotNil: [(aPattern submorphBefore isKindOf: SBTextBubble) not]) ifTrue: [self addMorph: (SBTextBubble new contents: self separatorString) inFrontOf: aPattern]
]

{ #category : #'adding/removing' }
SBGroupPattern >> addToWorld: aWorld [

	self patternChildren do: [:pattern | pattern addToWorld: aWorld].
	aWorld addMorphBack: self
]

{ #category : #'insert/delete' }
SBGroupPattern >> allChildrenDo: aBlock [

	self patternChildren do: [:child | child allChildrenDo: aBlock]
]

{ #category : #'pattern matching' }
SBGroupPattern >> buildFromBinding: anArray [

	self flag: #TODO.
	"Support multiple patternChildren to support multiple outputs"
	^ self patternChildren first buildFromBinding: anArray
]

{ #category : #'pattern matching' }
SBGroupPattern >> buildImplicitChildren: anArray [

	self patternChildren do: [:pattern | pattern buildImplicitChildren: anArray]
]

{ #category : #'insert/delete' }
SBGroupPattern >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'pattern matching' }
SBGroupPattern >> collectBindingsInto: aCollection [

	self patternChildren do: [:child | child collectBindingsInto: aCollection]
]

{ #category : #'pattern matching' }
SBGroupPattern >> collectIdentityBindingsInto: aCollection [

	self patternChildren do: [:child | child collectIdentityBindingsInto: aCollection]
]

{ #category : #'insert/delete' }
SBGroupPattern >> deleteBlock [

	self sandblockEditor do: (SBDeleteDomainBlockCommand new target: self)
]

{ #category : #'insert/delete' }
SBGroupPattern >> deleteCommandFor: aBlock [

	| domainBlock |
	domainBlock := aBlock isPatternBlock ifTrue: [aBlock] ifFalse: [
		aBlock
			submorphThat: [:morph | morph isPatternBlock and: [morph patternParent = self]]
			ifNone: [nil]].
	
	^ SBDeleteSubtreeCommand new target: domainBlock
]

{ #category : #'pattern matching' }
SBGroupPattern >> findConstant [

	self patternChildren do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
]

{ #category : #'pattern matching' }
SBGroupPattern >> findOriginRoot [

	^ self findConstant asDomainBlock patternRoot sourceObject
]

{ #category : #testing }
SBGroupPattern >> fixedNumberOfChildren [

	^ false
]

{ #category : #'pattern matching' }
SBGroupPattern >> getNext: aDomainBlock [

	self patternChildren do: [:pattern | (pattern getNext: aDomainBlock) ifFalse: [pattern reset] ifTrue: [^ true]].
	^ false
]

{ #category : #initialization }
SBGroupPattern >> initialize [

	super initialize.
	self removeAllMorphs.
	
	isOutputPattern := false.
	
	self
		addKeyboardCaptureFilter: self;
		addMouseCaptureFilter: self;
		shrinkWrap;
		changeTableLayout;
		listDirection: #leftToRight;
		layoutInset: 4;
		cellInset: 3;
		cellPositioning: #center;
		patternChildren: OrderedCollection new
]

{ #category : #'insert/delete' }
SBGroupPattern >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	| insertCommand |
	insertCommand := SBRelInsertDomainBlockCommand new
		near: aBlock before: aBoolean in: self morph: aMorph;
		yourself.
	^ self isOutputPattern not
		ifTrue: [insertCommand]
		ifFalse: [self submorphs isEmpty ifTrue: [insertCommand] ifFalse: [nil]]
]

{ #category : #'insert/delete' }
SBGroupPattern >> insertNewPattern: aPattern [

	self sandblockEditor do: (SBInsertDomainBlockCommand new
		index: self owner submorphCount + 1;
		patternParent: self;
		container: self owner;
		morph: aPattern;
		shouldMergeWithNext: false;
		yourself)
]

{ #category : #testing }
SBGroupPattern >> isExpression [

	^ false
]

{ #category : #testing }
SBGroupPattern >> isImplicitChild [

	^ false
]

{ #category : #accessing }
SBGroupPattern >> isOutputPattern [

	^ isOutputPattern
]

{ #category : #accessing }
SBGroupPattern >> isOutputPattern: aBoolean [

	isOutputPattern := aBoolean
]

{ #category : #'*Sandblocks-DomainBlocks' }
SBGroupPattern >> isPatternBlock [

	^ true
]

{ #category : #accessing }
SBGroupPattern >> label [

	^ nil
]

{ #category : #'pattern matching' }
SBGroupPattern >> matches: aDomainBlock withBinding: aCollection [

	^ self patternChildren allSatisfy: [:pattern | pattern matches: aDomainBlock withBinding: aCollection]
]

{ #category : #callbacks }
SBGroupPattern >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	self patternChildren do: [:submorph | submorph noteNewOwner: self]
]

{ #category : #'adding/removing' }
SBGroupPattern >> openPatternAsChild: aPattern afterIndex: aNumber [

	| insertPosition addedBlock |
	insertPosition := aNumber * 2.
	insertPosition = 0 ifTrue: [insertPosition := 1].
	
	aPattern isBindingPattern
		ifTrue: [
			addedBlock := SBBlock new
				layoutPolicy: SBTreeLayoutPolicy new;
				shrinkWrap;
				layoutInset: 6;
				when: #reportError send: #reportError: to: self.
			
			self addMorph: addedBlock atIndex: insertPosition.
			
			aPattern addToWorld: addedBlock]
		ifFalse: [
			self addMorph: aPattern atIndex: insertPosition.
			addedBlock := aPattern].
	
	self addSeparatorsAround: addedBlock
]

{ #category : #accessing }
SBGroupPattern >> patternChildren [

	^ (self submorphs collect: [:morph |
		morph isPatternBlock ifTrue: [morph] ifFalse: [
			morph submorphs
				detect: [:anotherMorph | anotherMorph isPatternBlock and: [anotherMorph patternParent = self]]
				ifNone: [nil]]]) select: #isPatternBlock
]

{ #category : #accessing }
SBGroupPattern >> patternChildren: aCollection [

	self removeAllMorphs.
	aCollection do: [:aPattern | self addChild: aPattern afterIndex: self patternChildren size]
]

{ #category : #'pattern hierarchy' }
SBGroupPattern >> patternParent [

	^ self owner isPatternBlock ifTrue: [self owner]
]

{ #category : #initialization }
SBGroupPattern >> rebuild [

	self allChildrenDo: [:child | child rebuild]
]

{ #category : #'insert/delete' }
SBGroupPattern >> removeChild: aDomainBlock [

	(aDomainBlock isBindingPattern
		ifTrue: [aDomainBlock owner]
		ifFalse: [aDomainBlock]) delete
]

{ #category : #'insert/delete' }
SBGroupPattern >> removeImplicitChildren [

	self patternChildren do: [:child | child removeImplicitChildren]
]

{ #category : #'submorphs - callbacks' }
SBGroupPattern >> removedMorph: anSBBlock [

	| deletedLabelCount |
	deletedLabelCount := 0.
	self submorphs withIndexDo: [:submorph :index | ((index - deletedLabelCount) odd and: [submorph isKindOf: SBTextBubble]) ifTrue: [submorph delete]].
	(self submorphs notEmpty and: [self lastSubmorph isKindOf: SBTextBubble]) ifTrue: [self lastSubmorph delete]
]

{ #category : #initialization }
SBGroupPattern >> reset [

	self patternChildren do: [:pattern | pattern reset]
]

{ #category : #accessing }
SBGroupPattern >> separatorString [

	^ ' and '
]

{ #category : #accessing }
SBGroupPattern >> setBindingFor: aDomainBlock in: aCollection [

	^ self patternChildren allSatisfy: [:pattern | pattern setBindingFor: aDomainBlock in: aCollection]
]

{ #category : #printing }
SBGroupPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(', self class name, ' patterns: {'.
	(self patternChildren reject: [:pattern | pattern isImplicitChild]) do: [:pattern |
		pattern writeSourceOn: aStream.
		aStream nextPut: $.].
	aStream nextPutAll: '})'
]
