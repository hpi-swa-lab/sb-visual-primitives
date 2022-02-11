Extension { #name : #Symbol }

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpConnectionFor: aSymbol [

	^ SBVPPropertyMappingConnections property: aSymbol vpProperty: self
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpConstant: anObject [

	^ SBVPPropertyMapping constant: anObject vpProperty: self
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpConstantNumber: aNumber [

	^ SBVPPropertyMappingNumber constant: aNumber vpProperty: self
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpConstantString: aString [

	^ SBVPPropertyMappingString constant: aString vpProperty: self
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpFor: aSymbol [

	^ self vpConnectionFor: aSymbol
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpNumberFor: aSymbol [

	^ SBVPPropertyMappingNumber property: aSymbol vpProperty: self
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpNumberFor: aSymbol patternValue: aNumber [

	^ SBVPPropertyMappingNumber property: aSymbol vpProperty: self patternValue: aNumber
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpSelect: anOrderedCollection displayAs: anotherOrderedCollection at: aVPProperty [

	self assert: anOrderedCollection size = anotherOrderedCollection size.
	
	^ SBVPSelectProperty
		property: self
		vpProperty: aVPProperty
		choices: anOrderedCollection
		representations: anotherOrderedCollection
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpSelectFrom: anOrderedCollection displayAs: anotherOrderedCollection for: aSymbol [

	self assert: anOrderedCollection size = anotherOrderedCollection size.
	
	^ SBVPSelectProperty
		property: aSymbol
		vpProperty: self
		choices: anOrderedCollection
		representations: anotherOrderedCollection
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpSelectFrom: anOrderedCollection for: aSymbol [

	^ SBVPPropertyMappingSelect property: aSymbol vpProperty: self choices: anOrderedCollection
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpStringFor: aSymbol [

	^ SBVPPropertyMappingString property: aSymbol vpProperty: self
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Symbol >> vpStringFor: aSymbol patternValue: aString [

	^ SBVPPropertyMappingString property: aSymbol vpProperty: self patternValue: aString.
]
