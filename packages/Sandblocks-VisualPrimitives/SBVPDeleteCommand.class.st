Class {
	#name : #SBVPDeleteCommand,
	#superclass : #SBDeleteCommand,
	#instVars : [
		'oldParent',
		'oldSiblingIndex'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPDeleteCommand >> do [

	super do.
	
	self oldParent: target parent.
	self oldSiblingIndex: target siblingIndex.
	self oldParent ifNotNil: [self oldParent removeConnection: target].
	target allConnectionsDo: [:block | block abandon].
	self oldParent ifNotNil: #layout.
	^ self oldParent
]

{ #category : #accessing }
SBVPDeleteCommand >> oldParent [

	^ oldParent
]

{ #category : #accessing }
SBVPDeleteCommand >> oldParent: anObject [

	oldParent := anObject
]

{ #category : #accessing }
SBVPDeleteCommand >> oldSiblingIndex [

	^ oldSiblingIndex
]

{ #category : #accessing }
SBVPDeleteCommand >> oldSiblingIndex: anObject [

	oldSiblingIndex := anObject
]

{ #category : #'as yet unclassified' }
SBVPDeleteCommand >> undo [

	self oldParent ifNotNil: [self oldParent addConnection: target afterIndex: self oldSiblingIndex - 1].
	super undo.
	target allConnectionsDo: [:block | target owner addMorphBack: block].
	target
		layout;
		layout;
		flag: #TODO.
	"Layout twice is required for some reason"
	^ target
]
