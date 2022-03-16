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
	self morph canCreateConnectors ifTrue: [
		connector := (SBDomainBlockConnector
			connect: self morph
			align: #bottom
			to: self to
			align: #top)
			connectorType: #line;
			lineWidth: 1;
			color: Color black.
		aMorph addMorphBack: connector.
		aMorph addMorphBack: self to.
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
