"
An SBPropertyMapping hold information on how the properties of an object are to be displayed in an SBDomainBlock and how changes on the primitive affect the origin object.

Instance Variables
	getter:			BlockClosure
	isConstant:		Boolean
	name:			String
	patternValue:	Object
	setter:			BlockClosure
	dbProperty:		Symbol

getter
	- should look like this: [:object | ... ]
	- the result from evaluating the getter should be a String, Number or Morph
	- the result is what will be displayed in the SBDomainBlock

isConstant
	- indicates whether the property is a constant

name
	- this is the name of the property as a String

patternValue
	- this value will be displayed if there is no origin object, because the primitive is a pattern

setter
	- should look like this: [:object :db | ... ]

dbProperty
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
		'dbProperty'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> constant: anObject dbProperty: aSymbol [

	^ (self
		getter: [:ignore | anObject]
		setter: [:ignore :ignore2 | ]
		patternValue: anObject
		dbProperty: aSymbol
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
		ifTrue: [[:object :db | object perform: aSymbol asSimpleSetter with: (db propertyAt: anotherSymbol)]]
		ifFalse: [[:object :db | ]]
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
		dbProperty: anAssociation key
		name: name) isConstant: anAssociation value isSymbol not
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> getter: aBlock setter: anotherBlock dbProperty: aSymbol name: aString [

	^ self getter: aBlock setter: anotherBlock patternValue: nil dbProperty: aSymbol name: aString
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> getter: aBlock setter: anotherBlock patternValue: anObject dbProperty: aSymbol name: aString [

	^ self new
		getter: aBlock;
		setter: anotherBlock;
		dbProperty: aSymbol;
		patternValue: anObject;
		name: aString;
		yourself
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> mappingName: anObject withDefault: aString [

	^ anObject isSymbol ifTrue: [anObject asString] ifFalse: [aString]
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> property: aSymbol dbProperty: anotherSymbol [

	^ self property: aSymbol dbProperty: anotherSymbol patternValue: nil
]

{ #category : #'as yet unclassified' }
SBPropertyMapping class >> property: aSymbol dbProperty: anotherSymbol patternValue: anObject [

	| getterBlock setterBlock |
	getterBlock := self defaultGetterBlockWith: aSymbol.
	setterBlock := self defaultSetterBlockWith: aSymbol for: anotherSymbol.
	
	^ self
		getter: getterBlock
		setter: setterBlock
		patternValue: anObject
		dbProperty: anotherSymbol
		name: aSymbol asString
]

{ #category : #'as yet unclassified' }
SBPropertyMapping >> asPropertyMapping [

	^ self
]

{ #category : #accessing }
SBPropertyMapping >> dbProperty [

	^ dbProperty
]

{ #category : #accessing }
SBPropertyMapping >> dbProperty: aSymbol [

	dbProperty := aSymbol
]

{ #category : #accessing }
SBPropertyMapping >> getLabelContents: anObject [

	^ [anObject firstSubmorph contents] on: Error do: [nil]
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

{ #category : #initialization }
SBPropertyMapping >> initialize [

	super initialize.
	self isConstant: false
]

{ #category : #accessing }
SBPropertyMapping >> isConstant [

	^ isConstant
]

{ #category : #accessing }
SBPropertyMapping >> isConstant: aBoolean [

	isConstant := aBoolean
]

{ #category : #accessing }
SBPropertyMapping >> isPropertyMapping [

	^ true
]

{ #category : #accessing }
SBPropertyMapping >> key [

	^ self dbProperty
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

{ #category : #accessing }
SBPropertyMapping >> value: anObject [

	^ self getter value: anObject
]

{ #category : #accessing }
SBPropertyMapping >> writeExpression: aSandblock on: aStream [

	aStream nextPut: $[.
	aSandblock writeSourceOn: aStream.
	aStream nextPut: $]
]
