Class {
	#name : #SBVisualPrimitive,
	#superclass : #SBBlock,
	#instVars : [
		'label',
		'labelBlock'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #nil }
SBVisualPrimitive >> initialize [
	
	super initialize.
	labelBlock := SBTextBubble new.
	self
		addMorph: labelBlock;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #accessing }
SBVisualPrimitive >> label [

	^ label
]

{ #category : #nil }
SBVisualPrimitive >> label: aString [
	
	label := aString.
	self labelBlock contents: aString
]

{ #category : #accessing }
SBVisualPrimitive >> labelBlock [

	^ labelBlock
]

{ #category : #accessing }
SBVisualPrimitive >> labelBlock: anObject [

	labelBlock := anObject.
]
