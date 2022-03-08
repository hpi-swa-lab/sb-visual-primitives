Extension { #name : #Symbol }

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpChildFor: aSymbol [

	^ SBPropertyMappingChildren property: aSymbol vpProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpConstant: anObject [

	^ SBPropertyMapping constant: anObject vpProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpConstantNumber: aNumber [

	^ SBPropertyMappingNumber constant: aNumber vpProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpConstantString: aString [

	^ SBPropertyMappingString constant: aString vpProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpFor: aSymbol [

	^ self vpChildFor: aSymbol
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpNumberFor: aSymbol [

	^ SBPropertyMappingNumber property: aSymbol vpProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpNumberFor: aSymbol patternValue: aNumber [

	^ SBPropertyMappingNumber property: aSymbol vpProperty: self patternValue: aNumber
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpSelect: anOrderedCollection displayAs: anotherOrderedCollection at: aVPProperty [

	self assert: anOrderedCollection size = anotherOrderedCollection size.
	
	^ SBSelectProperty
		property: self
		vpProperty: aVPProperty
		choices: anOrderedCollection
		representations: anotherOrderedCollection
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpSelectFrom: anOrderedCollection displayAs: anotherOrderedCollection for: aSymbol [

	self assert: anOrderedCollection size = anotherOrderedCollection size.
	
	^ SBPropertyMappingSelect
		property: aSymbol
		vpProperty: self
		choices: anOrderedCollection
		representations: anotherOrderedCollection
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpSelectFrom: anOrderedCollection for: aSymbol [

	^ SBPropertyMappingSelect property: aSymbol vpProperty: self choices: anOrderedCollection
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpStringFor: aSymbol [

	^ SBPropertyMappingString property: aSymbol vpProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> vpStringFor: aSymbol patternValue: aString [

	^ SBPropertyMappingString property: aSymbol vpProperty: self patternValue: aString.
]
