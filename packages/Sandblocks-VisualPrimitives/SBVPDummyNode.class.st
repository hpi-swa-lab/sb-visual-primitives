Class {
	#name : #SBVPDummyNode,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'parent',
		'isBlue',
		'key'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #accessing }
SBVPDummyNode >> asVisualPrimitive [

	| decorator vs |
	decorator := SBTreeDecorator new.
	vs := (SBVisualPrimitive new label: self key asString) attachDecorator: decorator.
	self left ifNotNil: [:left |
		left asVisualPrimitive
			withDecorator: SBTreeDecorator
			do: [:childDecorator | decorator addChild: childDecorator]].
	self right ifNotNil: [:right |
		right asVisualPrimitive
			withDecorator: SBTreeDecorator
			do: [:childDecorator | decorator addChild: childDecorator]].
	^ vs
]

{ #category : #accessing }
SBVPDummyNode >> asVisualPrimitiveIn: aWorld [

	| decorator vs |
	decorator := SBTreeDecorator new.
	vs := (SBVisualPrimitive new label: self key asString) attachDecorator: decorator.
	aWorld addMorphBack: vs.
	self left ifNotNil: [:left |
		(left asVisualPrimitiveIn: aWorld)
			withDecorator: SBTreeDecorator
			do: [:childDecorator | decorator addChild: childDecorator]].
	self right ifNotNil: [:right |
		(right asVisualPrimitiveIn: aWorld)
			withDecorator: SBTreeDecorator
			do: [:childDecorator | decorator addChild: childDecorator]].
	^ vs
]

{ #category : #accessing }
SBVPDummyNode >> isBlue [

	^ isBlue
]

{ #category : #accessing }
SBVPDummyNode >> isBlue: aBoolean [

	isBlue := aBoolean
]

{ #category : #accessing }
SBVPDummyNode >> key [

	^ key
]

{ #category : #accessing }
SBVPDummyNode >> key: aNumber [

	key := aNumber
]

{ #category : #accessing }
SBVPDummyNode >> left [

	^ left
]

{ #category : #accessing }
SBVPDummyNode >> left: aNode [

	left := aNode
]

{ #category : #accessing }
SBVPDummyNode >> parent [

	^ parent
]

{ #category : #accessing }
SBVPDummyNode >> parent: aNode [

	parent := aNode
]

{ #category : #accessing }
SBVPDummyNode >> right [

	^ right
]

{ #category : #accessing }
SBVPDummyNode >> right: aNode [

	right := aNode
]
