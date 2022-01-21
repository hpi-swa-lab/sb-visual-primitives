Class {
	#name : #SBVPPropertyMappingNumber,
	#superclass : #SBVPPropertyMapping,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingNumber class >> property: aSymbol primitiveProperty: anotherSymbol on: anObject [

	| getterBlock setterBlock |
	getterBlock := [anObject perform: aSymbol asSimpleGetter].
	setterBlock := [:vp | anObject perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol) asNumber].
	
	^ SBVPPropertyMappingNumber
		getter: getterBlock
		setter: setterBlock
		position: anotherSymbol
		optionalArgs: Dictionary new
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingNumber >> getMorph [

	^ SBStNumber new contents: self getter value asString
]
