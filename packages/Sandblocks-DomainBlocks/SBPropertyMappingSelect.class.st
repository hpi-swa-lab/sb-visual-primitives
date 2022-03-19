"
An SBPropertyMappingSelect is used to map from a specific set of choices to corresponding representations for a dbProperty. To be able to change the selection the returned Morph is an SBSelectProperty.

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
		ifTrue: [
			[:object :db |
				(db morphAt: anotherSymbol) ifNotNil: [ | dbValue |
					dbValue := db morphAt: anotherSymbol.
					(dbValue isKindOf: SBSelectProperty) ifTrue: [object perform: aSymbol asSimpleSetter with: dbValue currentChoice]]]]
		ifFalse: [[:object :db | ]]
]

{ #category : #'as yet unclassified' }
SBPropertyMappingSelect class >> property: aSymbol dbProperty: anotherSymbol choices: anOrderedCollection [

	^ self
		property: aSymbol
		dbProperty: anotherSymbol
		choices: anOrderedCollection
		representations: anOrderedCollection
]

{ #category : #'as yet unclassified' }
SBPropertyMappingSelect class >> property: aSymbol dbProperty: anotherSymbol choices: anOrderedCollection representations: anotherOrderedCollection [

	^ (self property: aSymbol dbProperty: anotherSymbol)
		choices: anOrderedCollection;
		representations: anotherOrderedCollection;
		yourself
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
