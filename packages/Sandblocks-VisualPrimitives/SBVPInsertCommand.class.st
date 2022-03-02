"
An SBVPInsertCommand is used to insert an SBVisualPrimitive into the current hierarchy.

Instance Variables
	children:			OrderedCollection of SBVisualPrimitives
	parent:			SBVisualPrimitive
	siblingIndex:	Number

children
	- SBVisualPrimitives that will be children of the inserted primitive

parent
	- parent primitive of the inserted one

siblingIndex
	- position index of the inserted primitive in the parent's children 

"
Class {
	#name : #SBVPInsertCommand,
	#superclass : #SBInsertCommand,
	#instVars : [
		'children',
		'parent',
		'siblingIndex'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #accessing }
SBVPInsertCommand >> children [

	^ children
]

{ #category : #accessing }
SBVPInsertCommand >> children: anOrderedCollection [

	children := anOrderedCollection
]

{ #category : #'as yet unclassified' }
SBVPInsertCommand >> do [

	((self parent isKindOf: SBVPGroupPattern) and: [self children notEmpty]) ifTrue: [self parent removeChild: self children first].
	self children do: [:child | self morph addChild: child].
	self parent ifNotNil: [
		self parent
			addChild: self morph
			afterIndex: (self siblingIndex ifNotNil: [self siblingIndex - 1] ifNil: [self parent children size]).
		
		" When adding a new root binding pattern, the row gets deleted and a new one is used.
		That is why we have to reset the container and index. "
		container := self parent owner.
		index := self container submorphCount].
	
	(self parent isKindOf: SBVPGroupPattern) ifFalse: [super do].
	
	self morph parentCase ifNotNil: #buildImplicitChildrenMatchingPattern.
	self morph root
		attachTreeDecorator;
		layout.
	^ self morph
]

{ #category : #'as yet unclassified' }
SBVPInsertCommand >> initialize [

	super initialize.
	self children: OrderedCollection new
]

{ #category : #'as yet unclassified' }
SBVPInsertCommand >> insertSiblingIndex [

	^ self siblingIndex
		ifNotNil: [self siblingIndex - 1]
		ifNil: [self parent children size]
]

{ #category : #accessing }
SBVPInsertCommand >> parent [

	^ parent
]

{ #category : #accessing }
SBVPInsertCommand >> parent: anSBBlock [

	parent := anSBBlock
]

{ #category : #accessing }
SBVPInsertCommand >> siblingIndex [

	^ siblingIndex
]

{ #category : #accessing }
SBVPInsertCommand >> siblingIndex: aNumber [

	siblingIndex := aNumber
]

{ #category : #'as yet unclassified' }
SBVPInsertCommand >> undo [

	| case root |
	case := self morph patternContainer.
	root := self morph root.
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
	root layout.
	^ self morph
]
