Class {
	#name : #SBVPPropertyMappingString,
	#superclass : #SBVPPropertyMapping,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingString class >> property: aSymbol primitiveProperty: anotherSymbol on: anObject [

	| getterBlock setterBlock |
	getterBlock := [anObject perform: aSymbol asSimpleGetter].
	setterBlock := [:vp | anObject perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol) asString].
	
	^ SBVPPropertyMappingString
		getter: getterBlock
		setter: setterBlock
		position: anotherSymbol
		optionalArgs: Dictionary new
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingString >> getMorph [

	^ SBTextBubble new contents: self getter value asString
]
