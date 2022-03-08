"
An SBPropertyMapping hold information on how the properties of an object are to be displayed in an SBDomainBlock and how changes on the primitive affect the origin object.

Instance Variables
	getter:			BlockClosure
	name:			String
	patternValue:	Object
	setter:			BlockClosure
	vpProperty:		Symbol

getter
	- should look like this: [:object | ... ]
	- the result from evaluating the getter should be a String, Number or Morph
	- the result is what will be displayed in the SBDomainBlock

name
	- this is the name of the property as a String

patternValue
	- this value will be displayed if there is no origin object, because the primitive is a pattern

setter
	- should look like this: [:object :vp | ... ]

vpProperty
	- specifies where the mapping will be applied in the visual primitive
	- can be #shape #children or a labelPosition, e.g. #innerLabel or #topLeftLabel (see SBDomainBlock >> labelPositions) 

"
Class {
	#name : #SBPropertyMapping,
	#superclass : #Object,
	#instVars : [
		'getter',
		'isConstant',
		'name',
		'patternValue',
		'setter',
		'vpProperty'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> constant: anObject vpProperty: aSymbol [

	^ (self
		getter: [:ignore | anObject]
		setter: [:ignore :ignore2 | ]
		patternValue: anObject
		vpProperty: aSymbol
		name: aSymbol asString) isConstant: true
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> defaultGetterBlockWith: anObject [

	^ anObject isSymbol
		ifTrue: [[:object | object perform: anObject asSimpleGetter]]
		ifFalse: [[:object | anObject]]
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> defaultPatternValueFor: aSymbol [

	^ aSymbol isSymbol ifTrue: [nil] ifFalse: [aSymbol]
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> defaultSetterBlockWith: aSymbol for: anotherSymbol [

	^ aSymbol isSymbol
		ifTrue: [[:object :vp | object perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol)]]
		ifFalse: [[:object :vp | ]]
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> fromAssociation: anAssociation [

	| getterBlock setterBlock patternValue name |
	getterBlock := self defaultGetterBlockWith: anAssociation value.
	setterBlock := self defaultSetterBlockWith: anAssociation value for: anAssociation key.
	patternValue := self defaultPatternValueFor: anAssociation value.
	name := self mappingName: anAssociation value withDefault: anAssociation key asString.
	
	^ (self
		getter: getterBlock
		setter: setterBlock
		patternValue: patternValue
		vpProperty: anAssociation key
		name: name) isConstant: anAssociation value isSymbol not
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> getter: aBlock setter: anotherBlock patternValue: anObject vpProperty: aSymbol name: aString [

	^ self new
		getter: aBlock;
		setter: anotherBlock;
		vpProperty: aSymbol;
		patternValue: anObject;
		name: aString;
		yourself
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> getter: aBlock setter: anotherBlock vpProperty: aSymbol name: aString [

	^ self getter: aBlock setter: anotherBlock patternValue: nil vpProperty: aSymbol name: aString
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> mappingName: anObject withDefault: aString [

	^ anObject isSymbol ifTrue: [anObject asString] ifFalse: [aString]
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> property: aSymbol vpProperty: anotherSymbol [

	^ self property: aSymbol vpProperty: anotherSymbol patternValue: nil
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> property: aSymbol vpProperty: anotherSymbol patternValue: anObject [

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
SBPropertyMapping >> asPropertyMapping [

	^ self
]

{ #category : #accessing }
SBPropertyMapping >> getLabelContents: anObject [

	^ (anObject isString or: [anObject isNumber])
		ifTrue: [anObject]
		ifFalse: [[anObject firstSubmorph contents] on: Error do: [nil]]
]

{ #category : #'as yet unclassified' }
SBPropertyMapping >> getMorphFor: anObject [

	^ self getMorphForValue: (self value: anObject)
]

{ #category : #'as yet unclassified' }
SBPropertyMapping >> getMorphForValue: anObject [

	^ anObject isMorph ifTrue: [anObject] ifFalse: [SBTextBubble new contents: anObject]
]

{ #category : #accessing }
SBPropertyMapping >> getter [

	^ getter
]

{ #category : #accessing }
SBPropertyMapping >> getter: aBlockClosure [

	getter := aBlockClosure
]

{ #category : #'as yet unclassified' }
SBPropertyMapping >> initialize [

	super initialize.
	self isConstant: false
]

{ #category : #accessing }
SBPropertyMapping >> isConstant [

	^ isConstant
]

{ #category : #accessing }
SBPropertyMapping >> isConstant: anObject [

	isConstant := anObject
]

{ #category : #accessing }
SBPropertyMapping >> isPropertyMapping [

	^ true
]

{ #category : #'as yet unclassified' }
SBPropertyMapping >> key [

	^ self vpProperty
]

{ #category : #accessing }
SBPropertyMapping >> name [

	^ name
]

{ #category : #accessing }
SBPropertyMapping >> name: aString [

	name := aString
]

{ #category : #accessing }
SBPropertyMapping >> patternValue [

	^ patternValue
]

{ #category : #accessing }
SBPropertyMapping >> patternValue: anObject [

	patternValue := anObject
]

{ #category : #accessing }
SBPropertyMapping >> setter [

	^ setter
]

{ #category : #accessing }
SBPropertyMapping >> setter: aBlockClosure [

	setter := aBlockClosure
]

{ #category : #'as yet unclassified' }
SBPropertyMapping >> suggestionConstant [

	^ #a
]

{ #category : #'as yet unclassified' }
SBPropertyMapping >> value: anObject [

	^ self getter value: anObject
]

{ #category : #accessing }
SBPropertyMapping >> vpProperty [

	^ vpProperty
]

{ #category : #accessing }
SBPropertyMapping >> vpProperty: aSymbol [

	vpProperty := aSymbol
]

{ #category : #accessing }
SBPropertyMapping >> writeExpression: aSandblock on: aStream [

	aStream nextPut: $[.
	aSandblock writeSourceOn: aStream.
	aStream nextPut: $]
]
