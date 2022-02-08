Class {
	#name : #SBVPPropertyMappingString,
	#superclass : #SBVPPropertyMapping,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingString class >> defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject [

	^ aSymbol isSymbol
		ifTrue: [[:vp | anObject perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol) asString]]
		ifFalse: [
			[:vp | "do nothing, because value should be constant"
			]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingString >> getMorphForValue: anObject [

	^ SBTextBubble new contents: anObject asString
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingString >> suggestionConstant [

	^ 'CONSTANT'
]
