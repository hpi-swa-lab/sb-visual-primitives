Extension { #name : #SequenceableCollection }

{ #category : #'*Sandblocks-DomainBlocks' }
SequenceableCollection >> withIndexAllSatisfy: aBlock [
	
	self withIndexDo: [:element :index | (aBlock value: element value: index) ifFalse: [^ false]].
	^ true
]
