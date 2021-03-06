"
An SBPropertyMappingExpression is used to display an expression at the given dbProperty. This is mostly needed in SBBindingPatterns.

Instance Variables
	originalMapping: SBPropertyMapping

originalMapping
	- contains the original property mapping

"
Class {
	#name : #SBPropertyMappingExpression,
	#superclass : #SBPropertyMapping,
	#instVars : [
		'originalMapping'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #'as yet unclassified' }
SBPropertyMappingExpression class >> expression: aBlock dbProperty: aSymbol originalMapping: aPropertyMapping [

	^ (self getter: aBlock setter: [:ignore | ] dbProperty: aSymbol name: aPropertyMapping name) originalMapping: aPropertyMapping
]

{ #category : #accessing }
SBPropertyMappingExpression >> getMorphFor: anObject [

	| value |
	self originalMapping ifNil: [^ self getter asSandblock].
	value := self getter on: Error do: [nil].
	^ value ifNil: [self getter asSandblock] ifNotNil: [self originalMapping getMorphForValue: value]
]

{ #category : #accessing }
SBPropertyMappingExpression >> originalMapping [

	^ originalMapping
]

{ #category : #accessing }
SBPropertyMappingExpression >> originalMapping: aPropertyMapping [

	originalMapping := aPropertyMapping
]

{ #category : #accessing }
SBPropertyMappingExpression >> value: ignored [

	^ self getter value
]
