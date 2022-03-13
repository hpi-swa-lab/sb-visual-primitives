"
A SBPropertyMappingCode is xxxxxxxxx.

"
Class {
	#name : #SBPropertyMappingCode,
	#superclass : #SBPropertyMapping,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPropertyMappingCode >> getLabelContents: anObject [

	^ Compiler evaluate: anObject firstSubmorph sourceString
]

{ #category : #'as yet unclassified' }
SBPropertyMappingCode >> getMorphForValue: aClosure [

	^ aClosure asSandblock
]
