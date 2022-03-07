"
An SBVPDeleteCommand is a Command to remove an SBVisualPrimitive. It's removed from its world and hirachy. The Morphs in the primitive's children will be abandoned, too.

Instance Variables
	oldParent:			SBBlock
	oldSiblingIndex:	Number

oldParent
	- saves the previous parent for do and undo

oldSiblingIndex
	- previous position index of the deleted primitive in the parent's children

"
Class {
	#name : #SBVPDeleteCommand,
	#superclass : #SBDeleteCommand,
	#instVars : [
		'oldParent',
		'oldSiblingIndex'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'do-undo' }
SBVPDeleteCommand >> do [

	oldOwner := target owner.
	super do.
	
	self oldParent: target parent.
	self oldSiblingIndex: target siblingIndex.
	self oldParent ifNotNil: [self oldParent removeChild: target].
	target allChildrenDo: [:block | block abandon].
	self oldParent parentCase ifNotNil: #buildImplicitChildrenMatchingPattern.
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
SBVPDeleteCommand >> oldSiblingIndex: aNumber [

	oldSiblingIndex := aNumber
]

{ #category : #'do-undo' }
SBVPDeleteCommand >> undo [

	self oldParent ifNotNil: [self oldParent addChild: target afterIndex: self oldSiblingIndex - 1].
	
	(self oldParent isKindOf: SBVPGroupPattern) ifFalse: [
		target allChildrenDo: [:block | oldOwner addMorphBack: block].
		super undo].
	self oldParent parentCase ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ target
]
