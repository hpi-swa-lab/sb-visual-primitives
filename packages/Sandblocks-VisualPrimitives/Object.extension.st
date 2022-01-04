Extension { #name : #Object }

{ #category : #'*Sandblocks-VisualPrimitives' }
Object >> asVisualPrimitive [

	^ SBVisualPrimitive new label: (self printStringLimitedTo: 10)
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Object >> isPropertyMapping [

	^ false
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Object >> isVisualPrimitive [

	^ false
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Object >> visualPrimitiveMapping [

	^ {}
]
