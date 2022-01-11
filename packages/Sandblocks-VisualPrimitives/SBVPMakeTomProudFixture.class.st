Class {
	#name : #SBVPMakeTomProudFixture,
	#superclass : #Object,
	#instVars : [
		'children',
		'key',
		'type'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #accessing }
SBVPMakeTomProudFixture >> children [

	^ children
]

{ #category : #accessing }
SBVPMakeTomProudFixture >> children: anObject [

	children := anObject.
]

{ #category : #accessing }
SBVPMakeTomProudFixture >> key [

	^ key
]

{ #category : #accessing }
SBVPMakeTomProudFixture >> key: anObject [

	key := anObject.
]

{ #category : #accessing }
SBVPMakeTomProudFixture >> type [

	^ type
]

{ #category : #accessing }
SBVPMakeTomProudFixture >> type: anObject [

	type := anObject.
]

{ #category : #'as yet unclassified' }
SBVPMakeTomProudFixture >> visualPrimitiveMapping [

	^ {
		#shape -> CircleMorph.
		#innerLabel -> #key.
		#topLeftLabel -> #type.
		#connections -> (self children reject: [:child | child isNil])}
]
