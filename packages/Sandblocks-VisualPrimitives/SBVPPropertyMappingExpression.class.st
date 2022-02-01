Class {
	#name : #SBVPPropertyMappingExpression,
	#superclass : #SBVPPropertyMapping,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingExpression class >> expression: aBlock vpProperty: aSymbol [

	^ self getter: aBlock setter: [:ignore | ] vpProperty: aSymbol
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingExpression >> getMorphFor: anObject [

	^ self getter asSandblock
]
