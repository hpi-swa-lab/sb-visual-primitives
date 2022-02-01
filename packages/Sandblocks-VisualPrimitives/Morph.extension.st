Extension { #name : #Morph }

{ #category : #'*Sandblocks-VisualPrimitives' }
Morph >> firstSubmorphOrNil [
	
	^ self submorphs ifEmpty: [nil] ifNotEmpty: [self firstSubmorph]
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Morph >> shrinkWrap [
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]
