Class {
	#name : #SBVPPropertyMappingSelect,
	#superclass : #SBVPPropertyMapping,
	#instVars : [
		'choices',
		'representations',
		'currentValue'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol primitiveProperty: anotherSymbol choices: aCollection on: anObject [

	^ self
		property: aSymbol
		primitiveProperty: anotherSymbol
		choices: aCollection
		representations: aCollection
		on: anObject
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol primitiveProperty: anotherSymbol choices: aCollection representations: anotherCollection on: anObject [

	| getterBlock setterBlock |
	getterBlock := self defaultGetterBlockWith: aSymbol on: anObject.
	setterBlock := self defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject.
	
	^ (self getter: getterBlock setter: setterBlock position: anotherSymbol)
		choices: aCollection;
		representations: anotherCollection
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> representationsOf: aCollection [

	^ aCollection
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> choices [

	^ choices
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> choices: aCollection [

	choices := aCollection
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> getMorph [

	^ SBVPSelectProperty
		choices: self choices
		representations: self representations
		initialValue: self getter value
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> representations [

	^ representations
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> representations: aCollection [

	representations := aCollection
]
