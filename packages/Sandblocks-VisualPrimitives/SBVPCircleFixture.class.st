Class {
	#name : #SBCircleFixture,
	#superclass : #SBDummyNode,
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBCircleFixture class >> domainBlockMapping [

	^ {#shape -> CircleMorph new. #innerLabel -> #key. self childrenMappingEntry}
]
