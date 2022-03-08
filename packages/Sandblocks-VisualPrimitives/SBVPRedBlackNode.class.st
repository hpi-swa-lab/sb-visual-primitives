Class {
	#name : #SBRedBlackNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'parent',
		'key',
		'isRed'
	],
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBRedBlackNode class >> buildTree: aCollection [

	^ (self buildTreePrivate: aCollection) first
]

{ #category : #'as yet unclassified' }
SBRedBlackNode class >> buildTreePrivate: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(self key: element key) children: (self buildTreePrivate: element value)]
			ifFalse: [self key: element]]
]

{ #category : #'as yet unclassified' }
SBRedBlackNode class >> childrenMappingEntry [

	^ SBPropertyMapping
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
SBRedBlackNode class >> exampleRootWithTwoChildren [

	| n1 n2 root |
	root := SBRedBlackNode new.
	root key: 4.
	n1 := SBRedBlackNode new.
	n1 key: 1.
	n2 := SBRedBlackNode new.
	n2 key: 2.
	root children: {n1. n2}.
	^ root
]

{ #category : #'as yet unclassified' }
SBRedBlackNode class >> key: anObject [

	^ self new key: anObject
]

{ #category : #nil }
SBRedBlackNode class >> domainBlockMapping [

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
SBRedBlackNode >> add: aNode [

	self
		example: [
			((SBRedBlackNode key: nil)
				children: {};
				isRed: true) showAsDomainBlock]
		args: [{'Hallo'}]
		label: 'example'
]

{ #category : #accessing }
SBRedBlackNode >> children [

	^ children
]

{ #category : #accessing }
SBRedBlackNode >> children: aCollection [

	children := aCollection
]

{ #category : #nil }
SBRedBlackNode >> initialize [

	super initialize.
	self isRed: true.
	self children: OrderedCollection new
]

{ #category : #accessing }
SBRedBlackNode >> isRed [

	^ isRed
]

{ #category : #accessing }
SBRedBlackNode >> isRed: aBoolean [

	isRed := aBoolean
]

{ #category : #accessing }
SBRedBlackNode >> key [

	^ key
]

{ #category : #accessing }
SBRedBlackNode >> key: anObject [

	key := anObject
]

{ #category : #accessing }
SBRedBlackNode >> parent [

	^ parent
]

{ #category : #accessing }
SBRedBlackNode >> parent: aNode [

	parent := aNode
]

{ #category : #accessing }
SBRedBlackNode >> writeSourceOn: aStream [

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
