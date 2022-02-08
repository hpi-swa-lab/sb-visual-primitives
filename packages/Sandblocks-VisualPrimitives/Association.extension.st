Extension { #name : #Association }

{ #category : #'*Sandblocks-VisualPrimitives' }
Association >> asPropertyMapping [
	
	^ self value propertyMappingClass fromAssociation: self
]
