Class {
	#name : #SBVPInsertCommand,
	#superclass : #SBInsertCommand,
	#instVars : [
		'parent'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPInsertCommand >> do [

	self parent addConnection: self morph.
	super do.
	self morph root
		attachTreeDecorator;
		layout.
	[self flag: #micha. "Julian wanted this"
	self morph root layout] fork.
	^ self morph
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

{ #category : #'as yet unclassified' }
SBVPInsertCommand >> undo [

	self parent removeConnection: self morph.
	super undo.
	self parent root layout.
	^ self morph
]
