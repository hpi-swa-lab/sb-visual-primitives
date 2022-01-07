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
SBVPPropertyMapping class >> fromAssociation: anAssociation for: anObject [

	| getterBlock setterBlock |
	getterBlock := anAssociation value isSymbol
		ifTrue: [[anObject perform: anAssociation value]]
		ifFalse: [[anAssociation value]].
	setterBlock := anAssociation value isSymbol
		ifTrue: [[:vp | anObject perform: anAssociation value asSimpleSetter with: (vp perform: anAssociation key asSimpleGetter )]]
		ifFalse: [["Maybe handle constant values here and simply return them.?"]].
	
	^ SBVPPropertyMapping
		getter: getterBlock
		setter: setterBlock
		position: anAssociation key
		optionalArgs: Dictionary new
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

{ #category : #accessing }
SBVPPropertyMapping >> color [

	^ color
]

{ #category : #accessing }
SBVPPropertyMapping >> color: anObject [

	color := anObject
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
