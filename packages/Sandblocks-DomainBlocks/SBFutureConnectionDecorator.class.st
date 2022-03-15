Class {
	#name : #SBFutureConnectionDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'to'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'change reporting' }
SBFutureConnectionDecorator >> noteNewOwner: aMorph [

	| connector |
	(self morph patternParent notNil or: [(self morph ownerThatIsA: SBDomainBlockContainer) notNil]) ifTrue: [
		connector := (SBConnectorLine connect: self morph align: #bottom to: self to align: #top)
			connectorType: #line;
			lineWidth: 1;
			color: Color black.
		aMorph addMorph: connector.
		aMorph addMorph: self to.
		self detach]
]

{ #category : #accessing }
SBFutureConnectionDecorator >> to [

	^ to
]

{ #category : #accessing }
SBFutureConnectionDecorator >> to: aDomainBlock [

	to := aDomainBlock
]
