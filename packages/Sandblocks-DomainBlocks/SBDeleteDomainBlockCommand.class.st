"
An SBDeleteDomainBlockCommand is a Command to remove an SBDomainBlock. It's removed from its world and hirachy. The Morphs in the primitive's children will be abandoned, too.

Instance Variables
	oldParent:			SBBlock
	oldSiblingIndex:	Number

oldParent
	- saves the previous parent for do and undo

oldSiblingIndex
	- previous position index of the deleted primitive in the parent's children

"
Class {
	#name : #SBDeleteDomainBlockCommand,
	#superclass : #SBDeleteCommand,
	#instVars : [
		'oldParent',
		'oldSiblingIndex'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'do-undo' }
SBDeleteDomainBlockCommand >> do [

	oldOwner := target owner.
	super do.
	
	self oldParent: target parent.
	self oldSiblingIndex: target siblingIndex.
	self oldParent ifNotNil: [self oldParent removeChild: target].
	target allChildrenDo: [:block | block abandon].
	self oldParent patternContainer ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ self oldParent
]

{ #category : #accessing }
SBDeleteDomainBlockCommand >> oldParent [

	^ oldParent
]

{ #category : #accessing }
SBDeleteDomainBlockCommand >> oldParent: anObject [

	oldParent := anObject
]

{ #category : #accessing }
SBDeleteDomainBlockCommand >> oldSiblingIndex [

	^ oldSiblingIndex
]

{ #category : #accessing }
SBDeleteDomainBlockCommand >> oldSiblingIndex: aNumber [

	oldSiblingIndex := aNumber
]

{ #category : #'do-undo' }
SBDeleteDomainBlockCommand >> undo [

	self oldParent ifNotNil: [self oldParent addChild: target afterIndex: self oldSiblingIndex - 1].
	
	self oldParent isBindingPattern ifTrue: [
		target allChildrenDo: [:block | oldOwner addMorphBack: block].
		super undo].
	self oldParent patternContainer ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ target
]
