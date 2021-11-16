Class {
	#name : #SBVisualPrimitive,
	#superclass : #SBStSubstitution,
	#instVars : [
		'label',
		'labelBlock',
		'connections'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> matches: aBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> new: aLabel [

	^ self new label: aLabel
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive class >> selector: aString receiverMatches: aMessage [

	(aMessage isSandblock and: [(aMessage isMessageSend and: [aMessage receiver notNil]) or: [self matchesCascades and: [aMessage isCascade]]]) ifFalse: [^ false].
	
	^ (aMessage receiver satisfies: #(#notNil #isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #'as yet unclassified' }
SBVisualPrimitive >> addToWorld: aWorld [

	^ self subclassResponsibility
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
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		connections: OrderedCollection new
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
