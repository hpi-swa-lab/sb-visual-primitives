Class {
	#name : #SBVPGameCardHand,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPGameCardHand class >> playCardFrom: aHand toBeat: aCard [

	SBVPCase
		input: (SBVPGroupPattern patterns: {})
		output: (SBVPGroupPattern patterns: {})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPGameCardHand
]

{ #category : #'as yet unclassified' }
SBVPGameCardHand class >> visualPrimitiveMapping [

	^ {#shape vpConstant: SBIcon iconHandOUp. #connections vpConnectionFor: #cards}
]

{ #category : #accessing }
SBVPGameCardHand >> cards [

	^ cards
]

{ #category : #accessing }
SBVPGameCardHand >> cards: anObject [

	cards := anObject
]
