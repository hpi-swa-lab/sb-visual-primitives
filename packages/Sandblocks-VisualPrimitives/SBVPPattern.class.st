Class {
	#name : #SBVPPattern,
	#superclass : #SBVisualPrimitive,
	#instVars : [
		'isImplicitChild'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPattern >> addImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> buildImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> findConstant [

	self connections do: [:child | child findConstant ifNotNil: [:constant | ^ constant]].
	^ nil
]

{ #category : #'as yet unclassified' }
SBVPPattern >> findOriginRoot [

	^ self findConstant asVisualPrimitive root origin
]

{ #category : #'as yet unclassified' }
SBVPPattern >> getNext: aVisualPrimitive [
	"updates the visual primitive the pattern will bind to and returns whether a new binding was found. Whether the binding is correct needs to be checked with matches: withBinding:."

	^ false
]

{ #category : #'as yet unclassified' }
SBVPPattern >> highestBindingVariable [

	^ (self label ifNil: [0] ifNotNil: [:l | l asInteger ifNil: [0]]) max: (self connections
		ifEmpty: [0]
		ifNotEmpty: [(self connections collect: [:connection | connection highestBindingVariable]) max])
]

{ #category : #accessing }
SBVPPattern >> initialize [

	super initialize.
	self isImplicitChild: false
]

{ #category : #accessing }
SBVPPattern >> isImplicitChild [

	^ isImplicitChild
]

{ #category : #accessing }
SBVPPattern >> isImplicitChild: aBoolean [

	isImplicitChild := aBoolean
]

{ #category : #'as yet unclassified' }
SBVPPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPPattern >> removeImplicitChildren [

	self connections: (self connections reject: [:child | child isImplicitChild]).
	self connections do: [:child | child removeImplicitChildren]
]

{ #category : #'as yet unclassified' }
SBVPPattern >> reset [
	"do nothing"

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPPattern >> wantsImplicitNeighbors [

	^ true
]
