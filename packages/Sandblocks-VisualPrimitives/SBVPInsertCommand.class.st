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

	self parent addConnection: self morph afterIndex: (self siblingIndex
		ifNotNil: [self siblingIndex - 1]
		ifNil: [self parent connections size]).
	self children do: [:child | self morph addConnection: child].
	super do.
	self morph root
		attachTreeDecorator;
		layout;
		layout;
		flag: #TODO.
	"Layout twice is required for some reason"
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
	super undo.
	self parent root layout.
	^ self morph
]
