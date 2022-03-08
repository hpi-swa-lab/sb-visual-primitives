Class {
	#name : #SBRectangleTopLabelFixture,
	#superclass : #SBDummyNode,
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBRectangleTopLabelFixture class >> domainBlockMapping [

	^ super domainBlockMapping, {SBPropertyMappingString property: #key vpProperty: #innerLabel}
]
