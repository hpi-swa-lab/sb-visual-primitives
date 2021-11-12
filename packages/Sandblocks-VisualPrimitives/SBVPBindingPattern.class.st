Class {
	#name : #SBVPBindingPattern,
	#superclass : #SBVPPattern,
	#instVars : [
		'firstChildOffset',
		'canMatchAllChildren',
		'connectionBlocks',
		'canvas'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> applySubstitution: aBlock [

	self allSubclassesDo: [:substition | (substition matches: aBlock) ifTrue: [^ (substition newFor: aBlock) pc: aBlock pc]].
	Error signal: 'BiningPatter accepts only connections to other BindingPatterns'.
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> applySubstitution: aBlock on: aMorph [

	self allSubclassesDo: [:substition | (substition matches: aBlock) 
		ifTrue: [^ (substition newFor: aBlock on: aMorph) pc: aBlock pc]] .
	Error signal: 'BindingPattern accepts only connections to other BindingPatterns'
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> label: anObject connections: aCollection [

	^ self new label: anObject; connectors: aCollection 
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> matches: aBlock [

	^ self selector: #label:connections: receiverMatches: aBlock
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> newFor: aBlock [
	
	| bindingPattern|
	bindingPattern := self new.
	bindingPattern	createCanvas; 
		label: aBlock arguments first;
		connectionBlocks: (aBlock arguments second childSandblocks collect: [:arg | self applySubstitution: arg on: bindingPattern canvas]).
	^ bindingPattern
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern class >> newFor: aBlock on: aMorph [

	^ self new canvas: aMorph;
		label: aBlock arguments first;
		connectionBlocks: (aBlock arguments second childSandblocks collect: [:arg | self applySubstitution: arg on: aMorph])
]

{ #category : #accessing }
SBVPBindingPattern >> canMatchAllChildren [

	^ canMatchAllChildren
]

{ #category : #accessing }
SBVPBindingPattern >> canMatchAllChildren: anObject [

	canMatchAllChildren := anObject.
]

{ #category : #accessing }
SBVPBindingPattern >> canvas [

	^ canvas
]

{ #category : #accessing }
SBVPBindingPattern >> canvas: aSBSandboxPasteUpMorph [

	self canvas removeMorph: self.
	canvas := aSBSandboxPasteUpMorph.
	self canvas addMorphBack: self
	
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

	connections := aCollection.
	"self connections do: [:aBlock | self row addMorphBack: aBlock] separatedBy: [self row addMorphBack: (SBTextBubble new contents: ' and '; yourself)]"
	
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> couldMatch: aVisualPrimitive [

	^ self childrenInCurrentMatch = aVisualPrimitive connections size
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> createCanvas [

	^ self addMorphBack: (TransformMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addMorph: (canvas := SBSandboxPasteUpMorph new
				when: #reportError
				send: #reportError:
				to: self)).
]

{ #category : #'as yet unclassified' }
SBVPBindingPattern >> enoughChildren: aVisualPrimitive [

	^ self childrenInCurrentMatch <= aVisualPrimitive connections size
]

{ #category : #accessing }
SBVPBindingPattern >> firstChildOffset [

	^ firstChildOffset
]

{ #category : #accessing }
SBVPBindingPattern >> firstChildOffset: anObject [

	firstChildOffset := anObject.
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

{ #category : #accessing }
SBVPBindingPattern >> initialize [

	super initialize.
	self addMorphBack: (TransformMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addMorph: (canvas := SBSandboxPasteUpMorph new
				when: #reportError
				send: #reportError:
				to: self))
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
	self label ifNotNil: [ | variableIndex |
		variableIndex := self label asInteger.
		(aCollection at: variableIndex)
			ifNotNil: [:previousValue | ^ previousValue = currentPrimitive]
			ifNil: [aCollection at: variableIndex put: currentPrimitive]].
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
