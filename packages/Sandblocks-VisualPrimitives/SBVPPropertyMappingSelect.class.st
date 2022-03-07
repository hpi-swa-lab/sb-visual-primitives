"
An SBVPPropertyMappingSelect is used to map from a specific set of choices to corresponding representations for a vpProperty. To be able to change the selection the returned Morph is an SBVPSelectProperty.

Instance Variables
	choices: 				OrderedCollection
	representations:	OrderedCollection

choices
	- contains the selectable options of the select

representations
	- contains the visualizations of the choices
	- if there are no visualizations, choices are shown as Strings
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
		ifTrue: [[:object :vp | (vp morphAt: anotherSymbol) ifNotNil: [object perform: aSymbol asSimpleSetter with: (vp morphAt: anotherSymbol) currentChoice]]]
		ifFalse: [[:object :vp | ]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol vpProperty: anotherSymbol choices: anOrderedCollection [

	^ self
		property: aSymbol
		vpProperty: anotherSymbol
		choices: anOrderedCollection
		representations: anOrderedCollection
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol vpProperty: anotherSymbol choices: anOrderedCollection representations: anotherOrderedCollection [

	^ (self property: aSymbol vpProperty: anotherSymbol)
		choices: anOrderedCollection;
		representations: anotherOrderedCollection;
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
SBVPPropertyMappingSelect >> choices: anOrderedCollection [

	choices := anOrderedCollection
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
SBVPPropertyMappingSelect >> representations: anOrderedCollection [

	representations := anOrderedCollection
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect >> suggestionConstant [

	^ self choices first
]
