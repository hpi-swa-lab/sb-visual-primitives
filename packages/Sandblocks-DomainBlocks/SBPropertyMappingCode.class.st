"
A SBPropertyMappingCode is used to map from a property that's a closure to a vpProperty and back. The Morph that will be displayed is a sandblock showing the code of that closure.

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
