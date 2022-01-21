Class {
	#name : #SBVPPattern,
	#superclass : #SBVisualPrimitive,
	#instVars : [
		'isImplicitChild'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPattern class >> registerShortcuts: aProvider [

	aProvider
		registerShortcut: $h do: #selectLeftSibling;
		registerShortcut: $j do: #selectCenterChild;
		registerShortcut: $k do: #selectParent;
		registerShortcut: $l do: #selectRightSibling
]

{ #category : #'as yet unclassified' }
SBVPPattern >> addImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> allPatternsDo: aBlock [

	self connections do: [:connection | connection allPatternsDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> buildImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> collectBindingsInto: aCollection [

	self connections do: [:connection | connection collectBindingsInto: aCollection]
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
SBVPPattern >> nextIdentifier [

	| invalidIdentifiers currentAttempt possibleIdentifer |
	invalidIdentifiers := Array streamContents: [:stream | self allPatternsDo: [:pattern | stream nextPut: pattern bindingIndex]].
	
	currentAttempt := 1.
	[
		possibleIdentifer := self identifierForIndex: currentAttempt.
		invalidIdentifiers includes: possibleIdentifer] whileTrue: [currentAttempt := currentAttempt + 1].
	
	^ possibleIdentifer
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
SBVPPattern >> selectCenterChild [
	<action>

	self connections ifNotEmpty: [(self connections at: self connections size + 1 / 2) select]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> selectLeftSibling [
	<action>

	self leftSibling ifNotNil: #select
]

{ #category : #accessing }
SBVPPattern >> selectParent [
	<action>

	self parent ifNotNil: #select
]

{ #category : #'as yet unclassified' }
SBVPPattern >> selectRightSibling [
	<action>

	self rightSibling ifNotNil: #select
]

{ #category : #'as yet unclassified' }
SBVPPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPPattern >> wantsImplicitNeighbors [

	^ true
]
