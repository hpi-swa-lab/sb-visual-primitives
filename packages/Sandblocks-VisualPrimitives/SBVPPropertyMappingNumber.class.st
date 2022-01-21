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
SBVPPropertyMappingNumber >> getMorph [

	^ SBStNumber new contents: self getter value asString
]