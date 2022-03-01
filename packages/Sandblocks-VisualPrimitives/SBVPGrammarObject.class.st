Class {
	#name : #SBVPGrammarObject,
	#superclass : #Object,
	#instVars : [
		'type',
		'members',
		'content',
		'objectName',
		'objectValue'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPGrammarObject class >> fromJsonObject: aJsonObject [

	SBVPGrammarObject new
		type: (aJsonObject at: 'type');
		members: ((aJsonObject at: 'members') do: [:member | SBVPGrammarObject fromJsonObject: member]);
		content: (SBVPGrammarObject fromJsonObject: (aJsonObject at: 'content'));
		objectName: (aJsonObject at: 'name');
		objectValue: (aJsonObject at: 'value')
]

{ #category : #'as yet unclassified' }
SBVPGrammarObject class >> visualPrimitiveMapping [

	^ {
		#shape vpConstant: (CircleMorph new color: Color white).
		#identityLabelPosition vpConstant: #bottomCenterLabel.
		#topLeftLabel vpSelectFrom: {'SEQ'. 'REPEAT'. 'REPEAT1'. 'SYMBOL'} for: #type.
		#innerLabel vpStringFor: #objectName.
		
		SBVPPropertyMappingChildren
			getter: [:object | object members ifNil: [{object content} asOrderedCollection]]
			setter: [:object :children |
				children size < 1 ifTrue: [] ifFalse: [
					children size > 1
						ifTrue: [object members: children]
						ifFalse: [object content: children first]]]
			vpProperty: #children}
]

{ #category : #accessing }
SBVPGrammarObject >> content [

	^ content
]

{ #category : #accessing }
SBVPGrammarObject >> content: anObject [

	content := anObject
]

{ #category : #'as yet unclassified' }
SBVPGrammarObject >> initialize [

	members := nil.
	content := nil.
	objectName := ''.
	objectValue := ''.
	type := ''
]

{ #category : #accessing }
SBVPGrammarObject >> members [

	^ members
]

{ #category : #accessing }
SBVPGrammarObject >> members: anArray [

	members := anArray
]

{ #category : #accessing }
SBVPGrammarObject >> objectName [

	^ objectName
]

{ #category : #accessing }
SBVPGrammarObject >> objectName: aString [

	objectName := aString
]

{ #category : #accessing }
SBVPGrammarObject >> objectValue [

	^ objectValue
]

{ #category : #accessing }
SBVPGrammarObject >> objectValue: aString [

	objectValue := aString
]

{ #category : #accessing }
SBVPGrammarObject >> type [

	^ type
]

{ #category : #accessing }
SBVPGrammarObject >> type: aString [

	type := aString
]

{ #category : #accessing }
SBVPGrammarObject >> writeSourceOn: aStream [

	aStream
		nextPutAll: self className;
		nextPutAll: ' new objectName:';
		store: self objectName;
		nextPutAll: '; type: ';
		store: self type.
	self members ifNotNil: [
		aStream nextPutAll: '; members: {'.
		self members
			do: [:member | member writeSourceOn: aStream]
			separatedBy: [aStream nextPut: $.].
		aStream nextPut: $}].
	self content ifNotNil: [
		aStream nextPutAll: '; content: ('.
		self content writeSourceOn: aStream.
		aStream nextPut: $)]
]
