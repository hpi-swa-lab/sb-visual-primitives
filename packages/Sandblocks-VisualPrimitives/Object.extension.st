Extension { #name : #Object }

{ #category : #'*Sandblocks-VisualPrimitives' }
Object >> asVisualPrimitive [

	^ SBVisualPrimitive new label: (self printStringLimitedTo: 10)
]
