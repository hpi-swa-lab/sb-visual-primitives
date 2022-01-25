Class {
	#name : #SBVPPropertyMappingExpression,
	#superclass : #SBVPPropertyMapping,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingExpression class >> expression: aBlock position: aSymbol [

	^ self getter: aBlock setter: [:ignore | ] position: aSymbol
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingExpression >> getMorph [

	^ self getter asSandblock
]
