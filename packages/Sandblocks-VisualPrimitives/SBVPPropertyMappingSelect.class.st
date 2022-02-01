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
SBVPPropertyMappingSelect class >> defaultGetterBlockWith: aSymbol on: anObject [

	^ [self representations at: (self choices indexOf: (anObject perform: aSymbol asSimpleGetter))]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol primitiveProperty: anotherSymbol choices: aCollection on: anObject [

	^ self new
		property: aSymbol
			primitiveProperty: anotherSymbol
			choices: aCollection
			representations: aCollection
			on: anObject;
		yourself
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol primitiveProperty: anotherSymbol choices: aCollection representations: anotherCollection on: anObject [

	^ self new
		property: aSymbol
			primitiveProperty: anotherSymbol
			choices: aCollection
			representations: anotherCollection
			on: anObject;
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
SBVPPropertyMappingSelect >> defaultGetterBlockWith: aSymbol on: anObject [

	^ [self representations at: (self choices indexOf: (anObject perform: aSymbol asSimpleGetter))]
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject [

	^ [:vp | anObject perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol)]
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> getMorph [

	^ SBVPSelectProperty
		choices: self choices
		representations: self representations
		initialValue: self getter value
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> property: aSymbol primitiveProperty: anotherSymbol choices: aCollection on: anObject [

	^ self
		property: aSymbol
		primitiveProperty: anotherSymbol
		choices: aCollection
		representations: aCollection
		on: anObject
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> property: aSymbol primitiveProperty: anotherSymbol choices: aCollection representations: anotherCollection on: anObject [

	| getterBlock setterBlock |
	getterBlock := self defaultGetterBlockWith: aSymbol on: anObject.
	setterBlock := self defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject.
	
	^ self
		getter: getterBlock;
		setter: setterBlock;
		position: anotherSymbol;
		choices: aCollection;
		representations: anotherCollection
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> representations [

	^ representations
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> representations: aCollection [

	representations := aCollection
]
