Extension { #name : #Object }

{ #category : #'*Sandblocks-DomainBlocks' }
Object >> asDomainBlock [

	^ SBDomainBlock newFromObject: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Object class >> domainBlockMapping [

	^ {}
]

{ #category : #'*Sandblocks-DomainBlocks' }
Object >> isBindingPattern [

	^ false
]

{ #category : #'*Sandblocks-DomainBlocks' }
Object >> isDomainBlock [

	^ false
]

{ #category : #'*Sandblocks-DomainBlocks' }
Object >> isPropertyMapping [

	^ false
]

{ #category : #'*Sandblocks-DomainBlocks' }
Object >> propertyMappingClass [

	^ SBPropertyMapping
]

{ #category : #'*Sandblocks-DomainBlocks' }
Object >> showAsDomainBlock [
	"marker"

	^ self
]
