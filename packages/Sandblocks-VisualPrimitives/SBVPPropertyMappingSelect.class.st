"
An SBVPPropertyMappingSelect is used to map from a specific set of choices to corresponding representations for a vpProperty. To be able to change the selection the returned Morph is an SBVPSelectProperty.
"
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
SBVPPropertyMappingSelect class >> defaultSetterBlockWith: aSymbol for: anotherSymbol [

	^ aSymbol isSymbol
		ifTrue: [[:object :vp | 
				 (vp morphAt: anotherSymbol) ifNotNil: [:value |
				object perform: aSymbol asSimpleSetter with: value currentChoice]]]
		ifFalse: [[:object :vp | ]]
]

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
		title: self name
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
