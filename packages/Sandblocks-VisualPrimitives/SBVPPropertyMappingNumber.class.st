"
An SBPropertyMappingNumber is used to map from a property that's a Number to a vpProperty and back. The Morph that will be displayed is an SBStNumber.

"
Class {
	#name : #SBPropertyMappingNumber,
	#superclass : #SBPropertyMapping,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPropertyMappingNumber class >> defaultSetterBlockWith: aSymbol for: anotherSymbol [

	^ aSymbol isSymbol
		ifTrue: [[:object :vp | (vp propertyAt: anotherSymbol) ifNotNil: [object perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol) asNumber]]]
		ifFalse: [
			[:object :vp | "do nothing, because value should be constant"
			]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingNumber >> getMorphForValue: anObject [

	^ SBStNumber new contents: anObject asString
]

{ #category : #'as yet unclassified' }
SBPropertyMappingNumber >> suggestionConstant [

	^ 0
]
