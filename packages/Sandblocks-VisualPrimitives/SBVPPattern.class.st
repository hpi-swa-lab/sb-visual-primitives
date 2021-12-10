Class {
	#name : #SBVPPattern,
	#superclass : #SBVisualPrimitive,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPattern >> findConstant [

	^ self connections do: [:child | child findConstant]
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

{ #category : #'as yet unclassified' }
SBVPPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPPattern >> reset [
	"do nothing"

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ true
]
