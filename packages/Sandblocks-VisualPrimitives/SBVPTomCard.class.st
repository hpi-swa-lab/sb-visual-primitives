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
SBVPTomCard class >> staticVisualPrimitiveMapping [

	^ {#topLeftLabel -> 'ATK:'. #bottomLeftLabel -> 'DEF'}
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
SBVPTomCard >> dynamicVisualPrimitiveMapping [

	^ {
		SBVPPropertyMappingNumber
			property: #attack
			primitiveProperty: #topCenterLabel
			on: self.
		SBVPPropertyMappingNumber
			property: #defense
			primitiveProperty: #bottomCenterLabel
			on: self.
		SBVPPropertyMappingSelect
			property: #icon
			primitiveProperty: #shape
			choices: {'fire'. 'bug'. 'water'}
			representations: {SBIcon iconFire. SBIcon iconBug. SBIcon iconBathtub}
			on: self}
]

{ #category : #accessing }
SBVPTomCard >> icon [

	^ icon
]

{ #category : #accessing }
SBVPTomCard >> icon: anObject [

	icon := anObject
]
