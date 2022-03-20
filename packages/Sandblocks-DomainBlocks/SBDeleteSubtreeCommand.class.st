"
An SBDeleteSubtreeCommand is used to delete a domain block and its children.

Instance Variables
	command:		SBCombinedCommand
	target:			SBDomainBlock

command
	- the command what is to be done

target
	- the domain block to be deleted

"
Class {
	#name : #SBDeleteSubtreeCommand,
	#superclass : #SBCommand,
	#instVars : [
		'command',
		'target'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #accessing }
SBDeleteSubtreeCommand >> collectDescendantsPostOrder: aPattern [

	| result |
	result := OrderedCollection new.
	aPattern patternChildren do: [:child | result addAll: (self collectDescendantsPostOrder: child)].
	result add: aPattern.
	^ result
]

{ #category : #accessing }
SBDeleteSubtreeCommand >> command [

	^ command
]

{ #category : #accessing }
SBDeleteSubtreeCommand >> command: anObject [

	command := anObject
]

{ #category : #'do-undo' }
SBDeleteSubtreeCommand >> do [

	| selection container |
	container := self target patternContainer.
	self command ifNil: [self command: (SBCombinedCommand newWith: ((self collectDescendantsPostOrder: self target) collect: [:aPattern | SBDeleteDomainBlockCommand new target: aPattern]))].
	selection := self command do.
	container ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ selection
]

{ #category : #accessing }
SBDeleteSubtreeCommand >> setArtefactFrom [

	^ target
]

{ #category : #accessing }
SBDeleteSubtreeCommand >> target [

	^ target
]

{ #category : #accessing }
SBDeleteSubtreeCommand >> target: anSBDomainBlock [

	target := anSBDomainBlock
]

{ #category : #'do-undo' }
SBDeleteSubtreeCommand >> undo [

	| selection |
	selection := self command undo.
	self target patternContainer ifNotNil: #buildImplicitChildrenMatchingPattern.
	^ selection
]
