Class {
	#name : #SBGameCard,
	#superclass : #Object,
	#instVars : [
		'attack',
		'defense',
		'type'
	],
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBGameCard class >> domainBlockMapping [

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
SBGameCard >> attack [

	^ attack
]

{ #category : #accessing }
SBGameCard >> attack: anObject [

	attack := anObject
]

{ #category : #accessing }
SBGameCard >> defense [

	^ defense
]

{ #category : #accessing }
SBGameCard >> defense: anObject [

	defense := anObject
]

{ #category : #accessing }
SBGameCard >> type [

	^ type
]

{ #category : #accessing }
SBGameCard >> type: anObject [

	type := anObject
]
