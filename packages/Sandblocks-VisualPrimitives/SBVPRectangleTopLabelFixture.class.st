Class {
	#name : #SBVPRectangleTopLabelFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPRectangleTopLabelFixture >> dynamicVisualPrimitiveMapping [

	^ super dynamicVisualPrimitiveMapping, {SBVPPropertyMappingString property: #key primitiveProperty: #innerLabel on: self}
]
