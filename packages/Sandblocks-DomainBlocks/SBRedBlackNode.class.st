Class {
	#name : #SBRedBlackNode,
	#superclass : #Object,
	#instVars : [
		'patternChildren',
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
			ifTrue: [(self key: element key) patternChildren: (self buildTreePrivate: element value)]
			ifFalse: [self key: element]]
]

{ #category : #'as yet unclassified' }
SBRedBlackNode class >> childrenMappingEntry [

	^ SBPropertyMapping
		getter: [:object | {object left. object right} reject: [:child | child isNil]]
		setter: [:object :vp |
			vp patternChildren size >= 1
				ifTrue: [object left: vp patternChildren first buildObject]
				ifFalse: [object left: nil].
			vp patternChildren size >= 2
				ifTrue: [object right: vp patternChildren second buildObject]
				ifFalse: [object right: nil]]
		vpProperty: #patternChildren
		name: 'patternChildren'
]

{ #category : #nil }
SBRedBlackNode class >> domainBlockMapping [

	^ {
		#shape
			vpSelectFrom: {true. false}
			displayAs: {CircleMorph new color: Color red. CircleMorph new color: Color black}
			for: #isRed.
		#patternChildren vpChildFor: #patternChildren.
		#innerLabel vpNumberFor: #key.
		#identityLabelPosition vpConstant: #leftLabel}
]

{ #category : #'as yet unclassified' }
SBRedBlackNode class >> key: anObject [

	^ self new key: anObject
]

{ #category : #nil }
SBRedBlackNode >> add: aNode [

	self
		example: [
			((SBRedBlackNode key: nil)
				patternChildren: {};
				isRed: true) showAsDomainBlock]
		args: [{'Hallo'}]
		label: 'example'
]

{ #category : #accessing }
SBRedBlackNode >> patternChildren [

	^ patternChildren
]

{ #category : #accessing }
SBRedBlackNode >> patternChildren: aCollection [

	patternChildren := aCollection
]

{ #category : #nil }
SBRedBlackNode >> initialize [

	super initialize.
	self isRed: true.
	self patternChildren: OrderedCollection new
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
		nextPutAll: ' patternChildren: {'.
	
	self patternChildren do: [:child | child writeSourceOn: aStream].
	aStream
		nextPutAll: '}; isRed: ';
		store: self isRed.
	
	aStream nextPut: $)
]
