Extension { #name : #SBBlock }

{ #category : #'*Sandblocks-VisualPrimitives' }
SBBlock >> inspect [
	
	<action>
	| inspector |
	inspector := SBPropertyInspector newFor: self.
	
	self sandblockEditor openMorphInView: inspector; 
		openMorphInView: (SBForceConnector connect: self to: inspector)	
]

{ #category : #'*Sandblocks-VisualPrimitives' }
SBBlock >> inspectableProperties [

	^ {#color. #position}
]
