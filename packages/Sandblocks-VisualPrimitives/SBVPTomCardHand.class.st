Class {
	#name : #SBVPTomCardHand,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPTomCardHand class >> visualPrimitiveMapping [

	^ {
	#shape vpConstant: SBIcon iconHandOUp.
	#connections vpConnectionFor: #cards}
]

{ #category : #accessing }
SBVPTomCardHand >> cards [

	^ cards
]

{ #category : #accessing }
SBVPTomCardHand >> cards: anObject [

	cards := anObject
]
