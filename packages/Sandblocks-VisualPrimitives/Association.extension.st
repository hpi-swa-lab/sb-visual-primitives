Extension { #name : #Association }

{ #category : #'*Sandblocks-DomainBlocks' }
Association >> asPropertyMapping [
	
	^ self value propertyMappingClass fromAssociation: self
]
