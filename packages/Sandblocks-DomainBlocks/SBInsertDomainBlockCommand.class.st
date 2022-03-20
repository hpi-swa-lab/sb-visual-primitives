"
An SBInsertDomainBlockCommand is used to insert an SBDomainBlock into the current hierarchy.

Instance Variables
	patternChildren:		OrderedCollection of SBDomainBlocks
	patternParent:			SBDomainBlock
	patternSiblingIndex:	Number

patternChildren
	- SBDomainBlocks that will be patternChildren of the inserted primitive

patternParent
	- parent pattern of the inserted one

patternSiblingIndex
	- position index of the inserted pattern in the patternParent's patternChildren 

"
Class {
	#name : #SBInsertDomainBlockCommand,
	#superclass : #SBInsertCommand,
	#instVars : [
		'patternChildren',
		'patternParent',
		'patternSiblingIndex'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #apply }
SBInsertDomainBlockCommand >> do [

	container := self patternParent isDomainBlock
		ifTrue: [self patternParent owner]
		ifFalse: [self patternChildren first owner].
	index := self container submorphCount.
	
	self patternChildren do: [:child |
		child patternParent isDomainBlock
			ifTrue: [self morph addChild: child]
			ifFalse: [self morph addConnectorLineTo: child afterIndex: self morph patternChildren size]].
	self patternParent isDomainBlock ifTrue: [self patternParent addChild: self morph afterIndex: self insertSiblingIndex].
	
	super do.
	
	self morph allChildrenDo: [:child | self container addMorphBack: child].
	self morph patternContainer ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ self morph
]

{ #category : #'initialize-release' }
SBInsertDomainBlockCommand >> initialize [

	super initialize.
	self patternChildren: OrderedCollection new
]

{ #category : #'as yet unclassified' }
SBInsertDomainBlockCommand >> insertSiblingIndex [

	^ self patternSiblingIndex
		ifNotNil: [self patternSiblingIndex - 1]
		ifNil: [self patternParent patternChildren size]
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> patternChildren [

	^ patternChildren
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> patternChildren: anOrderedCollection [

	patternChildren := anOrderedCollection
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> patternParent [

	^ patternParent
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> patternParent: anSBBlock [

	patternParent := anSBBlock
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> patternSiblingIndex [

	^ patternSiblingIndex
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> patternSiblingIndex: aNumber [

	patternSiblingIndex := aNumber
]

{ #category : #apply }
SBInsertDomainBlockCommand >> undo [

	| case |
	case := self morph patternContainer.
	self patternParent ifNotNil: [self patternParent isDomainBlock ifTrue: [self patternChildren reverseDo: [:child | self patternParent addChild: child afterIndex: self insertSiblingIndex]]].
	self morph patternChildren do: [:child | (self patternChildren includes: child) not ifTrue: [self morph removeChild: child]].
	self morph allConnections do: #delete.
	
	super undo.
	case ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ self morph
]
