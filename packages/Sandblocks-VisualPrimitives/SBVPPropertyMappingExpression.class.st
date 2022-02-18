"
An SBVPPropertyMappingExpression is used to display an Expression at the given vpProperty. This is mostly needed in VPBindingPatterns.
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

	^ (self
		getter: aBlock
		setter: [:ignore | ]
		vpProperty: aSymbol
		name: (self mappingName: aBlock evaluate withDefault: aBlock asSymbol)) originalMapping: aPropertyMapping
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
SBVPPropertyMappingExpression >> originalMapping: anObject [

	originalMapping := anObject
]

{ #category : #accessing }
SBVPPropertyMappingExpression >> writeValue: value on: aStream [

	aStream writeSourceOn: value.
	self assert: false.
	"This shouldn't be called ever"
	self flag: #BOB
	"<- Allan wanted this."
]
