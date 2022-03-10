"
An SBPattern is used to define a combination of SBDomainBlocks and SBConstraintPatterns that can later be used to perform pattern matching with.

Instance Variables
	isImplicitChild:		Boolean

isImplicitChild
	- indicates whether the pattern was implicitly added to it's parent

"
Class {
	#name : #SBPattern,
	#superclass : #SBDomainBlock,
	#instVars : [
		'isImplicitChild'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPattern >> addImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBPattern >> buildImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBPattern >> collectBindingsInto: aCollection [

	self children do: [:child | child collectBindingsInto: aCollection]
]

{ #category : #accessing }
SBPattern >> findConstant [

	self children do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
]

{ #category : #accessing }
SBPattern >> findOriginRoot [

	^ self findConstant asDomainBlock root sourceObject
]

{ #category : #'as yet unclassified' }
SBPattern >> getNext: aDomainBlock [
	"updates the visual primitive the pattern will bind to and returns whether a new binding was found. Whether the binding is correct needs to be checked with matches: withBinding:."

	^ false
]

{ #category : #accessing }
SBPattern >> identifierForIndex: aNumber [

	^ ('', (Character alphabet at: aNumber - 1 // Character alphabet size + 1)) asSymbol
]

{ #category : #accessing }
SBPattern >> implicitPrefix [

	^ 'i_'
]

{ #category : #initialization }
SBPattern >> initialize [

	super initialize.
	isImplicitChild := false
]

{ #category : #accessing }
SBPattern >> isImplicitChild [

	^ isImplicitChild
]

{ #category : #accessing }
SBPattern >> isImplicitChild: aBoolean [

	isImplicitChild := aBoolean
]

{ #category : #'as yet unclassified' }
SBPattern >> matches: aDomainBlock withBinding: aCollection [

	^ true
]

{ #category : #accessing }
SBPattern >> nextIdentifier [

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

{ #category : #accessing }
SBPattern >> patternContainer [

	| case |
	case := self root parentSandblock.
	^ (case isKindOf: SBPatternContainer) ifTrue: [case]
]

{ #category : #'as yet unclassified' }
SBPattern >> removeImplicitChildren [

	self children select: #isImplicitChild thenDo: #abandon.
	self children: (self children reject: #isImplicitChild).
	self children do: #removeImplicitChildren
]

{ #category : #'as yet unclassified' }
SBPattern >> reset [
	"do nothing"

	
]

{ #category : #accessing }
SBPattern >> setBindingFor: aDomainBlock in: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBPattern >> supportsLabels [

	^ false
]

{ #category : #'as yet unclassified' }
SBPattern >> wantsImplicitNeighbors [

	^ true
]
