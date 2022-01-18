Extension { #name : #Morph }

{ #category : #'*Sandblocks-VisualPrimitives' }
Morph >> firstSubmorphOrNil [
	
	^ self submorphs ifEmpty: [nil] ifNotEmpty: [self firstSubmorph]
]
