Class {
	#name : #SBVPOrGroupPattern,
	#superclass : #SBVPGroupPattern,
	#instVars : [
		'boundPattern'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ boundPattern matches: aVisualPrimitive withBinding: aCollection
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> seperatorString [

	^ ' or '
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ self connections
		detect: [:pattern | pattern setBindingFor: aVisualPrimitive in: aCollection]
		ifFound: [:pattern |
			boundPattern := pattern.
			true]
		ifNone: [false]
]
