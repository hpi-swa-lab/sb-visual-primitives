Class {
	#name : #SBVPEllipsisPattern,
	#superclass : #SBVPBindingPattern,
	#instVars : [
		'currentSize'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> addImplicitChildren: aDict [

	
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> bindingIndexWithImplicitPrefix: aBoolean [

	self bindingIndex ifNil: [^ nil].
	aBoolean
		ifTrue: [
			(self bindingIndex beginsWith: self implicitPrefix)
				ifTrue: [^ self bindingIndex]
				ifFalse: [^ self implicitPrefix, self bindingIndex]]
		ifFalse: [
			(self bindingIndex beginsWith: self implicitPrefix)
				ifTrue: [^ self bindingIndex from: self implicitPrefix size + 1]
				ifFalse: [^ self bindingIndex]]
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> buildFromBinding: anArray [

	^ (anArray at: self bindingIndex) veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> buildImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> connections: aCollection [

	self assert: aCollection isEmpty description: 'Ellipses should not have children'.
	super connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> convertToBindingPattern [
	<action>

	self sandblockEditor do: (SBCombinedCommand newWith: {
		SBVPDeleteCommand new target: self.
		SBVPInsertCommand new
			index: self owner submorphCount + 1;
			parent: self parent;
			container: self owner;
			siblingIndex: self siblingIndex;
			morph: (SBVPBindingPattern bindingDict: {self class identityName -> self bindingIndex} asDictionary);
			shouldMergeWithNext: false;
			yourself})
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> convertToEllipsisPattern [
	"we done here"

	
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> couldMatch: aVisualPrimitive [

	^ true
]

{ #category : #accessing }
SBVPEllipsisPattern >> currentSize [

	^ currentSize
]

{ #category : #accessing }
SBVPEllipsisPattern >> currentSize: anObject [

	currentSize := anObject
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> doubleClick: anEvent [

	self isImplicitChild: self isImplicitChild not
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> getNext: aVisualPrimitive [

	self currentSize: self currentSize + 1.
	^ true
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> implicitPrefix [

	^ 'i_'
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> indexOffset [

	^ self currentSize - 1
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> initialize [

	super initialize.
	self currentSize: 0.
	self
		addMorph: SBIcon iconEllipsisH large;
		cellPositioning: #center
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> isBindingPattern [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> isImplicitChild: aBoolean [

	| setColor previousImplicit prevBindingIndex |
	previousImplicit := self isImplicitChild.
	super isImplicitChild: aBoolean.
	previousImplicit = self isImplicitChild ifTrue: [^ self].
	prevBindingIndex := self bindingIndex.
	self bindingIndex: (self bindingIndexWithImplicitPrefix: aBoolean).
	setColor := [:color |
		self childSandblocksDo: [:block | block color: color].
		self firstSubmorph class = SBRow ifFalse: [self firstSubmorph color: color]].
	self isImplicitChild
		ifTrue: [setColor value: Color gray]
		ifFalse: [setColor value: Color black].
	"If called with isImplicitChild not changing, this leads to an infinite loop."
	self parentCase ifNotNil: [:parentCase | parentCase toggleImplicitChildTo: self isImplicitChild withBinding: prevBindingIndex]
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> reset [

	super reset.
	self currentSize: 0
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> searchRootFor: aVisualPrimitive at: anIndex [

	^ aVisualPrimitive connections
		copyFrom: anIndex
		to: anIndex + self indexOffset
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> wantsImplicitNeighbors [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> wrapInMessageSend [
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
