Extension { #name : #Behavior }

{ #category : #'*Sandblocks-VisualPrimitives' }
Behavior >> canUnderstandBeforeObject: selector [ 

	(self includesSelector: selector) ifTrue: [^true].
	superclass == Object class ifTrue: [^false].
	^superclass canUnderstandBeforeObject: selector
]
