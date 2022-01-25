Class {
	#name : #SBVPDummyNode,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'parent',
		'key'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
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

{ #category : #'as yet unclassified' }
SBVPDummyNode class >> staticVisualPrimitiveMapping [

	^ {#shape -> RectangleMorph new. #topLeftLabel -> SBIcon iconBug}
]

{ #category : #accessing }
SBVPDummyNode >> dynamicVisualPrimitiveMapping [

	^ {
		SBVPPropertyMappingNumber property: #key primitiveProperty: #innerLabel on: self.
		SBVPPropertyMapping
			getter: [{self left. self right} reject: [:connection | connection isNil]]
			setter: [:vp |
				vp connections size >= 1
					ifTrue: [self left: vp connections first getObjectFromVisualPrimitive]
					ifFalse: [self left: nil].
				vp connections size >= 2
					ifTrue: [self right: vp connections second getObjectFromVisualPrimitive]
					ifFalse: [self right: nil]]
			position: #connections}
]

{ #category : #accessing }
SBVPDummyNode >> key [

	^ key
]

{ #category : #accessing }
SBVPDummyNode >> key: aValue [

	key := aValue
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
