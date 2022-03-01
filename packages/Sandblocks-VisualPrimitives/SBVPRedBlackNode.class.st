Class {
	#name : #SBVPRedBlackNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'parent',
		'key',
		'isRed'
	],
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPRedBlackNode class >> buildTree: aCollection [

	^ (self buildTreePrivate: aCollection) first
]

{ #category : #'as yet unclassified' }
SBVPRedBlackNode class >> buildTreePrivate: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(self key: element key) children: (self buildTreePrivate: element value)]
			ifFalse: [self key: element]]
]

{ #category : #'as yet unclassified' }
SBVPRedBlackNode class >> childrenMappingEntry [

	^ SBVPPropertyMapping
		getter: [:object | {object left. object right} reject: [:child | child isNil]]
		setter: [:object :vp |
			vp children size >= 1
				ifTrue: [object left: vp children first buildObject]
				ifFalse: [object left: nil].
			vp children size >= 2
				ifTrue: [object right: vp children second buildObject]
				ifFalse: [object right: nil]]
		vpProperty: #children
		name: 'children'
]

{ #category : #'as yet unclassified' }
SBVPRedBlackNode class >> exampleRootWithTwoChildren [

	| n1 n2 root |
	root := SBVPRedBlackNode new.
	root key: 4.
	n1 := SBVPRedBlackNode new.
	n1 key: 1.
	n2 := SBVPRedBlackNode new.
	n2 key: 2.
	root children: {n1. n2}.
	^ root
]

{ #category : #'as yet unclassified' }
SBVPRedBlackNode class >> key: anObject [

	^ self new key: anObject
]

{ #category : #nil }
SBVPRedBlackNode class >> visualPrimitiveMapping [

	^ {
		#shape
			vpSelectFrom: {true. false}
			displayAs: {CircleMorph new color: Color red. CircleMorph new color: Color black}
			for: #isRed.
		#children vpChildFor: #children.
		#innerLabel vpNumberFor: #key.
		#identityLabelPosition vpConstant: #leftLabel}
]

{ #category : #nil }
SBVPRedBlackNode >> add: aNode [

	self
		example: [
			((SBVPRedBlackNode key: nil)
				children: {};
				isRed: true) showAsVisualPrimitive]
		args: [{'Hallo'}]
		label: 'example'
]

{ #category : #accessing }
SBVPRedBlackNode >> children [

	^ children
]

{ #category : #accessing }
SBVPRedBlackNode >> children: aCollection [

	children := aCollection
]

{ #category : #nil }
SBVPRedBlackNode >> initialize [

	super initialize.
	self isRed: true.
	self children: OrderedCollection new
]

{ #category : #accessing }
SBVPRedBlackNode >> isRed [

	^ isRed
]

{ #category : #accessing }
SBVPRedBlackNode >> isRed: aBoolean [

	isRed := aBoolean
]

{ #category : #accessing }
SBVPRedBlackNode >> key [

	^ key
]

{ #category : #accessing }
SBVPRedBlackNode >> key: anObject [

	key := anObject
]

{ #category : #accessing }
SBVPRedBlackNode >> parent [

	^ parent
]

{ #category : #accessing }
SBVPRedBlackNode >> parent: aNode [

	parent := aNode
]

{ #category : #accessing }
SBVPRedBlackNode >> writeSourceOn: aStream [

	aStream
		nextPutAll: '((';
		nextPutAll: self className;
		nextPutAll: ' key: ';
		store: self key;
		nextPut: $);
		nextPutAll: ' children: {'.
	
	self children do: [:child | child writeSourceOn: aStream].
	aStream
		nextPutAll: '}; isRed: ';
		store: self isRed.
	
	aStream nextPut: $)
]
