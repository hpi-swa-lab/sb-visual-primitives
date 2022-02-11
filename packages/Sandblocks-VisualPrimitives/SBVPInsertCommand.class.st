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
	self parent addConnection: self morph afterIndex: (self siblingIndex
		ifNotNil: [self siblingIndex - 1]
		ifNil: [self parent connections size]).
	
	" When adding a new root binding pattern, the row gets deleted and a new one is used.
	That is why we have to reset the container and index. "
	container := self parent owner.
	index := self container submorphCount.
	
	(self parent isKindOf: SBVPGroupPattern) ifFalse: [super do].
	
	self morph parentCase buildImplicitChildrenMatchingPattern.
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

	parent := anObject.
	self container: anObject owner
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

	self parent removeConnection: self morph.
	self children reverseDo: [:child | self parent addConnection: child afterIndex: self insertSiblingIndex].
	self morph connections do: [:connection | connection abandon].
	
	" When adding a new root binding pattern, the row gets deleted and a new one is used.
	That is why we have to reset the container. "
	container := self parent owner.
	super undo.
	self parent parentCase buildImplicitChildrenMatchingPattern.
	self parent root layout.
	^ self morph
]
