Extension { #name : #SBIcon }

{ #category : #'*Sandblocks-DomainBlocks' }
SBIcon >> scale: aScaleFactor [

	^ super extent: TextStyle defaultFont height asPoint * aScaleFactor
]
