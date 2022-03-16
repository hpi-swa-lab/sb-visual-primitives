"
An SBInsertDomainBlockCommand is used to insert an SBDomainBlock into the current hierarchy.

Instance Variables
	patternChildren:			OrderedCollection of SBDomainBlocks
	parent:			SBDomainBlock
	siblingIndex:	Number

patternChildren
	- SBDomainBlocks that will be patternChildren of the inserted primitive

parent
	- parent primitive of the inserted one

siblingIndex
	- position index of the inserted primitive in the parent's patternChildren 

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

{ #category : #'as yet unclassified' }
SBInsertDomainBlockCommand >> do [
	
	(self patternParent isBindingPattern not and: [self patternChildren notEmpty]) ifTrue: [self patternParent removeChild: self patternChildren first].
	self patternChildren do: [:child | self morph addChild: child].
	self patternParent ifNotNil: [
		self patternParent addChild: self morph afterIndex: self insertSiblingIndex.
		
		" When adding a new root binding pattern, the row gets deleted and a new one is used.
		That is why we have to reset the container and index. "
		container := self patternParent owner.
		index := self container submorphCount].
	
	self patternParent isBindingPattern ifTrue: [super do].
	
	self morph allChildrenDo: [:child | self container addMorphBack: child].
	self morph patternContainer ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ self morph
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBInsertDomainBlockCommand >> undo [

	| case |
	case := self morph patternContainer.
	self patternParent
		ifNotNil: [			
			" When adding a new root binding pattern, the row gets deleted and a new one is used.
			That is why we have to reset the container. "
			container := self patternParent owner.
			self patternChildren reverseDo: [:child | self patternParent addChild: child afterIndex: self insertSiblingIndex]]
		ifNil: [self patternChildren do: [:child | self morph removeChild: child]].
	self morph patternChildren do: [:child | child abandon].
	
	super undo.
	case ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ self morph
]
