"
An SBVPPropertyMapping hold information on how the properties of an object are to be displayed in a SBVisualPrimitive and how changes on the primitive affect the origin object.

Instance Variables
	getter:			BlockClosure
	patternValue:	Object
	setter:			BlockClosure
	vpProperty:		Symbol

getter
	- should look like this: [:object | ... ]
	- the result from evaluating the getter should be a String, Number or Morph
	- the result is what will be displayed in the SBVisualPrimitive

patternValue
	- this value will be displayed if there is no origin object, because the primitive is a pattern

setter
	- should look like this: [:object :vp | ... ]

vpProperty
	- specifies where the mapping will be applied in the visual primitive
	- can be #shape #connections or a labelPosition, e.g. #innerLabel or #topLeftLabel (see SBVisualPrimitive >> labelPositions) 

"
Class {
	#name : #SBVPPropertyMapping,
	#superclass : #Object,
	#instVars : [
		'getter',
		'setter',
		'patternValue',
		'vpProperty',
		'name'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> constant: anObject vpProperty: aSymbol [

	^ self
		getter: [:ignore | anObject]
		setter: [:ignore :ignore2 | ]
		patternValue: anObject
		vpProperty: aSymbol
		name: aSymbol asString
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> defaultGetterBlockWith: anObject [

	^ anObject isSymbol
		ifTrue: [[:object | object perform: anObject asSimpleGetter]]
		ifFalse: [[:object | anObject]]
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

	| getterBlock setterBlock patternValue name |
	getterBlock := self defaultGetterBlockWith: anAssociation value.
	setterBlock := self defaultSetterBlockWith: anAssociation value for: anAssociation key.
	patternValue := self defaultPatternValueFor: anAssociation value.
	name := self mappingName: anAssociation value withDefault: anAssociation key asString.
	
	^ self
		getter: getterBlock
		setter: setterBlock
		patternValue: patternValue
		vpProperty: anAssociation key
		name: name
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> getter: aBlock setter: anotherBlock patternValue: anObject vpProperty: aSymbol name: aString [

	^ self new
		getter: aBlock;
		setter: anotherBlock;
		vpProperty: aSymbol;
		patternValue: anObject;
		name: aString;
		yourself
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> getter: aBlock setter: anotherBlock vpProperty: aSymbol name: aString [

	^ self getter: aBlock setter: anotherBlock patternValue: nil vpProperty: aSymbol name: aString
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> mappingName: anObject withDefault: aString [

	^ anObject isSymbol ifTrue: [anObject asString] ifFalse: [aString]
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
	
	^ self
		getter: getterBlock
		setter: setterBlock
		patternValue: anObject
		vpProperty: anotherSymbol
		name: aSymbol asString
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
SBVPPropertyMapping >> name [

	^ name
]

{ #category : #accessing }
SBVPPropertyMapping >> name: anObject [

	name := anObject
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
