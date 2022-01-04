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

{ #category : #'as yet unclassified' }
SBVPDummyNode class >> buildTree: aCollection [

	^ self fromVisualPrimitive: (SBVisualPrimitive buildTree: aCollection) first
]

{ #category : #'as yet unclassified' }
SBVPDummyNode class >> exampleRootWithTwoChildren [

	| n1 n2 root |
	root := SBVPDummyNode new.
	root key: 'Carl-Friedrich'.
	n1 := SBVPDummyNode new.
	n1 key: 'peter'.
	n2 := SBVPDummyNode new.
	n2 key: 'n2'.
	root
		left: n1;
		right: n2.
	^ root
]

{ #category : #'as yet unclassified' }
SBVPDummyNode class >> fromVisualPrimitive: aVisualPrimitive [

	^ self fromVisualPrimitive: aVisualPrimitive withParent: nil
]

{ #category : #'as yet unclassified' }
SBVPDummyNode class >> fromVisualPrimitive: aVisualPrimitive withParent: aDummyNode [

	| node |
	aVisualPrimitive ifNil: [^ nil].
	
	node := self new.
	node
		left: (self fromVisualPrimitive: (aVisualPrimitive connections at: 1 ifAbsent: [nil]) withParent: node);
		right: (self fromVisualPrimitive: (aVisualPrimitive connections at: 2 ifAbsent: [nil]) withParent: node);
		parent: aDummyNode;
		key: aVisualPrimitive label.
	^ node
]

{ #category : #accessing }
SBVPDummyNode >> asVisualPrimitive [

	| vs |
	vs := SBVisualPrimitive new label: self key asString.
	self left ifNotNil: [:left | vs connections add: left asVisualPrimitive].
	self right ifNotNil: [:right | vs connections add: right asVisualPrimitive].
	vs origin: self.
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
	self parent ifNil: [decorator layout].
	vs origin: self.
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

{ #category : #accessing }
SBVPDummyNode >> visualPrimitiveMapping [

	^ {
		#shape -> RectangleMorph.
		#innerLabel -> #key.
		#connections -> ({self left. self right} reject: [:connection | connection isNil])}
]
