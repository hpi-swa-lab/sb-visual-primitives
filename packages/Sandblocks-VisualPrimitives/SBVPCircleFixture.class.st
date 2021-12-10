Class {
	#name : #SBVPCircleFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPCircleFixture >> visualPrimitiveMapping [

	^ {
		#form -> Circle.
		#innerLabel -> (SBTextBubble new contents: self key).
		#connections -> ({self left. self right} reject: [:connection | connection isNil])}
]
