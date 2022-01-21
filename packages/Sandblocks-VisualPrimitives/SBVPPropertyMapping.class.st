Class {
	#name : #SBVPPropertyMapping,
	#superclass : #Object,
	#instVars : [
		'getter',
		'setter',
		'position',
		'color',
		'shape'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> defaultGetterBlockWith: aSymbol on: anObject [

	^ aSymbol isSymbol
		ifTrue: [[anObject perform: aSymbol asSimpleGetter]]
		ifFalse: [[aSymbol]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject [

	^ aSymbol isSymbol
		ifTrue: [[:vp | anObject perform: aSymbol asSimpleSetter with: (vp propertyAt: anotherSymbol)]]
		ifFalse: [
			[:vp | "do nothing, because value should be constant"
			]]
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> fromAssociation: anAssociation for: anObject [

	| getterBlock setterBlock |
	getterBlock := self defaultGetterBlockWith: anAssociation value on: anObject.
	setterBlock := self defaultSetterBlockWith: anAssociation value for: anAssociation key on: anObject.
	
	^ self getter: getterBlock setter: setterBlock position: anAssociation key optionalArgs: Dictionary new
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> getter: aBlock setter: anotherBlock position: aSymbol optionalArgs: aDict [

	^ self new
		getter: aBlock;
		setter: anotherBlock;
		position: aSymbol;
		color: (aDict at: #color ifPresent: [:color | color] ifAbsent: []);
		yourself
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping class >> property: aSymbol primitiveProperty: anotherSymbol on: anObject [

	| getterBlock setterBlock |
	getterBlock := self defaultGetterBlockWith: aSymbol on: anObject.
	setterBlock := self defaultSetterBlockWith: aSymbol for: anotherSymbol on: anObject.
	
	^ self getter: getterBlock setter: setterBlock position: anotherSymbol optionalArgs: Dictionary new
]

{ #category : #accessing }
SBVPPropertyMapping >> color [

	^ color
]

{ #category : #accessing }
SBVPPropertyMapping >> color: anObject [

	color := anObject
]

{ #category : #'as yet unclassified' }
SBVPPropertyMapping >> getMorph [

	^ self getter value
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
SBVPPropertyMapping >> initialize [

	super initialize
]

{ #category : #accessing }
SBVPPropertyMapping >> isPropertyMapping [

	^ true
]

{ #category : #accessing }
SBVPPropertyMapping >> position [

	^ position
]

{ #category : #accessing }
SBVPPropertyMapping >> position: anObject [

	position := anObject
]

{ #category : #accessing }
SBVPPropertyMapping >> setter [

	^ setter
]

{ #category : #accessing }
SBVPPropertyMapping >> setter: anObject [

	setter := anObject
]

{ #category : #accessing }
SBVPPropertyMapping >> shape [

	^ shape
]

{ #category : #accessing }
SBVPPropertyMapping >> shape: anObject [

	shape := anObject
]
