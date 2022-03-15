Extension { #name : #Behavior }

{ #category : #'*Sandblocks-DomainBlocks' }
Behavior >> canUnderstandBeforeObject: selector [

	(self includesSelector: selector) ifTrue: [^ true].
	superclass == Object class ifTrue: [^ false].
	^ superclass canUnderstandBeforeObject: selector
]
