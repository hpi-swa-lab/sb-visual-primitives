Class {
	#name : #SBVPPropertyMappingSelect,
	#superclass : #SBVPPropertyMapping,
	#instVars : [
		'choices',
		'representations'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol vpProperty: anotherSymbol choices: aCollection [

	^ self property: aSymbol vpProperty: anotherSymbol choices: aCollection representations: aCollection
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol vpProperty: anotherSymbol choices: aCollection representations: anotherCollection [

	^ (self property: aSymbol vpProperty: anotherSymbol)
		choices: aCollection;
		representations: anotherCollection;
		yourself
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
SBVPPropertyMappingSelect >> getMorphForValue: anObject [

	^ SBVPSelectProperty
		choices: self choices
		representations: self representations
		initialValue: anObject
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> representations [

	^ representations
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> representations: aCollection [

	representations := aCollection
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect >> suggestionConstant [

	^ self choices first
]
