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
SBVPTomGrammarObject class >> staticVisualPrimitiveMapping [

	^ {#shape -> CircleMorph new}
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
SBVPTomGrammarObject >> dynamicVisualPrimitiveMapping [

	^ {
		SBVPPropertyMappingSelect
			property: #type
			primitiveProperty: #topLeftLabel
			choices: {'SEQ'. 'REPEAT'. 'REPEAT1'. 'SYMBOL'}
			on: self.
		SBVPPropertyMappingString
			property: #objectName
			primitiveProperty: #innerLabel
			on: self.
		SBVPPropertyMapping
			getter: [(self members ifNil: [self content ifNotNil: [{self content}] ifNil: [{}]]) reject: [:entry | entry isNil]]
			setter: [:vp | self members: (vp connections collect: [:connection | connection getObjectFromVisualPrimitive])]
			position: #connections}
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
