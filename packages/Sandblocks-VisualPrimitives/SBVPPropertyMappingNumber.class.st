"
An SBVPPropertyMappingNumber is used to map from a property that's a Number to a vpProperty and back. The Morph that will be displayed is a SBStNumber.

"
Class {
	#name : #SBVPPropertyMappingNumber,
	#superclass : #SBVPPropertyMapping,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingNumber class >> defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject [

	^ aSymbol isSymbol
		ifTrue: [[:vp | anObject perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol) asNumber]]
		ifFalse: [
			[:vp | "do nothing, because value should be constant"
			]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingNumber >> getMorphForValue: anObject [

	^ SBStNumber new contents: anObject asString
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingNumber >> suggestionConstant [

	^ 0
]
