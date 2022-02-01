Class {
	#name : #SBVPTomCard,
	#superclass : #Object,
	#instVars : [
		'attack',
		'defense',
		'icon'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPTomCard class >> visualPrimitiveMapping [

	^ {
		SBVPPropertyMappingNumber property: #attack vpProperty: #topCenterLabel.
		SBVPPropertyMappingNumber property: #defense vpProperty: #bottomCenterLabel.
		SBVPPropertyMappingSelect
			property: #icon
			vpProperty: #shape
			choices: {'fire'. 'bug'. 'water'}
			representations: {SBIcon iconFire. SBIcon iconBug. SBIcon iconBathtub}.
		#topLeftLabel -> 'ATK:'.
		#bottomLeftLabel -> 'DEF'}
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
SBVPTomCard >> icon [

	^ icon
]

{ #category : #accessing }
SBVPTomCard >> icon: anObject [

	icon := anObject
]
