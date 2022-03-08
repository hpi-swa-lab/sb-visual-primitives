Class {
	#name : #SBGameCardHand,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBGameCardHand class >> playCardFrom: aHand toBeat: aCard [

	SBTransformation
		input: (SBGroupPattern patterns: {})
		output: (SBGroupPattern patterns: {})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBGameCardHand
]

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
