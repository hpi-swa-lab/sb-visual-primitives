Class {
	#name : #SBVPRectangleTopLabelFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPRectangleTopLabelFixture >> visualPrimitiveMapping [

	^ {
		#shape -> RectangleMorph.
		#topCenterLabel -> (SBTextBubble new contents: 'top').
		#innerLabel -> (SBTextBubble new contents: self key).
		#connections -> ({self left. self right} reject: [:connection | connection isNil])}
]
