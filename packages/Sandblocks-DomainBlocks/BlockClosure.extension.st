Extension { #name : #BlockClosure }

{ #category : #'*Sandblocks-DomainBlocks' }
BlockClosure >> storeOn: aStream [

	aStream nextPutAll: self sourceString
]
