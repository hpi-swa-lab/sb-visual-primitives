Class {
	#name : #SBVPGameCard,
	#superclass : #Object,
	#instVars : [
		'attack',
		'defense',
		'type'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPGameCard class >> visualPrimitiveMapping [

	^ {
		#topLeftLabel vpConstant: 'ATK:'.
		#topCenterLabel vpNumberFor: #attack.
		#shape
			vpSelectFrom: {'fire'. 'bug'. 'water'}
			displayAs: {
				SBIcon iconFire color: (Color r: 1 g: 0.0 b: 0.0).
				SBIcon iconBug color: (Color r: 0.6 g: 0.2 b: 0.0).
				SBIcon iconTint color: (Color r: 0.0 g: 0.0 b: 1)}
			for: #type.
		#bottomLeftLabel vpConstant: 'DEF:'.
		#bottomCenterLabel vpNumberFor: #defense}
]

{ #category : #accessing }
SBVPGameCard >> attack [

	^ attack
]

{ #category : #accessing }
SBVPGameCard >> attack: anObject [

	attack := anObject
]

{ #category : #accessing }
SBVPGameCard >> defense [

	^ defense
]

{ #category : #accessing }
SBVPGameCard >> defense: anObject [

	defense := anObject
]

{ #category : #accessing }
SBVPGameCard >> type [

	^ type
]

{ #category : #accessing }
SBVPGameCard >> type: anObject [

	type := anObject
]
