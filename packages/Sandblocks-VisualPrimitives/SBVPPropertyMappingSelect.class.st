"
An SBPropertyMappingSelect is used to map from a specific set of choices to corresponding representations for a vpProperty. To be able to change the selection the returned Morph is an SBSelectProperty.

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
	#name : #SBPropertyMappingSelect,
	#superclass : #SBPropertyMapping,
	#instVars : [
		'choices',
		'representations'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPropertyMappingSelect class >> defaultSetterBlockWith: aSymbol for: anotherSymbol [

	^ aSymbol isSymbol
		ifTrue: [[:object :vp | (vp morphAt: anotherSymbol) ifNotNil: [object perform: aSymbol asSimpleSetter with: (vp morphAt: anotherSymbol) currentChoice]]]
		ifFalse: [[:object :vp | ]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingSelect class >> property: aSymbol vpProperty: anotherSymbol choices: anOrderedCollection [

	^ self
		property: aSymbol
		vpProperty: anotherSymbol
		choices: anOrderedCollection
		representations: anOrderedCollection
]

{ #category : #'as yet unclassified' }
SBPropertyMappingSelect class >> property: aSymbol vpProperty: anotherSymbol choices: anOrderedCollection representations: anotherOrderedCollection [

	^ (self property: aSymbol vpProperty: anotherSymbol)
		choices: anOrderedCollection;
		representations: anotherOrderedCollection;
		yourself
]

{ #category : #'as yet unclassified' }
SBPropertyMappingSelect class >> representationsOf: aCollection [

	^ aCollection
]

{ #category : #accessing }
SBPropertyMappingSelect >> choices [

	^ choices
]

{ #category : #accessing }
SBPropertyMappingSelect >> choices: anOrderedCollection [

	choices := anOrderedCollection
]

{ #category : #accessing }
SBPropertyMappingSelect >> getMorphForValue: anObject [

	^ SBSelectProperty
		choices: self choices
		representations: self representations
		initialValue: anObject
		title: self name
]

{ #category : #accessing }
SBPropertyMappingSelect >> representations [

	^ representations
]

{ #category : #accessing }
SBPropertyMappingSelect >> representations: anOrderedCollection [

	representations := anOrderedCollection
]

{ #category : #'as yet unclassified' }
SBPropertyMappingSelect >> suggestionConstant [

	^ self choices first
]
