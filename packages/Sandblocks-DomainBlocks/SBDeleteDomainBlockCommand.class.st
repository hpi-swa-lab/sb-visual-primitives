"
An SBDeleteDomainBlockCommand is a Command to remove an SBDomainBlock. It's removed from its world and hirachy. The Morphs in the primitive's patternChildren will be abandoned, too.

Instance Variables
	oldPatternParent:			SBBlock
	oldPatternSiblingIndex:	Number

oldPatternParent
	- saves the previous parent for do and undo

oldPatternSiblingIndex
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

	self oldPatternParent: target patternParent.
	self oldPatternParent isDomainBlock
		ifTrue: [self oldPatternSiblingIndex: target patternSiblingIndex]
		ifFalse: [target := target owner].
	super do.
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

	target isDomainBlock ifFalse: [^ super undo].
	self oldPatternParent ifNotNil: [self oldPatternParent addChild: target afterIndex: self oldPatternSiblingIndex - 1].
	^ target
]
