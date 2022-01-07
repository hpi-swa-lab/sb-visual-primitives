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
	#category : #'Sandblocks-VisualPrimitives'
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

{ #category : #'as yet unclassified' }
SBVPTomGrammarObject >> visualPrimitiveMapping [

	^ {
		#shape -> CircleMorph.
		#topLeftLabel -> #type.
		#innerLabel -> #objectName.
		#connections -> ((self members
			ifNotNil: [self members]
			ifNil: [self content ifNotNil: [{self content}] ifNil: [{}]]) reject: [:entry | entry isNil])}
]
