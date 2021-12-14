Class {
	#name : #SBVPCircleAllLabelFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPCircleAllLabelFixture >> visualPrimitiveMapping [

	^ {
		#shape -> CircleMorph.
		#innerLabel -> #key.
		#topLeftLabel -> SBIcon iconUsb.
		#topCenterLabel -> 'tc'.
		#topRightLabel -> 'tr'.
		#rightLabel -> 'r'.
		#bottomRightLabel -> 'br'.
		#bottomCenterLabel -> 'bc'.
		#bottomLeftLabel -> 'bl'.
		#leftLabel -> 'l'.
		#connections -> ({self left. self right} reject: [:connection | connection isNil])}
]
