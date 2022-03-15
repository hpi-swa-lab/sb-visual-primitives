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
		'parent',
		'siblingIndex'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #accessing }
SBInsertDomainBlockCommand >> patternChildren [

	^ patternChildren
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> patternChildren: anOrderedCollection [

	patternChildren := anOrderedCollection
]

{ #category : #'as yet unclassified' }
SBInsertDomainBlockCommand >> do [

	(self parent isBindingPattern not and: [self patternChildren notEmpty]) ifTrue: [self parent removeChild: self patternChildren first].
	self patternChildren do: [:child | self morph addChild: child].
	self parent ifNotNil: [
		self parent
			addChild: self morph
			afterIndex: (self siblingIndex ifNotNil: [self siblingIndex - 1] ifNil: [self parent patternChildren size]).
		
		" When adding a new root binding pattern, the row gets deleted and a new one is used.
		That is why we have to reset the container and index. "
		container := self parent owner.
		index := self container submorphCount].
	
	self parent isBindingPattern ifTrue: [super do].
	
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

	^ self siblingIndex
		ifNotNil: [self siblingIndex - 1]
		ifNil: [self parent patternChildren size]
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> parent [

	^ parent
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> parent: anSBBlock [

	parent := anSBBlock
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> siblingIndex [

	^ siblingIndex
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> siblingIndex: aNumber [

	siblingIndex := aNumber
]

{ #category : #'as yet unclassified' }
SBInsertDomainBlockCommand >> undo [

	| case |
	case := self morph patternContainer.
	self parent
		ifNotNil: [
			self parent removeChild: self morph.
			
			" When adding a new root binding pattern, the row gets deleted and a new one is used.
			That is why we have to reset the container. "
			container := self parent owner.
			self patternChildren reverseDo: [:child | self parent addChild: child afterIndex: self insertSiblingIndex]]
		ifNil: [self patternChildren do: [:child | self morph removeChild: child]].
	self morph patternChildren do: [:child | child abandon].
	
	super undo.
	case ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ self morph
]
