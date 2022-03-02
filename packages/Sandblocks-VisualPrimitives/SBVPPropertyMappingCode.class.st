Class {
	#name : #SBVPPropertyMappingCode,
	#superclass : #SBVPPropertyMapping,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingCode >> getLabelContents: anObject [

	^ Compiler evaluate: anObject firstSubmorph sourceString
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingCode >> getMorphForValue: aClosure [

	^ aClosure asSandblock
]
