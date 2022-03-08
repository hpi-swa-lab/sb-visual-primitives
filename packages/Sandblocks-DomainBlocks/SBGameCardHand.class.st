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

	^ {#shape vpConstant: SBIcon iconHandOUp. #children vpChildFor: #cards}
]

{ #category : #accessing }
SBGameCardHand >> cards [

	^ cards
]

{ #category : #accessing }
SBGameCardHand >> cards: anObject [

	cards := anObject
]
