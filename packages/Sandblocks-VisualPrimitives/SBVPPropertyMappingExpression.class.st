"
An SBVPPropertyMappingExpression is used to display an expression at the given vpProperty. This is mostly needed in SBVPBindingPatterns.

Instance Variables
	originalMapping: SBVPPropertyMapping

originalMapping
	- contains the original property mapping
"
Class {
	#name : #SBVPPropertyMappingExpression,
	#superclass : #SBVPPropertyMapping,
	#instVars : [
		'originalMapping'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingExpression class >> expression: aBlock vpProperty: aSymbol originalMapping: aPropertyMapping [

	^ (self getter: aBlock setter: [:ignore | ] vpProperty: aSymbol name: aPropertyMapping name) originalMapping: aPropertyMapping
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingExpression >> getMorphFor: anObject [

	| value |
	self originalMapping ifNil: [^ self getter asSandblock].
	value := self getter on: Error do: [nil].
	^ value ifNil: [self getter asSandblock] ifNotNil: [self originalMapping getMorphForValue: value]
]

{ #category : #accessing }
SBVPPropertyMappingExpression >> originalMapping [

	^ originalMapping
]

{ #category : #accessing }
SBVPPropertyMappingExpression >> originalMapping: aPropertyMapping [

	originalMapping := aPropertyMapping
]

{ #category : #accessing }
SBVPPropertyMappingExpression >> value: ignored [

	^ self getter value
]

{ #category : #accessing }
SBVPPropertyMappingExpression >> writeValue: value on: aStream [

	aStream writeSourceOn: value.
	self assert: false.
	"This shouldn't be called ever"
	self flag: #BOB
	"<- Allan wanted this."
]
