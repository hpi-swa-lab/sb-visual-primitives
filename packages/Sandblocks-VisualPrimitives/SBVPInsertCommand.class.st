"
A SBVPInsertCommand is used to Insert a SBVisualPrimitive into the current hirachy.

Instance Variables
	children:		OrderedCollection of SBVisualPrimitives
	parent:			SBVisualPrimitive
	siblingIndex:	Number

children
	- SBVisualPrimitives that will be connections of the inserted primitive

parent
	- parent primitive of the inserted one

siblingIndex
	- position index of the inserted primitive in the parent's connections 

"
Class {
	#name : #SBVPInsertCommand,
	#superclass : #SBInsertCommand,
	#instVars : [
		'parent',
		'siblingIndex',
		'children'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #accessing }
SBVPInsertCommand >> children [

	^ children
]

{ #category : #accessing }
SBVPInsertCommand >> children: anObject [

	children := anObject
]

{ #category : #'as yet unclassified' }
SBVPInsertCommand >> do [

	((self parent isKindOf: SBVPGroupPattern) and: [self children notEmpty]) ifTrue: [self parent removeConnection: self children first].
	self children do: [:child | self morph addConnection: child].
	self parent ifNotNil: [
		self parent addConnection: self morph afterIndex: (self siblingIndex
			ifNotNil: [self siblingIndex - 1]
			ifNil: [self parent connections size]).
		
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
		ifNil: [self parent connections size]
]

{ #category : #accessing }
SBVPInsertCommand >> parent [

	^ parent
]

{ #category : #accessing }
SBVPInsertCommand >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
SBVPInsertCommand >> siblingIndex [

	^ siblingIndex
]

{ #category : #accessing }
SBVPInsertCommand >> siblingIndex: anObject [

	siblingIndex := anObject
]

{ #category : #'as yet unclassified' }
SBVPInsertCommand >> undo [

	| case root |
	case := self morph parentCaseOrQuery.
	root := self morph root.
	self parent
		ifNotNil: [
			self parent removeConnection: self morph.
			
			" When adding a new root binding pattern, the row gets deleted and a new one is used.
			That is why we have to reset the container. "
			container := self parent owner.
			self children reverseDo: [:child | self parent addConnection: child afterIndex: self insertSiblingIndex]]
		ifNil: [self children do: [:child | self morph removeConnection: child]].
	self morph connections do: [:connection | connection abandon].
	
	super undo.
	case ifNotNil: #buildImplicitChildrenMatchingPattern.
	root layout.
	^ self morph
]
