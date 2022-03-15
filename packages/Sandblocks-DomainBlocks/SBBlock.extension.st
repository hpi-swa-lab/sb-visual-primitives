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

{ #category : #'*Sandblocks-DomainBlocks' }
SBBlock >> patternContainer [

	| case |
	case := self patternRoot parentSandblock.
	^ (case isKindOf: SBPatternContainer) ifTrue: [case]
]

{ #category : #'*Sandblocks-DomainBlocks' }
SBBlock >> patternRoot [

	^ self patternParent ifNil: [self] ifNotNil: [self patternParent patternRoot]
]

{ #category : #'*Sandblocks-DomainBlocks' }
SBBlock >> patternSiblingIndex [

	^ self patternParent ifNil: [0] ifNotNil: [self patternParent patternChildren indexOf: self]
]
