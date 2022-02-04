Class {
	#name : #SBVPTomGrammarObject,
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
SBVPTomGrammarObject class >> fromJsonObject: aJsonObject [

	SBVPTomGrammarObject new
		type: (aJsonObject at: 'type');
		members: ((aJsonObject at: 'members') do: [:member | SBVPTomGrammarObject fromJsonObject: member]);
		content: (SBVPTomGrammarObject fromJsonObject: (aJsonObject at: 'content'));
		objectName: (aJsonObject at: 'name');
		objectValue: (aJsonObject at: 'value')
]

{ #category : #'as yet unclassified' }
SBVPTomGrammarObject class >> visualPrimitiveMapping [

	^ {
		#shape -> CircleMorph new.
		SBVPPropertyMapping constant: #bottomCenterLabel vpProperty: #identityLabelPosition.
		SBVPPropertyMappingSelect
			property: #type
			vpProperty: #topLeftLabel
			choices: {'SEQ'. 'REPEAT'. 'REPEAT1'. 'SYMBOL'}.
		SBVPPropertyMappingString property: #objectName vpProperty: #innerLabel.
		SBVPPropertyMapping
			getter: [:object | (object members ifNil: [object content ifNotNil: [{object content}] ifNil: [{}]]) reject: [:entry | entry isNil]]
			setter: [:object :vp | object members: (vp connections collect: [:connection | connection getObjectFromVisualPrimitive])]
			vpProperty: #connections}
]

{ #category : #accessing }
SBVPTomGrammarObject >> content [

	^ content
]

{ #category : #accessing }
SBVPTomGrammarObject >> content: anObject [

	content := anObject
]

{ #category : #'as yet unclassified' }
SBVPTomGrammarObject >> initialize [

	members := nil.
	content := nil.
	objectName := ''.
	objectValue := ''.
	type := ''
]

{ #category : #accessing }
SBVPTomGrammarObject >> members [

	^ members
]

{ #category : #accessing }
SBVPTomGrammarObject >> members: anArray [

	members := anArray
]

{ #category : #accessing }
SBVPTomGrammarObject >> objectName [

	^ objectName
]

{ #category : #accessing }
SBVPTomGrammarObject >> objectName: aString [

	objectName := aString
]

{ #category : #accessing }
SBVPTomGrammarObject >> objectValue [

	^ objectValue
]

{ #category : #accessing }
SBVPTomGrammarObject >> objectValue: aString [

	objectValue := aString
]

{ #category : #accessing }
SBVPTomGrammarObject >> type [

	^ type
]

{ #category : #accessing }
SBVPTomGrammarObject >> type: aString [

	type := aString
]

{ #category : #accessing }
SBVPTomGrammarObject >> writeSourceOn: aStream [

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
