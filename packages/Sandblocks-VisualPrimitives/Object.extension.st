Extension { #name : #Object }

{ #category : #'*Sandblocks-VisualPrimitives' }
Object >> asVisualPrimitive [

	^ SBVisualPrimitive newFromObject: self
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
Object >> showAsVisualPrimitive [
	"marker"
	^ self
]

{ #category : #'*Sandblocks-VisualPrimitives' }
Object >> visualPrimitiveMapping [

	^ {}
]
