"
An SBInsertDomainBlockCommand is used to insert an SBDomainBlock into the current hierarchy.

Instance Variables
	children:			OrderedCollection of SBDomainBlocks
	parent:			SBDomainBlock
	siblingIndex:	Number

children
	- SBDomainBlocks that will be children of the inserted primitive

parent
	- parent primitive of the inserted one

siblingIndex
	- position index of the inserted primitive in the parent's children 

"
Class {
	#name : #SBInsertDomainBlockCommand,
	#superclass : #SBInsertCommand,
	#instVars : [
		'children',
		'parent',
		'siblingIndex'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #accessing }
SBInsertDomainBlockCommand >> children [

	^ children
]

{ #category : #accessing }
SBInsertDomainBlockCommand >> children: anOrderedCollection [

	children := anOrderedCollection
]

{ #category : #'as yet unclassified' }
SBInsertDomainBlockCommand >> do [

	((self parent isBindingPattern not) and: [self children notEmpty]) ifTrue: [self parent removeChild: self children first].
	self children do: [:child | self morph addChild: child].
	self parent ifNotNil: [
		self parent
			addChild: self morph
			afterIndex: (self siblingIndex ifNotNil: [self siblingIndex - 1] ifNil: [self parent children size]).
		
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
	self children: OrderedCollection new
]

{ #category : #'as yet unclassified' }
SBInsertDomainBlockCommand >> insertSiblingIndex [

	^ self siblingIndex
		ifNotNil: [self siblingIndex - 1]
		ifNil: [self parent children size]
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
			self children reverseDo: [:child | self parent addChild: child afterIndex: self insertSiblingIndex]]
		ifNil: [self children do: [:child | self morph removeChild: child]].
	self morph children do: [:child | child abandon].
	
	super undo.
	case ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ self morph
]
