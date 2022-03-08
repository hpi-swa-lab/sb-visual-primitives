"
An SBPropertyMappingString is used to map from a property that's a String to a vpProperty and back. The Morph that will be displayed is an SBTextBubble.

"
Class {
	#name : #SBPropertyMappingString,
	#superclass : #SBPropertyMapping,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPropertyMappingString class >> defaultSetterBlockWith: aSymbol for: anotherSymbol [

	^ aSymbol isSymbol
		ifTrue: [[:object :vp | (vp propertyAt: anotherSymbol) ifNotNil: [object perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol) asString]]]
		ifFalse: [
			[:object :vp | "do nothing, because value should be constant"
			]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingString >> getMorphForValue: anObject [

	^ anObject ifNotNil: [(self isConstant ifTrue: [SBStringMorph] ifFalse: [SBTextBubble]) new contents: anObject asString]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingString >> suggestionConstant [

	^ 'CONSTANT'
]
