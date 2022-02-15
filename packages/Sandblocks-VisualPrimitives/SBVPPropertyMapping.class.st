Class {
	#name : #SBVPPropertyMapping,
	#superclass : #Object,
	#instVars : [
		'getter',
		'setter',
		'patternValue',
		'vpProperty'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> constant: anObject vpProperty: aSymbol [

	^ SBVPPropertyMapping
		getter: [:ignore | anObject]
		setter: [:ignore :ignore2 | ]
		patternValue: anObject
		vpProperty: aSymbol
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> defaultGetterBlockWith: aSymbol [

	^ aSymbol isSymbol
		ifTrue: [[:object | object perform: aSymbol asSimpleGetter]]
		ifFalse: [[:object | aSymbol]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> defaultPatternValueFor: aSymbol [

	^ aSymbol isSymbol ifTrue: [nil] ifFalse: [aSymbol]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> defaultSetterBlockWith: aSymbol for: anotherSymbol [

	^ aSymbol isSymbol
		ifTrue: [[:object :vp | object perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol)]]
		ifFalse: [[:object :vp | ]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> fromAssociation: anAssociation [

	| getterBlock setterBlock patternValue |
	getterBlock := self defaultGetterBlockWith: anAssociation value.
	setterBlock := self defaultSetterBlockWith: anAssociation value for: anAssociation key.
	patternValue := self defaultPatternValueFor: anAssociation value.
	
	^ self getter: getterBlock setter: setterBlock patternValue: patternValue vpProperty: anAssociation key
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> getter: aBlock setter: anotherBlock patternValue: anObject vpProperty: aSymbol [

	^ self new
		getter: aBlock;
		setter: anotherBlock;
		vpProperty: aSymbol;
		patternValue: anObject;
		yourself
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> getter: aBlock setter: anotherBlock vpProperty: aSymbol [

	^ self getter: aBlock setter: anotherBlock patternValue: nil vpProperty: aSymbol
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> property: aSymbol vpProperty: anotherSymbol [

	^ self property: aSymbol vpProperty: anotherSymbol patternValue: nil
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> property: aSymbol vpProperty: anotherSymbol patternValue: anObject [

	| getterBlock setterBlock |
	getterBlock := self defaultGetterBlockWith: aSymbol.
	setterBlock := self defaultSetterBlockWith: aSymbol for: anotherSymbol.
	
	^ self getter: getterBlock setter: setterBlock patternValue: anObject vpProperty: anotherSymbol
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping >> asPropertyMapping [

	^ self
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping >> getMorphFor: anObject [

	^ self getMorphForValue: (self value: anObject)
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping >> getMorphForValue: anObject [

	^ anObject isMorph ifTrue: [anObject] ifFalse: [SBTextBubble new contents: anObject]
]

{ #category : #accessing }
SBVPPropertyMapping >> getter [

	^ getter
]

{ #category : #accessing }
SBVPPropertyMapping >> getter: anObject [

	getter := anObject
]

{ #category : #accessing }
SBVPPropertyMapping >> isPropertyMapping [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping >> key [

	^ self vpProperty
]

{ #category : #accessing }
SBVPPropertyMapping >> patternValue [

	^ patternValue
]

{ #category : #accessing }
SBVPPropertyMapping >> patternValue: anObject [

	patternValue := anObject
]

{ #category : #accessing }
SBVPPropertyMapping >> setter [

	^ setter
]

{ #category : #accessing }
SBVPPropertyMapping >> setter: anObject [

	setter := anObject
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping >> suggestionConstant [

	^ #a
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping >> value: anObject [

	^ self getter value: anObject
]

{ #category : #accessing }
SBVPPropertyMapping >> vpProperty [

	^ vpProperty
]

{ #category : #accessing }
SBVPPropertyMapping >> vpProperty: anObject [

	vpProperty := anObject
]

{ #category : #accessing }
SBVPPropertyMapping >> writeValue: value on: aStream [

	aStream nextPut: $[.
	value contents storeOn: aStream.
	aStream nextPut: $]
]
