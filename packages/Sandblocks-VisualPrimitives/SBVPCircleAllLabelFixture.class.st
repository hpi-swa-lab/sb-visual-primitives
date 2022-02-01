Class {
	#name : #SBVPCircleAllLabelFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPCircleAllLabelFixture class >> visualPrimitiveMapping [

	^ {
		#shape -> CircleMorph new.
		#innerLabel -> #key.
		#topLeftLabel -> SBIcon iconUsb.
		#topCenterLabel -> 'tc'.
		#topRightLabel -> 'tr'.
		#rightLabel -> 'r'.
		#bottomRightLabel -> 'br'.
		#bottomCenterLabel -> 'bc'.
		#bottomLeftLabel -> 'bl'.
		#leftLabel -> 'l'.
		self connectionsMappingEntry}
]
