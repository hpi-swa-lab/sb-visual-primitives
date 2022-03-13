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
	#superclass : #SBStSubstitution,
	#instVars : [
		'row',
		'isOutputPattern',
		'children',
		'parent'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBGroupPattern class >> default [

	^ self patterns: {SBBindingPattern new. SBConstraintPattern default}
]

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

{ #category : #'as yet unclassified' }
SBGroupPattern class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addChild: aDomainBlock afterIndex: aNumber [

	aDomainBlock parent ifNotNil: [aDomainBlock parent removeChild: aDomainBlock].
	self children add: aDomainBlock afterIndex: aNumber.
	aDomainBlock parent: self.
	self openPatternAsChild: aDomainBlock
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addImplicitChildren: anArray [

	self children do: [:pattern | pattern addImplicitChildren: anArray]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewAndPattern [

	self insertNewPattern: SBGroupPattern default
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> addNewBindingPattern [

	self flag: #todo. "position of bindingPattern is wrong. Corrects itself when another pattern is deleted"
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
SBGroupPattern >> addNewParent [
	"Do nothing yet"

	
]

{ #category : #'as yet unclassified' }
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

{ #category : #'insert/delete' }
SBGroupPattern >> canDeleteChild: aBlock [

	^ true
]

{ #category : #accessing }
SBGroupPattern >> children [

	^ children
]

{ #category : #accessing }
SBGroupPattern >> children: aCollection [

	children := aCollection asOrderedCollection.
	children do: [:child | child parent: self]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> collectBindingsInto: aCollection [

	self children do: [:child | child collectBindingsInto: aCollection]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> collectIdentityBindingsInto: aCollection [

	self children do: [:child | child collectIdentityBindingsInto: aCollection]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> deleteBlock [

	self sandblockEditor do: (SBDeleteDomainBlockCommand new
		target: self;
		yourself)
]

{ #category : #'insert/delete' }
SBGroupPattern >> deleteCommandFor: aBlock [

	| primitive |
	primitive := aBlock isDomainBlock
		ifTrue: [aBlock]
		ifFalse: [aBlock submorphThat: [:morph | morph isDomainBlock and: [morph parent = self]] ifNone: [nil]].
	
	^ SBDeleteDomainBlockCommand new target: primitive
]

{ #category : #'pattern matching' }
SBGroupPattern >> findConstant [

	self children do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
]

{ #category : #'pattern matching' }
SBGroupPattern >> findOriginRoot [

	^ self findConstant asDomainBlock root sourceObject
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
SBGroupPattern >> identifierForIndex: aNumber [

	^ ('', (Character alphabet at: aNumber - 1 // Character alphabet size + 1)) asSymbol
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> implicitPrefix [

	^ 'i_'
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
		layoutInset: 4;
		addMorphBack: (row := SBRow new
			shrinkWrap;
			cellInset: 3;
			cellPositioning: #center);
		children: OrderedCollection new
]

{ #category : #'insert/delete' }
SBGroupPattern >> insertCommandRequest: aMorph near: aBlock before: aBoolean [

	| insertCommand |
	insertCommand := SBRelInsertDomainBlockCommand new
		near: aBlock before: aBoolean in: self morph: aMorph;
		yourself.
	^ self isOutputPattern not
		ifTrue: [insertCommand]
		ifFalse: [self row submorphs isEmpty ifTrue: [insertCommand] ifFalse: [nil]]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> insertNewPattern: aPattern [

	self sandblockEditor do: (SBInsertDomainBlockCommand new
		index: self owner submorphCount + 1;
		parent: self;
		container: self owner;
		morph: aPattern;
		shouldMergeWithNext: false;
		yourself)
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> isDomainBlock [

	self flag: #todo.
	"Should actually be false"
	^ true
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
SBGroupPattern >> label [

	^ nil
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> matches: aDomainBlock withBinding: aCollection [

	^ self children allSatisfy: [:pattern | pattern matches: aDomainBlock withBinding: aCollection]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> nextIdentifier [

	| invalidIdentifiers currentAttempt possibleIdentifer |
	invalidIdentifiers := Array streamContents: [:stream |
		self allChildrenDo: [:pattern | | element |
			element := pattern bindingIndex.
			element := element ifNotNil: [
				(pattern bindingIndex beginsWith: self implicitPrefix)
					ifTrue: [element from: self implicitPrefix size + 1]
					ifFalse: [element]].
			stream nextPut: element]].
	
	currentAttempt := 1.
	[
		possibleIdentifer := self identifierForIndex: currentAttempt.
		invalidIdentifiers includes: possibleIdentifer] whileTrue: [currentAttempt := currentAttempt + 1].
	
	^ possibleIdentifer
]

{ #category : #callbacks }
SBGroupPattern >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	self resetVisualization
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> openPatternAsChild: aPattern [

	| insertPosition addedBlock |
	insertPosition := aPattern siblingIndex * 2 - 1.
	
	aPattern isBindingPattern
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

{ #category : #accessing }
SBGroupPattern >> parent [

	^ parent
]

{ #category : #accessing }
SBGroupPattern >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
SBGroupPattern >> patternContainer [

	| case |
	case := self root parentSandblock.
	^ (case isKindOf: SBPatternContainer) ifTrue: [case]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> rebuild [

	self allChildrenDo: [:child | child rebuild]
]

{ #category : #'as yet unclassified' }
SBGroupPattern >> removeChild: aDomainBlock [

	self children remove: aDomainBlock.
	aDomainBlock parent: nil.
	self resetVisualization
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBGroupPattern >> root [

	^ self parent ifNil: [self] ifNotNil: [self parent root]
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
SBGroupPattern >> siblingIndex [

	^ self parent ifNil: [0] ifNotNil: [self parent children indexOf: self]
]

{ #category : #printing }
SBGroupPattern >> writeSourceOn: aStream [

	aStream nextPutAll: '(', self class name, ' patterns: {'.
	(self children reject: [:pattern | pattern isImplicitChild]) do: [:pattern |
		pattern writeSourceOn: aStream.
		aStream nextPut: $.].
	aStream nextPutAll: '})'
]
