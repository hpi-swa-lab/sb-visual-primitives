Extension { #name : #Array }

{ #category : #'*Sandblocks-DomainBlocks' }
Array >> writeSourceOn: aStream [

	aStream nextPut: ${.
	self do: [:elem |
		(elem respondsTo: #writeSourceOn:)
			ifTrue: [elem writeSourceOn: aStream]
			ifFalse: [elem storeOn: aStream]].
	aStream nextPut: $}
]
