"
An SBVPPropertyMappingConnections is used to map to and from the connections of a SBVisualPrimitive.
"
Class {
	#name : #SBVPPropertyMappingConnections,
	#superclass : #SBVPPropertyMapping,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingConnections class >> defaultGetterBlockWith: aSymbol [

	^ aSymbol isSymbol
		ifTrue: [
			[:object | | connections |
				connections := object perform: aSymbol asSimpleGetter.
				connections ifNil: [nil] ifNotNil: [connections reject: [:entry | entry isNil]]]]
		ifFalse: [[:object | aSymbol]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingConnections class >> defaultSetterBlockWith: aSymbol for: ignored [

	^ aSymbol isSymbol
		ifTrue: [
			[:object :vp | | connections |
				connections := (vp propertyAt: #connections) collect: [:connection | connection getObjectFromVisualPrimitive].
				(connections notNil and: [connections notEmpty]) ifTrue: [object perform: aSymbol asSimpleSetter with: connections]]]
		ifFalse: [[:object :vp | ]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingConnections class >> getter: aBlock setter: anotherBlock [

	| wrappedGetter wrappedSetter |
	wrappedGetter := [:object |
		(aBlock value: object)
			ifNil: [{}]
			ifNotNil: [:connections | connections reject: [:entry | entry isNil]]].
	wrappedSetter := [:object :vp |
		anotherBlock
			value: object
			value: ((vp propertyAt: #connections) collect: [:connection | connection getObjectFromVisualPrimitive])].
	^ super getter: wrappedGetter setter: wrappedSetter vpProperty: #connections name: 'connections'
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingConnections class >> getter: aBlock setter: anotherBlock patternValue: anObject vpProperty: aSymbol [

	anObject
		ifNotNil: [Error signal: 'SBVPPropertyMappingConnections does not support patternValue as this would lead to patterns recusively having children. This will result in an infinite number of children.']
		ifNil: [
			^ super
				getter: aBlock
				setter: anotherBlock
				patternValue: anObject
				vpProperty: aSymbol
				name: 'connections']
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingConnections class >> getter: aBlock setter: anotherBlock vpProperty: aSymbol [

	self assert: aSymbol = #connections.
	^ self getter: aBlock setter: anotherBlock
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingConnections class >> property: aSymbol [

	^ super property: aSymbol vpProperty: #connections
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingConnections class >> property: aSymbol vpProperty: anotherSymbol [

	self assert: anotherSymbol = #connections.
	^ self property: aSymbol
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingConnections >> initialize [

	super initialize.
	name := 'connections'
]