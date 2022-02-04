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
SBVPPropertyMappingSelect class >> defaultGetterBlockWith: aSymbol [

	^ [:object | self representations at: (self choices indexOf: (object perform: aSymbol asSimpleGetter))]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol vpProperty: anotherSymbol choices: aCollection [

	^ self new
		property: aSymbol vpProperty: anotherSymbol choices: aCollection representations: aCollection;
		yourself
]

{ #category : #'as yet unclassified' }
SBVPPropertyMappingSelect class >> property: aSymbol vpProperty: anotherSymbol choices: aCollection representations: anotherCollection [

	^ self new
		property: aSymbol
			vpProperty: anotherSymbol
			choices: aCollection
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
SBVPPropertyMappingSelect >> defaultGetterBlockWith: aSymbol [

	^ [:object |
		self representations
			at: (self choices indexOf: (object perform: aSymbol asSimpleGetter))
			ifAbsent: [self representations first]]
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> defaultSetterBlockWith: aSymbol for: anotherSymbol [

	^ [:object :vp | object perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol)]
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> getMorphFor: anObject [

	^ SBVPSelectProperty
		choices: self choices
		representations: self representations
		initialValue: (self value: anObject)
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> property: aSymbol vpProperty: anotherSymbol choices: aCollection [

	^ self property: aSymbol vpProperty: anotherSymbol choices: aCollection representations: aCollection
]

{ #category : #accessing }
SBVPPropertyMappingSelect >> property: aSymbol vpProperty: anotherSymbol choices: aCollection representations: anotherCollection [

	| getterBlock setterBlock |
	getterBlock := self defaultGetterBlockWith: aSymbol.
	setterBlock := self defaultSetterBlockWith: aSymbol for: anotherSymbol.
	
	^ self
		getter: getterBlock;
		setter: setterBlock;
		vpProperty: anotherSymbol;
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
