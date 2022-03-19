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
			[:object :db | | patternChildren |
				patternChildren := db propertyAt: #patternChildren.
				(patternChildren notNil and: [patternChildren notEmpty]) ifTrue: [object perform: aSymbol asSimpleSetter with: patternChildren]]]
		ifFalse: [[:object :db | ]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock [

	| wrappedGetter wrappedSetter |
	wrappedGetter := [:object |
		(aBlock value: object)
			ifNil: [{}]
			ifNotNil: [:patternChildren | patternChildren reject: [:entry | entry isNil]]].
	wrappedSetter := [:object :db | anotherBlock value: object value: (db propertyAt: #patternChildren)].
	^ super
		getter: wrappedGetter
		setter: wrappedSetter
		dbProperty: #patternChildren
		name: 'patternChildren'
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock dbProperty: aSymbol [

	self assert: aSymbol = #children.
	^ self getter: aBlock setter: anotherBlock
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> getter: aBlock setter: anotherBlock patternValue: anObject dbProperty: aSymbol [

	anObject
		ifNotNil: [Error signal: 'SBPropertyMappingChildren does not support patternValue as this would lead to patterns recusively having patternChildren. This will result in an infinite number of patternChildren.']
		ifNil: [
			^ super
				getter: aBlock
				setter: anotherBlock
				patternValue: anObject
				dbProperty: aSymbol
				name: 'patternChildren']
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> property: aSymbol [

	^ super property: aSymbol dbProperty: #patternChildren
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren class >> property: aSymbol dbProperty: anotherSymbol [

	self assert: anotherSymbol = #children.
	^ self property: aSymbol
]

{ #category : #'as yet unclassified' }
SBPropertyMappingChildren >> initialize [

	super initialize.
	name := 'patternChildren'
]
