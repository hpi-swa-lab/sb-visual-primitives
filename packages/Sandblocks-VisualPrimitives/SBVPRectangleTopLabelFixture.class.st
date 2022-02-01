Class {
	#name : #SBVPRectangleTopLabelFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPRectangleTopLabelFixture class >> visualPrimitiveMapping [

	^ super visualPrimitiveMapping, {SBVPPropertyMappingString property: #key vpProperty: #innerLabel}
]
