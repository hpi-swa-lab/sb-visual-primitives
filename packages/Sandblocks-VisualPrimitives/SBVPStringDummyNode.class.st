Class {
	#name : #SBVPStringDummyNode,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPStringDummyNode >> dynamicVisualPrimitiveMapping [

	^ {
		SBVPPropertyMappingString property: #key primitiveProperty: #innerLabel on: self.
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

{ #category : #'as yet unclassified' }
SBVPStringDummyNode >> key [

	^ key asString
]

{ #category : #'as yet unclassified' }
SBVPStringDummyNode >> key: aValue [

	key := aValue asString
]
