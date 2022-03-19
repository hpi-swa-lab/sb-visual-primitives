Class {
	#name : #SBGameCardHand,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBGameCardHand class >> domainBlockMapping [

	^ {#shape dbConstant: SBIcon iconHandOUp. #children dbChildFor: #cards}
]

{ #category : #accessing }
SBGameCardHand >> cards [

	^ cards
]

{ #category : #accessing }
SBGameCardHand >> cards: anOrderedCollection [

	cards := anOrderedCollection
]

{ #category : #accessing }
SBGameCardHand >> writeSourceOn: aStream [

	aStream
		nextPutAll: '(';
		nextPutAll: self className;
		nextPutAll: ' new cards: {'.
	
	self cards do: [:card |
		card writeSourceOn: aStream.
		aStream nextPut: $.].
	
	aStream nextPutAll: '})'
]
