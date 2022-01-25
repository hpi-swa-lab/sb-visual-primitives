Class {
	#name : #SBVPSpecialShapeFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPSpecialShapeFixture >> dynamicVisualPrimitiveMapping [

	^ {
		SBVPPropertyMapping
			getter: [
				CircleMorph new
					color: (Color r: 0.5 g: 0.5 b: (self key ifNotNil: [:key | key asInteger / 255] ifNil: [0]));
					yourself]
			setter: [:vp | self key: ((vp propertyAt: #shape) color blue * 255) rounded]
			position: #shape
			optionalArgs: Dictionary new.
		SBVPPropertyMappingNumber property: #key primitiveProperty: #innerLabel on: self.
		SBVPPropertyMapping
			getter: [{self left. self right} reject: [:connection | connection isNil]]
			setter: [:vp |
				vp connections size >= 1
					ifTrue: [self left: vp connections first getObjectFromVisualPrimitive]
					ifFalse: [self left: nil].
				vp connections size >= 2
					ifTrue: [self right: vp connections second getObjectFromVisualPrimitive]
					ifFalse: [self right: nil]]
			position: #connections
			optionalArgs: Dictionary new}
]
