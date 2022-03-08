"
An SBVPPattern is used to define a combination of SBVisualPrimitives and SBVPConstraintPatterns that can later be used to perform pattern matching with.

Instance Variables
	isImplicitChild:		Boolean

isImplicitChild
	- indicates whether the pattern was implicitly added to it's parent

"
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
SBVPPattern >> buildImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> collectBindingsInto: aCollection [

	self children do: [:child | child collectBindingsInto: aCollection]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> findConstant [

	self children do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBVPPattern >> findOriginRoot [

	^ self findConstant asVisualPrimitive root sourceObject
]

{ #category : #'as yet unclassified' }
SBVPPattern >> getNext: aVisualPrimitive [
	"updates the visual primitive the pattern will bind to and returns whether a new binding was found. Whether the binding is correct needs to be checked with matches: withBinding:."

	^ false
]

{ #category : #'as yet unclassified' }
SBVPPattern >> identifierForIndex: aNumber [

	^ ('', (Character alphabet at: aNumber - 1 // Character alphabet size + 1)) asSymbol
]

{ #category : #'as yet unclassified' }
SBVPPattern >> implicitPrefix [

	^ 'i_'
]

{ #category : #accessing }
SBVPPattern >> initialize [

	super initialize.
	isImplicitChild := false
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

{ #category : #'as yet unclassified' }
SBVPPattern >> parentCase [

	| case |
	case := self root parentSandblock.
	^ ((case isKindOf: SBVPTransformation) or: [case isKindOf: SBVPQuery])
		ifTrue: [case]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> parentQuery [

	| case |
	case := self root parentSandblock.
	^ (case isKindOf: SBVPQuery) ifTrue: [case] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> patternContainer [

	^ self parentCase ifNotNil: [self parentCase] ifNil: [self parentQuery]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> removeImplicitChildren [

	self children select: #isImplicitChild thenDo: #abandon.
	self children: (self children reject: #isImplicitChild).
	self children do: #removeImplicitChildren
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
SBVPPattern >> supportsLabels [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPPattern >> wantsImplicitNeighbors [

	^ true
]
