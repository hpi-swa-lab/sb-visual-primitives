"
An SBConnectDecorator allows for connecting two morphs. When the mouse is nearby, the 4 connectors appear to indicate the morphs ability to be connected. They also act as start and endpoints for connections. A connection can be made by clicking on a connectionPoint and dragging to the other morph.

Instance Variables
	connectionPoints:		Array of 4 CircleMorphs
	connectors:				Set of SBNodeConnectors 
	isConnecting:			Boolean
	isMouseClose:			Boolean

connectionPoints
	- connection endpoints on top, bottom, left and right side of the morph
	- only shown when isMouseClose

connectors
	- SBNodeConnectors that connect the morph with others

isConnecting
	- indicates whether a connection is made at the moment

isMouseClose
	- indicates whether the mouse is nearby

"
Class {
	#name : #SBConnectDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'connectionPoints',
		'connectors',
		'isConnecting',
		'isMouseClose'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #examples }
SBConnectDecorator class >> example [

	SBMorphExample
		setUp: [SBStPlayground new attachDecorator: self new]
		cases: {
			SBMorphExampleCase name: 'example 1' caseBlock: [:m |
				m.
				m owner addMorph: m copy]}
		extent: 300 @ 300
]

{ #category : #connecting }
SBConnectDecorator >> addConnectorFrom: aSourceMorph to: aDestinationMorph [

	| connector |
	(self connectors noneSatisfy: [:con | con to = aDestinationMorph]) ifTrue: [
		connector := SBNodeConnector connect: aSourceMorph to: aDestinationMorph.
		self connectors add: connector.
		self morph containingFloat owner addMorphBack: connector]
]

{ #category : #checks }
SBConnectDecorator >> checkIsMouseNearby [

	^ (self morph boundsInWorld vectorToPoint: ActiveHand position) r < 10
]

{ #category : #accessing }
SBConnectDecorator >> connectionPoints [

	connectionPoints ifNil: [self initializeConnectionPoints].
	^ connectionPoints
]

{ #category : #accessing }
SBConnectDecorator >> connectionPoints: anArray [

	connectionPoints := anArray
]

{ #category : #accessing }
SBConnectDecorator >> connectors [

	^ connectors
]

{ #category : #accessing }
SBConnectDecorator >> connectors: aSet [

	connectors := aSet
]

{ #category : #'initialize-release' }
SBConnectDecorator >> deleteConnectionPoints [

	self connectionPoints do: [:point | point delete]
]

{ #category : #'initialize-release' }
SBConnectDecorator >> deleteConnectors [

	self connectors do: [:connector | connector delete]
]

{ #category : #connecting }
SBConnectDecorator >> endConnecting: anEvent [

	| target |
	target := self morphAtPoint: anEvent position satisfying: [:m | m isSandblock].
	target ifNotNil: [self addConnectorFrom: self morph to: target].
	self isConnecting: false
]

{ #category : #'initialize-release' }
SBConnectDecorator >> initialize [

	super initialize.
	self
		isMouseClose: false;
		connectors: Set new;
		isConnecting: false
]

{ #category : #'initialize-release' }
SBConnectDecorator >> initializeConnectionPoints [

	self connectionPoints: (Array streamContents: [:stream |
		4 timesRepeat: [
			stream nextPut: (CircleMorph new
				extent: 8 @ 8;
				yourself)]]).
	
	self connectionPoints do: [:connectionPoint |
		self initializeEventListenersOnConnectionPoint: connectionPoint.
		self morph owner addMorph: connectionPoint].
	
	self initializeEventListenersOnMorph
]

{ #category : #'initialize-release' }
SBConnectDecorator >> initializeEventListenersOnConnectionPoint: aConnectionPoint [

	(self installEventBroadcasterFor: aConnectionPoint)
		when: #mouseDown send: #startConnecting to: self;
		when: #mouseUp send: #endConnecting: to: self
]

{ #category : #'initialize-release' }
SBConnectDecorator >> initializeEventListenersOnMorph [

	self morph
		when: #positionChanged send: #positionConnectionPoints to: self;
		when: #delete send: #deleteConnectionPoints to: self;
		when: #delete send: #deleteConnectors to: self
]

{ #category : #accessing }
SBConnectDecorator >> isConnecting [

	^ isConnecting
]

{ #category : #accessing }
SBConnectDecorator >> isConnecting: aBoolean [

	isConnecting := aBoolean
]

{ #category : #accessing }
SBConnectDecorator >> isMouseClose [

	^ isMouseClose
]

{ #category : #accessing }
SBConnectDecorator >> isMouseClose: aBoolean [

	isMouseClose := aBoolean
]

{ #category : #connecting }
SBConnectDecorator >> morphAtPoint: aPoint satisfying: aBlock [
	"copied from SBForceMoveDecorator"

	| best bestArea |
	best := nil.
	bestArea := 0.
	
	self morph owner submorphsDo: [:aMorph |
		((aMorph containsPoint: aPoint)
			and: [aMorph bounds area > bestArea]
			and: [aMorph ~= self morph]
			and: [aBlock value: aMorph]) ifTrue: [
			best := aMorph.
			bestArea := aMorph bounds area]].
	
	^ best
]

{ #category : #'initialize-release' }
SBConnectDecorator >> positionConnectionPoints [

	self connectionPoints first center: self morph bounds topCenter.
	self connectionPoints second center: self morph bounds rightCenter.
	self connectionPoints third center: self morph bounds bottomCenter.
	self connectionPoints fourth center: self morph bounds leftCenter
]

{ #category : #drawing }
SBConnectDecorator >> postDrawOn: aCanvas [

	self isMouseClose ifTrue: [aCanvas frameRectangle: self morph bounds color: Color red].
	super postDrawOn: aCanvas
]

{ #category : #connecting }
SBConnectDecorator >> removeConnector: aConnector [

	self connectors remove: aConnector.
	aConnector abandon
]

{ #category : #connecting }
SBConnectDecorator >> startConnecting [

	self isConnecting: true
]

{ #category : #stepping }
SBConnectDecorator >> step [

	| newIsMouseClose |
	newIsMouseClose := self checkIsMouseNearby.
	newIsMouseClose ~= self isMouseClose ifTrue: [
		self morph changed.
		self isMouseClose: newIsMouseClose].
	self connectionPoints do: [:connectionPoint | connectionPoint visible: (newIsMouseClose or: [self isConnecting])]
]

{ #category : #stepping }
SBConnectDecorator >> stepTime [

	^ 200
]