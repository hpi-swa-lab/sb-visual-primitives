Extension { #name : #Symbol }

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbChildFor: aSymbol [

	^ SBPropertyMappingChildren property: aSymbol dbProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbConstant: anObject [

	^ SBPropertyMapping constant: anObject dbProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbConstantNumber: aNumber [

	^ SBPropertyMappingNumber constant: aNumber dbProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbConstantString: aString [

	^ SBPropertyMappingString constant: aString dbProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbFor: aSymbol [

	^ self dbChildFor: aSymbol
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbNumberFor: aSymbol [

	^ SBPropertyMappingNumber property: aSymbol dbProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbNumberFor: aSymbol patternValue: aNumber [

	^ SBPropertyMappingNumber property: aSymbol dbProperty: self patternValue: aNumber
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbSelectFrom: anOrderedCollection displayAs: anotherOrderedCollection for: aSymbol [

	self assert: anOrderedCollection size = anotherOrderedCollection size.
	
	^ SBPropertyMappingSelect
		property: aSymbol
		dbProperty: self
		choices: anOrderedCollection
		representations: anotherOrderedCollection
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbSelectFrom: anOrderedCollection for: aSymbol [

	^ SBPropertyMappingSelect
		property: aSymbol
		dbProperty: self
		choices: anOrderedCollection
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbStringFor: aSymbol [

	^ SBPropertyMappingString property: aSymbol dbProperty: self
]

{ #category : #'*Sandblocks-DomainBlocks' }
Symbol >> dbStringFor: aSymbol patternValue: aString [

	^ SBPropertyMappingString property: aSymbol dbProperty: self patternValue: aString
]
