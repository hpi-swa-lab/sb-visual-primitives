Class {
	#name : #SBVisualPrimitive,
	#superclass : #SBBlock,
	#instVars : [
		'label',
		'labelBlock',
		'connections'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> new: aLabel [

	^ self new label: aLabel
]

{ #category : #accessing }
SBVisualPrimitive >> connections [

	^ connections
]

{ #category : #accessing }
SBVisualPrimitive >> connections: anObject [

	connections := anObject
]

{ #category : #nil }
SBVisualPrimitive >> initialize [

	super initialize.
	labelBlock := SBTextBubble new.
	self
		addMorph: labelBlock;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		connections: {}
]

{ #category : #accessing }
SBVisualPrimitive >> label [

	^ label
]

{ #category : #nil }
SBVisualPrimitive >> label: anObject [

	label := anObject.
	self labelBlock contents: anObject asString
]

{ #category : #accessing }
SBVisualPrimitive >> labelBlock [

	^ labelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> labelBlock: anObject [

	labelBlock := anObject
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' label: ';
		nextPutAll: self label asString
]
