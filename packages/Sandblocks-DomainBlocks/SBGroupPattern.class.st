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

{ #category : #'as yet unclassified' }
SBGroupPattern >> addChild: aDomainBlock afterIndex: aNumber [

	aDomainBlock patternParent ifNotNil: [aDomainBlock patternParent removeChild: aDomainBlock].
	self openPatternAsChild: aDomainBlock afterIndex: aNumber
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addImplicitChildren: anArray [

	self patternChildren do: [:pattern | pattern addImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewAndPattern [

	self insertNewPattern: SBGroupPattern default
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewBindingPattern [

	self flag: #todo.
	"position of bindingPattern is wrong. Corrects itself when another pattern is deleted"
	self insertNewPattern: SBBindingPattern new
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewChild [
	<action>

	| selectedIndex options |
	options := {#addNewBindingPattern. #addNewConstraintPattern. #addNewAndPattern. #addNewOrPattern}.
	selectedIndex := UIManager default chooseFrom: options.
	self perform: (options at: selectedIndex ifAbsent: [])
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewConstraintPattern [

	self insertNewPattern: SBConstraintPattern default
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewOrPattern [

	self insertNewPattern: SBOrGroupPattern default
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addSeparatorsAround: aPattern [

	(aPattern submorphAfter
		ifNil: [false]
		ifNotNil: [(aPattern submorphAfter isKindOf: SBTextBubble) not]) ifTrue: [self addMorph: (SBTextBubble new contents: self separatorString) after: aPattern].
	
	(aPattern submorphBefore
		ifNil: [false]
		ifNotNil: [(aPattern submorphBefore isKindOf: SBTextBubble) not]) ifTrue: [self addMorph: (SBTextBubble new contents: self separatorString) inFrontOf: aPattern]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addToWorld: aWorld [

	self patternChildren do: [:pattern | pattern addToWorld: aWorld].
	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> allChildrenDo: aBlock [

	self patternChildren do: [:child | child allChildrenDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> buildFromBinding: anArray [

	self flag: #TODO.
	"Support multiple patternChildren to support multiple outputs"
	^ self patternChildren first buildFromBinding: anArray
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> buildImplicitChildren: anArray [

	self patternChildren do: [:pattern | pattern buildImplicitChildren: anArray]
]

{ #category : #'insert/delete' }
SBGroupPattern >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> collectBindingsInto: aCollection [

	self patternChildren do: [:child | child collectBindingsInto: aCollection]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> collectIdentityBindingsInto: aCollection [

	self patternChildren do: [:child | child collectIdentityBindingsInto: aCollection]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> deleteBlock [

	self sandblockEditor do: (SBDeleteDomainBlockCommand new target: self)
]

{ #category : #'insert/delete' }
SBGroupPattern >> deleteCommandFor: aBlock [

	| primitive |
	primitive := aBlock isPatternBlock ifTrue: [aBlock] ifFalse: [
		aBlock
			submorphThat: [:morph | morph isPatternBlock and: [morph patternParent = self]]
			ifNone: [nil]].
	
	^ SBDeleteSubtreeCommand new target: primitive
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

{ #category : #accessing }
SBGroupPattern >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBGroupPattern >> insertNewPattern: aPattern [

	self sandblockEditor do: (SBInsertDomainBlockCommand new
		index: self owner submorphCount + 1;
		patternParent: self;
		container: self owner;
		morph: aPattern;
		shouldMergeWithNext: false;
		yourself)
]

{ #category : #accessing }
SBGroupPattern >> isExpression [

	^ false
]

{ #category : #accessing }
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

{ #category : #accessing }
SBGroupPattern >> isPatternBlock [

	^ true
]

{ #category : #accessing }
SBGroupPattern >> label [

	^ nil
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> matches: aDomainBlock withBinding: aCollection [

	^ self patternChildren allSatisfy: [:pattern | pattern matches: aDomainBlock withBinding: aCollection]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	self patternChildren do: [:submorph | submorph noteNewOwner: self]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBGroupPattern >> rebuild [

	self allChildrenDo: [:child | child rebuild]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> removeChild: aDomainBlock [

	(aDomainBlock isBindingPattern
		ifTrue: [aDomainBlock owner]
		ifFalse: [aDomainBlock]) delete
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> removeImplicitChildren [

	self patternChildren do: [:child | child removeImplicitChildren]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> removedMorph: anSBBlock [

	| deletedLabelCount |
	deletedLabelCount := 0.
	self submorphs withIndexDo: [:submorph :index | ((index - deletedLabelCount) odd and: [submorph isKindOf: SBTextBubble]) ifTrue: [submorph delete]].
	(self submorphs notEmpty and: [self lastSubmorph isKindOf: SBTextBubble]) ifTrue: [self lastSubmorph delete]
]

{ #category : #'as yet unclassified' }
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
