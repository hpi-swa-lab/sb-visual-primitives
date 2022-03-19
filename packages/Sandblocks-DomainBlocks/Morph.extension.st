Extension { #name : #Morph }

{ #category : #'*Sandblocks-DomainBlocks' }
Morph >> addDBLabel: aMorph [

	aMorph ifNil: [^ nil].
	self removeAllMorphs.
	^ self addMorphBack: aMorph
]

{ #category : #'*Sandblocks-DomainBlocks' }
Morph >> firstSubmorphOrNil [

	^ self submorphs ifEmpty: [nil] ifNotEmpty: [self firstSubmorph]
]

{ #category : #'*Sandblocks-DomainBlocks' }
Morph >> shrinkWrap [

	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]
