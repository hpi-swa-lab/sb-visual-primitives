Extension { #name : #SBIcon }

{ #category : #'*Sandblocks-VisualPrimitives' }
SBIcon >> scale: aScaleFactor [

	^ super extent: TextStyle defaultFont height asPoint * aScaleFactor
]
