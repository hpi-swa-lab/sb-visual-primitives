Class {
	#name : #SBVPCircleAllLabelFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPCircleAllLabelFixture >> visualPrimitiveMapping [

	^ {
		#form -> Circle.
		#innerLabel -> (SBTextBubble new contents: self key).
		#topLeftLabel -> (SBIcon iconUsb).
		#topCenterLabel ->  (SBTextBubble new contents: 'tc').
		#topRightLabel ->  (SBTextBubble new contents: 'tr').
		#rightLabel ->  (SBTextBubble new contents: 'r').
		#bottomRightLabel ->  (SBTextBubble new contents: 'H').
		#bottomCenterLabel ->  (SBTextBubble new contents: 'H').
		#bottomLeftLabel ->  (SBTextBubble new contents: 'H').
		#leftLabel ->  (SBTextBubble new contents: 'H').
		#connections -> ({self left. self right} reject: [:connection | connection isNil])}
]
