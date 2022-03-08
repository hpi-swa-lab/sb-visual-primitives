Extension { #name : #SBBlock }

{ #category : #'*Sandblocks-DomainBlocks' }
SBBlock >> inspectProperties [
	<action>

	| inspector |
	inspector := SBPropertyInspector newFor: self.
	
	self sandblockEditor
		openMorphInView: inspector;
		openMorphInView: (SBForceConnector connect: self to: inspector)
]

{ #category : #'*Sandblocks-DomainBlocks' }
SBBlock >> inspectableProperties [

	^ {#color. #position}
]
