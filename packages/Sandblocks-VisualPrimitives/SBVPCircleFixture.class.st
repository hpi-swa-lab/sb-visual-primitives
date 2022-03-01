Class {
	#name : #SBVPCircleFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPCircleFixture class >> visualPrimitiveMapping [

	^ {#shape -> CircleMorph new. #innerLabel -> #key. self childrenMappingEntry}
]
