"
An SBDeleteDomainBlockCommand is a Command to remove an SBDomainBlock. It's removed from its world and hirachy. The Morphs in the primitive's patternChildren will be abandoned, too.

Instance Variables
	oldParent:			SBBlock
	oldSiblingIndex:	Number

oldParent
	- saves the previous parent for do and undo

oldSiblingIndex
	- previous position index of the deleted primitive in the parent's patternChildren

"
Class {
	#name : #SBDeleteDomainBlockCommand,
	#superclass : #SBDeleteCommand,
	#instVars : [
		'oldPatternParent',
		'oldPatternSiblingIndex'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'do-undo' }
SBDeleteDomainBlockCommand >> do [

	oldOwner := target owner.
	super do.
	
	self oldPatternParent: target patternParent.
	self oldPatternSiblingIndex: target patternSiblingIndex.
	self oldPatternParent ifNotNil: [self oldPatternParent removeChild: target].
	target allChildrenDo: [:block | block abandon].
	self oldPatternParent patternContainer ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ self oldPatternParent
]

{ #category : #accessing }
SBDeleteDomainBlockCommand >> oldPatternParent [

	^ oldPatternParent
]

{ #category : #accessing }
SBDeleteDomainBlockCommand >> oldPatternParent: anObject [

	oldPatternParent := anObject
]

{ #category : #accessing }
SBDeleteDomainBlockCommand >> oldPatternSiblingIndex [

	^ oldPatternSiblingIndex
]

{ #category : #accessing }
SBDeleteDomainBlockCommand >> oldPatternSiblingIndex: aNumber [

	oldPatternSiblingIndex := aNumber
]

{ #category : #'do-undo' }
SBDeleteDomainBlockCommand >> undo [

	self oldPatternParent ifNotNil: [self oldPatternParent addChild: target afterIndex: self oldPatternSiblingIndex - 1].
	
	self oldPatternParent isBindingPattern ifTrue: [
		target allChildrenDo: [:block | oldOwner addMorphBack: block].
		super undo].
	self oldPatternParent patternContainer ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ target
]
