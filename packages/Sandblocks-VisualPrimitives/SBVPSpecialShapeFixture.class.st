Class {
	#name : #SBVPSpecialShapeFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPSpecialShapeFixture class >> visualPrimitiveMapping [

	^ {
		SBVPPropertyMapping
			getter: [:object |
				CircleMorph new
					color: (Color r: 0.5 g: 0.5 b: (object key ifNotNil: [:key | key asInteger / 255] ifNil: [0]));
					yourself]
			setter: [:object :vp | object key: ((vp propertyAt: #shape) color blue * 255) rounded]
			patternValue: (CircleMorph new color: (Color r: 0.5 g: 0.5 b: 0.1))
			vpProperty: #shape
			name: 'shape'.
		SBVPPropertyMappingNumber property: #key vpProperty: #innerLabel.
		self connectionsMappingEntry}
]
