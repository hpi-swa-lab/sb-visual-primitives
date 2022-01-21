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
SBVPPropertyMappingSelect class >> defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject [

	^ aSymbol isSymbol
		ifTrue: [
			[:vp | | currentRepresentation |
				currentRepresentation := vp propertyAt: anotherSymbol.
				
				anObject perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol)]]
		ifFalse: [
			[:vp | "do nothing, because value should be constant"
			]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> defaultSetterBlockWith: aSymbol on: anObject [

	self flag: #TODO
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol primitiveProperty: anotherSymbol choices: aCollection on: anObject [

	| getterBlock setterBlock representations |
	self flag: #TODO.
	"generate representations"
	representations := self representationsOf: aCollection.
	
	self flag: #TODO.
	"use representations and choices correctly here"
	getterBlock := self defaultGetterBlockWith: aSymbol on: anObject.
	setterBlock := self defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject.
	
	self flag: #TODO.
	"save representations and choices"
	^ (self getter: getterBlock setter: setterBlock position: anotherSymbol optionalArgs: Dictionary new)
		choices: aCollection;
		representations: representations
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
SBVPPropertyMappingSelect >> representations [

	^ representations
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> representations: aCollection [

	representations := aCollection
]
