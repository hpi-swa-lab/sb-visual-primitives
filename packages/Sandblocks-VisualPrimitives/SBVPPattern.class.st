Class {
	#name : #SBVPPattern,
	#superclass : #SBVisualPrimitive,
	#instVars : [
		'isImplicitChild'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPattern >> addImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> allConnectionsDo: aBlock [

	self connections do: [:connection | connection allConnectionsDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> buildImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> centerChild [

	^ self connections
		ifEmpty: [nil]
		ifNotEmpty: [self connections at: self connections size + 1 / 2]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> collectBindingsInto: aCollection [

	self connections do: [:connection | connection collectBindingsInto: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> deletePattern [
	<action>

	| oldParent |
	oldParent := self parent.
	self parent ifNotNil: [self parent removeConnection: self].
	self allConnectionsDo: [:block | block abandon].
	oldParent ifNotNil: #layout
]

{ #category : #'as yet unclassified' }
SBVPPattern >> findConstant [

	self connections do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBVPPattern >> findOriginRoot [

	^ self findConstant asVisualPrimitive root origin
]

{ #category : #'as yet unclassified' }
SBVPPattern >> getNext: aVisualPrimitive [
	"updates the visual primitive the pattern will bind to and returns whether a new binding was found. Whether the binding is correct needs to be checked with matches: withBinding:."

	^ false
]

{ #category : #'as yet unclassified' }
SBVPPattern >> identifierForIndex: aNumber [

	^ ('i_', (Character alphabet at: aNumber - 1 // 26 + 1), (Character alphabet at: aNumber - 1 \\ 26 + 1)) asSymbol
]

{ #category : #accessing }
SBVPPattern >> initialize [

	super initialize.
	self isImplicitChild: false
]

{ #category : #accessing }
SBVPPattern >> isImplicitChild [

	^ isImplicitChild
]

{ #category : #accessing }
SBVPPattern >> isImplicitChild: aBoolean [

	isImplicitChild := aBoolean
]

{ #category : #'as yet unclassified' }
SBVPPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPPattern >> moveCursorDown [
	<action>

	self floating
		ifTrue: [self centerChild ifNotNil: #select ifNil: [self selectBottomToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorDown]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> moveCursorLeft [
	<action>

	self floating
		ifTrue: [self leftSibling ifNotNil: #select ifNil: [self selectLeftToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorLeft]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> moveCursorRight [
	<action>

	self floating
		ifTrue: [self rightSibling ifNotNil: #select ifNil: [self selectRightToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorRight]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> moveCursorUp [
	<action>

	self floating
		ifTrue: [self parent ifNotNil: #select ifNil: [self selectTopToplevel]]
		ifFalse: [self sandblockEditor cursor moveCursorUp]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> nextIdentifier [

	| invalidIdentifiers currentAttempt possibleIdentifer |
	invalidIdentifiers := Array streamContents: [:stream | self allConnectionsDo: [:pattern | stream nextPut: pattern bindingIndex]].
	
	currentAttempt := 1.
	[
		possibleIdentifer := self identifierForIndex: currentAttempt.
		invalidIdentifiers includes: possibleIdentifer] whileTrue: [currentAttempt := currentAttempt + 1].
	
	^ possibleIdentifer
]

{ #category : #'as yet unclassified' }
SBVPPattern >> parentCase [

	| case |
	case := self root parentSandblock.
	^ (case isKindOf: SBVPCase) ifTrue: [case] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> removeImplicitChildren [

	self connections select: [:child | child isImplicitChild] thenDo: [:implicitChild |
		implicitChild abandon.
		self withDecorator: SBTreeDecorator do: [:decorator | decorator removeChild: implicitChild]].
	self connections: (self connections reject: [:child | child isImplicitChild]).
	self connections do: [:child | child removeImplicitChildren]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> reset [
	"do nothing"

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPPattern >> wantsImplicitNeighbors [

	^ true
]
