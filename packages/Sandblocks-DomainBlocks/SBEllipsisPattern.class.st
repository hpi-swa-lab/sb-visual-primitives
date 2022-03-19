"
An SBEllipsisPattern is used to represent any patternChildren of an object. It is an abstraction to sum up many patternChildren and it is used for pattern matching if the number of patternChildren doesn't matter.

Instance Variables
	currentSize:		Number
	isImplicitChild: 		Boolean

currentSize
	- indicates the current number of patternChildren it represents

isImplicitChild
	- indicates whether the SBEllipsisPattern is implicit

"
Class {
	#name : #SBEllipsisPattern,
	#superclass : #SBBindingPattern,
	#instVars : [
		'currentSize',
		'isImplicitChild'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> addImplicitChildren: aDict [

	
]

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> bindingNameWithImplicitPrefix: aBoolean [

	| prefix |
	self bindingName ifNil: [^ nil].
	prefix := self patternContainer implicitPrefix.
	aBoolean
		ifTrue: [
			(self bindingName beginsWith: prefix)
				ifTrue: [^ self bindingName]
				ifFalse: [^ prefix, self bindingName]]
		ifFalse: [
			(self bindingName beginsWith: prefix)
				ifTrue: [^ self bindingName from: prefix size + 1]
				ifFalse: [^ self bindingName]]
]

{ #category : #'pattern matching' }
SBEllipsisPattern >> buildFromBinding: anArray [

	^ (anArray at: self bindingName) veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> buildImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> convertToBindingPattern [
	<action>

	self convertToPatternClass: SBBindingPattern
]

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> convertToEllipsisPattern [
	"we done here"

	
]

{ #category : #'pattern matching' }
SBEllipsisPattern >> couldMatch: aDomainBlock [

	^ true
]

{ #category : #accessing }
SBEllipsisPattern >> currentSize [

	^ currentSize
]

{ #category : #accessing }
SBEllipsisPattern >> currentSize: aNumber [

	currentSize := aNumber
]

{ #category : #'event handling' }
SBEllipsisPattern >> doubleClick: anEvent [

	self isImplicitChild: self isImplicitChild not
]

{ #category : #'pattern matching' }
SBEllipsisPattern >> getNext: aDomainBlock [

	self currentSize: self currentSize + 1.
	^ true
]

{ #category : #accessing }
SBEllipsisPattern >> indexOffset [

	^ self currentSize - 1
]

{ #category : #initialization }
SBEllipsisPattern >> initialize [

	super initialize.
	isImplicitChild := false.
	self
		currentSize: 0;
		addMorph: SBIcon iconEllipsisH large;
		cellPositioning: #center
]

{ #category : #accessing }
SBEllipsisPattern >> isImplicitChild [

	^ isImplicitChild
]

{ #category : #accessing }
SBEllipsisPattern >> isImplicitChild: aBoolean [

	| setColor previousImplicit prevBindingName bindingInputBlock |
	previousImplicit := self isImplicitChild.
	isImplicitChild := aBoolean.
	previousImplicit = self isImplicitChild ifTrue: [^ self].
	prevBindingName := self bindingName.
	self bindingName: (self bindingNameWithImplicitPrefix: aBoolean).
	bindingInputBlock := self bindingName
		ifNil: [self newUnknown]
		ifNotNil: [self bindingLabelBlockFrom: self bindingName].
	self setLabelAt: self identityLabelPosition to: bindingInputBlock.
	setColor := [:newColor |
		self childSandblocksDo: [:block | block color: newColor].
		self firstSubmorph class = SBRow ifFalse: [self firstSubmorph color: newColor]].
	self isImplicitChild
		ifTrue: [setColor value: Color gray]
		ifFalse: [setColor value: Color black].
	"If called with isImplicitChild not changing, this leads to an infinite loop."
	self patternContainer ifNotNil: [:parentCase | parentCase toggleImplicitChildTo: self isImplicitChild withBinding: prevBindingName]
]

{ #category : #accessing }
SBEllipsisPattern >> patternChildren: aCollection [

	self assert: aCollection isEmpty description: 'Ellipses should not have patternChildren'.
	super patternChildren: aCollection
]

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> reset [

	super reset.
	self currentSize: 0
]

{ #category : #'pattern matching' }
SBEllipsisPattern >> searchRootFor: aDomainBlock at: anIndex [

	^ aDomainBlock patternChildren
		copyFrom: anIndex
		to: anIndex + self indexOffset
]

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> setLabelBindingsFor: aCollection in: aDict using: aBlockClosure [

	self labelBindingDict keysAndValuesDo: [:labelPosition :bindingName |
		aBlockClosure
			value: bindingName
			value: (aCollection collect: [:domainBlock | domainBlock propertyAt: labelPosition])]
]

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> wantsImplicitNeighbors [

	^ false
]

{ #category : #'as yet unclassified' }
SBEllipsisPattern >> wrapInMessageSend [
	"NO CHILDREN ALLOWED!
	
              ,-----.
            W/,-. ,-.\W
            ()>a   a<()
            (.--(_)--.)
          ,'/.-'/-\`-.\`.
        ,' /    `-'    \ `.
       /   \           /   \
      /     `.       ,'     \
     /    /   `-._.-'   \    \
   ,-`-._/|     |=|o    |\_.-<
  <,--.)  |_____| |o____|  )_ \
   `-)|    |//   _   \\|     )/
     ||    |'    |    `|
     ||    |     |     |
     ||    (    )|(    )
     ||    |     |     |
     ||    |     |     |
     ||    |_.--.|.--._|
     ||     /'"
	"| |"
	"`\
     []     `===' `==='  hjw"
	<action>

	
]
