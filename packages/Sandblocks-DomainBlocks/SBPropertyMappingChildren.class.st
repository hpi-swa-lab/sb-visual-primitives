"
An SBPropertyMappingChildren is used to map to and from the children of an SBDomainBlock.

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
			[:object | | children |
				children := object perform: aSymbol asSimpleGetter.
				children ifNil: [nil] ifNotNil: [children reject: [:entry | entry isNil]]]]
		ifFalse: [[:object | aSymbol]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> defaultSetterBlockWith: aSymbol for: ignored [

	^ aSymbol isSymbol
		ifTrue: [
			[:object :vp | | children |
				children := vp propertyAt: #children.
				(children notNil and: [children notEmpty]) ifTrue: [object perform: aSymbol asSimpleSetter with: children]]]
		ifFalse: [[:object :vp | ]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock [

	| wrappedGetter wrappedSetter |
	wrappedGetter := [:object |
		(aBlock value: object)
			ifNil: [{}]
			ifNotNil: [:children | children reject: [:entry | entry isNil]]].
	wrappedSetter := [:object :vp | anotherBlock value: object value: (vp propertyAt: #children)].
	^ super getter: wrappedGetter setter: wrappedSetter vpProperty: #children name: 'children'
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock patternValue: anObject vpProperty: aSymbol [

	anObject
		ifNotNil: [Error signal: 'SBPropertyMappingChildren does not support patternValue as this would lead to patterns recusively having children. This will result in an infinite number of children.']
		ifNil: [^ super getter: aBlock setter: anotherBlock patternValue: anObject vpProperty: aSymbol name: 'children']
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock vpProperty: aSymbol [

	self assert: aSymbol = #children.
	^ self getter: aBlock setter: anotherBlock
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> property: aSymbol [

	^ super property: aSymbol vpProperty: #children
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> property: aSymbol vpProperty: anotherSymbol [

	self assert: anotherSymbol = #children.
	^ self property: aSymbol
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren >> initialize [

	super initialize.
	name := 'children'
]
