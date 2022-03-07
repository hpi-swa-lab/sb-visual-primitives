Extension { #name : #BlockClosure }

{ #category : #'*Sandblocks-VisualPrimitives' }
BlockClosure >> storeOn: aStream [

	aStream nextPutAll: self sourceString
]
