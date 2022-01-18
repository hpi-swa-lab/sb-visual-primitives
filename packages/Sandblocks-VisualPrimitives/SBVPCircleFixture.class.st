Class {
	#name : #SBVPCircleFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPCircleFixture >> dynamicVisualPrimitiveMapping [

	^ {
		#shape -> CircleMorph.
		#innerLabel -> #key.
		#connections -> ({self left. self right} reject: [:connection | connection isNil])}
]
