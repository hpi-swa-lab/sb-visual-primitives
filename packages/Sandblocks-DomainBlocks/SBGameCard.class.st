Class {
	#name : #SBGameCard,
	#superclass : #Object,
	#instVars : [
		'attack',
		'defense',
		'type'
	],
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #accessing }
SBGameCard >> attack [

	^ attack
]

{ #category : #accessing }
SBGameCard >> attack: anObject [

	attack := anObject
]

{ #category : #accessing }
SBGameCard >> defense [

	^ defense
]

{ #category : #accessing }
SBGameCard >> defense: anObject [

	defense := anObject
]

{ #category : #accessing }
SBGameCard >> initialize [

	super initialize.
	self
		attack: 5;
		defense: 5;
		type: 'fire'
]

{ #category : #accessing }
SBGameCard >> type [

	^ type
]

{ #category : #accessing }
SBGameCard >> type: anObject [

	type := anObject
]

{ #category : #accessing }
SBGameCard >> writeSourceOn: aStream [

	aStream
		nextPutAll: '(';
		nextPutAll: self className;
		nextPutAll: ' new'.
	
	self attack ifNotNil: [
		aStream
			nextPutAll: ' attack: ';
			store: self attack].
	
	self defense ifNotNil: [
		aStream
			nextPutAll: '; defense: ';
			store: self defense].
	
	self type ifNotNil: [
		aStream
			nextPutAll: '; type: ';
			store: self type].
	
	aStream nextPut: $)
]
