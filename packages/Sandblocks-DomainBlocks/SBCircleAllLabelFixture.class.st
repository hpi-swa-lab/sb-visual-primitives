Class {
	#name : #SBCircleAllLabelFixture,
	#superclass : #SBDummyNode,
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBCircleAllLabelFixture class >> domainBlockMapping [

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
		self childrenMappingEntry}
]
