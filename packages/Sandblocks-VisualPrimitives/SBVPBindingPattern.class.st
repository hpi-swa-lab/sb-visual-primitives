Class {
	#name : #SBVPBindingPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'firstChildOffset',
		'canMatchAllChildren',
		'connectionBlocks',
		'constant',
		'bindingIndex',
		'writeBackClosure',
		'writeBackClosureString'
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

	^ {#bindingIndex:. #constant:. #writeBackClosure:} anySatisfy: [:methodName | (self selector: methodName receiverMatches: aBlock) or: [self selector: methodName, #connections: receiverMatches: aBlock]]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> newFor: aBlock [

	^ aBlock arguments size > 1
		ifTrue: [
			self
				perform: aBlock selector asSymbol
				with: aBlock arguments first
				with: aBlock arguments second childSandblocks]
		ifFalse: [self perform: aBlock selector asSymbol with: aBlock arguments first]
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
SBVPBindingPattern >> addImplicitChildren: anArray [

	| implicitChildrenIndices |
	implicitChildrenIndices := anArray at: self bindingIndex.
	
	implicitChildrenIndices withIndexDo: [:bindingIndex :index | | implicitChild |
		implicitChild := SBVPEllipsisPattern bindingIndex: bindingIndex.
		implicitChild isImplicitChild: true.
		self connections add: implicitChild beforeIndex: 2*index].
	
]

{ #category : #accessing }
SBVPBindingPattern >> addToWorld: aWorld [

	self connections do: [:child | child addToWorld: aWorld].
	aWorld addMorphBack: self
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> attachTreeDecorator [

	| decorator |
	decorator := SBTreeDecorator new.
	self connections do: [:child | child attachTreeDecorator].
	self attachDecorator: decorator.
	self connections do: [:child | child withDecorator: SBTreeDecorator do: [:childDecorator | decorator addChild: childDecorator]]
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

	bindingIndex := anObject isSandblock
		ifTrue: [anObject evaluate]
		ifFalse: [anObject].
	self label: bindingIndex asString
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildChildrenFromBinding: anArray [

	^ self connections gather: [:pattern | pattern buildFromBinding: anArray]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildFromBinding: anArray [

	| output |
	output := self constant
		ifNotNil: [self constant asVisualPrimitive]
		ifNil: [(anArray at: self bindingIndex) copy].
	output connections: (self buildChildrenFromBinding: anArray).
	^ {output}
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> buildImplicitChildren: anArray [

	| implicitChildren nextIndex oldConnections addImplicitChild |
	implicitChildren := OrderedCollection new.
	nextIndex := anArray size + 1.
	anArray do: [:subArray | nextIndex := nextIndex max: (subArray ifEmpty: [0] ifNotEmpty: [subArray max + 1])].
	
	oldConnections := self connections copy.
	
	addImplicitChild := [:index | | implicitChild |
		implicitChild := SBVPEllipsisPattern bindingIndex: nextIndex.
		implicitChild isImplicitChild: true.
		self connections add: implicitChild afterIndex: index + implicitChildren size.
		implicitChildren add: nextIndex.
		nextIndex := nextIndex + 1].
	
	(self connections isEmpty or: [self connections first wantsImplicitNeighbors]) ifTrue: [addImplicitChild value: 0].
	
	oldConnections withIndexDo: [:connection :index |
		(connection wantsImplicitNeighbors and: [
			self connections
				at: index + 1
				ifPresent: [:nextChild | nextChild wantsImplicitNeighbors]
				ifAbsent: [true]]) ifTrue: [addImplicitChild value: index]].
	
	anArray at: self bindingIndex put: implicitChildren asArray.
	
	oldConnections do: [:connections | connections buildImplicitChildren: anArray]
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

{ #category : #accessing }
SBVPBindingPattern >> connectionBlocks [

	^ connectionBlocks
]

{ #category : #accessing }
SBVPBindingPattern >> connectionBlocks: aCollection [

	connections := aCollection
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
			anObject evaluate ifNil: [#placeholder]]
		ifFalse: [anObject]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> couldMatch: aVisualPrimitive [

	^ self childrenInCurrentMatch = aVisualPrimitive connections size and: [self constant isNil or: [self constant = aVisualPrimitive origin]]
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

{ #category : #accessing }
SBVPBindingPattern >> explicitChildrenMatching: anObject [

	explicitChildrenMatching := anObject
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
SBVPBindingPattern >> matches: aVisualPrimitive withBinding: aCollection [

	| offset |
	offset := 0.
	^ self connections withIndexAllSatisfy: [:connection :index | | wasSuccessful |
		wasSuccessful := connection
			matches: (connection searchRootFor: (self getCurrentPrimitive: aVisualPrimitive) at: index + offset)
			withBinding: aCollection.
		offset := offset + connection indexOffset.
		wasSuccessful]
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
SBVPBindingPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	| currentPrimitive |
	currentPrimitive := self getCurrentPrimitive: aVisualPrimitive.
	self bindingIndex ifNotNil: [ | binding |
		binding := self bindingFor: aVisualPrimitive.
		(aCollection at: self bindingIndex)
			ifNotNil: [:previousValue | previousValue = binding ifFalse: [^ false]]
			ifNil: [aCollection at: self bindingIndex put: binding]].
	self writeBackClosure ifNotNil: [self writeBackClosure value: currentPrimitive origin].
	^ (self couldMatch: currentPrimitive) and: [self setConnectionBindingFor: currentPrimitive in: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> setConnectionBindingFor: aVisualPrimitive in: aCollection [

	| offset |
	offset := 0.
	^ self connections withIndexAllSatisfy: [:connection :index | | wasSuccessful |
		wasSuccessful := connection
			setBindingFor: (connection searchRootFor: (self getCurrentPrimitive: aVisualPrimitive) at: index + offset)
			in: aCollection.
		offset := offset + connection indexOffset.
		wasSuccessful]
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
SBVPBindingPattern >> writeSourceOn: aStream [

	aStream
		nextPut: $(;
		nextPutAll: self class name.
	
	self bindingIndex ifNotNil: [
		aStream
			nextPutAll: ' bindingIndex: ';
			nextPutAll: self bindingIndex asString].
	
	self constant ifNotNil: [
		aStream
			nextPutAll: ' constant: ';
			nextPutAll: self label].
	
	self writeBackClosure ifNotNil: [
		aStream
			nextPutAll: ' writeBackClosure: ';
			nextPutAll: self writeBackClosureString].
	
	self connections ifNotEmpty: [
		aStream nextPutAll: ' connections: {'.
		self connections do: [:connection |
			connection writeSourceOn: aStream.
			aStream nextPut: $.].
		aStream nextPut: $}].
	aStream nextPut: $)
]
