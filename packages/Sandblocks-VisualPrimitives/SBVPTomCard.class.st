Class {
	#name : #SBVPTomCard,
	#superclass : #Object,
	#instVars : [
		'attack',
		'defense',
		'type'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPTomCard class >> visualPrimitiveMapping [

	^ {
		#topCenterLabel vpNumberFor: #attack.
		#bottomCenterLabel vpNumberFor: #defense.
		#shape
			vpSelectFrom: {'fire'. 'bug'. 'water'}
			displayAs: {SBIcon iconFire color: Color red. SBIcon iconBug color: Color brown. SBIcon iconTint color: Color blue}
			for: #type.
		#topLeftLabel vpConstant: 'ATK:'.
		#bottomLeftLabel vpConstant: 'DEF'}
]

{ #category : #accessing }
SBVPTomCard >> attack [

	^ attack
]

{ #category : #accessing }
SBVPTomCard >> attack: anObject [

	attack := anObject
]

{ #category : #accessing }
SBVPTomCard >> defense [

	^ defense
]

{ #category : #accessing }
SBVPTomCard >> defense: anObject [

	defense := anObject
]

{ #category : #accessing }
SBVPTomCard >> type [
	^ type
]

{ #category : #accessing }
SBVPTomCard >> type: anObject [
	type := anObject
]
