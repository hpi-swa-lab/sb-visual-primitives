Extension { #name : #Morph }

{ #category : #'*Sandblocks-VisualPrimitives' }
Morph >> addMorphFullBoundsCentered: aMorph [

	aMorph position: bounds center - (aMorph fullBounds extent // 2).
	self addMorphBack: aMorph.

]

{ #category : #'*Sandblocks-VisualPrimitives' }
Morph >> firstSubmorphOrNil [
	
	^ self submorphs ifEmpty: [nil] ifNotEmpty: [self firstSubmorph]
]
