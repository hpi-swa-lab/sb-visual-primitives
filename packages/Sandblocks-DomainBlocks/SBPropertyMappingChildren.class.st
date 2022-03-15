"
An SBPropertyMappingChildren is used to map to and from the patternChildren of an SBDomainBlock.

"
Class {
	#name : #SBPropertyMappingChildren,
	#superclass : #SBPropertyMapping,
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> defaultGetterBlockWith: aSymbol [

	^ aSymbol isSymbol
		ifTrue: [
			[:object | | patternChildren |
				patternChildren := object perform: aSymbol asSimpleGetter.
				patternChildren ifNil: [nil] ifNotNil: [patternChildren reject: [:entry | entry isNil]]]]
		ifFalse: [[:object | aSymbol]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> defaultSetterBlockWith: aSymbol for: ignored [

	^ aSymbol isSymbol
		ifTrue: [
			[:object :vp | | patternChildren |
				patternChildren := vp propertyAt: #patternChildren.
				(patternChildren notNil and: [patternChildren notEmpty]) ifTrue: [object perform: aSymbol asSimpleSetter with: patternChildren]]]
		ifFalse: [[:object :vp | ]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock [

	| wrappedGetter wrappedSetter |
	wrappedGetter := [:object |
		(aBlock value: object)
			ifNil: [{}]
			ifNotNil: [:patternChildren | patternChildren reject: [:entry | entry isNil]]].
	wrappedSetter := [:object :vp | anotherBlock value: object value: (vp propertyAt: #patternChildren)].
	^ super getter: wrappedGetter setter: wrappedSetter vpProperty: #patternChildren name: 'patternChildren'
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock patternValue: anObject vpProperty: aSymbol [

	anObject
		ifNotNil: [Error signal: 'SBPropertyMappingChildren does not support patternValue as this would lead to patterns recusively having patternChildren. This will result in an infinite number of patternChildren.']
		ifNil: [^ super getter: aBlock setter: anotherBlock patternValue: anObject vpProperty: aSymbol name: 'patternChildren']
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock vpProperty: aSymbol [

	self assert: aSymbol = #patternChildren.
	^ self getter: aBlock setter: anotherBlock
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> property: aSymbol [

	^ super property: aSymbol vpProperty: #patternChildren
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> property: aSymbol vpProperty: anotherSymbol [

	self assert: anotherSymbol = #patternChildren.
	^ self property: aSymbol
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren >> initialize [

	super initialize.
	name := 'patternChildren'
]
