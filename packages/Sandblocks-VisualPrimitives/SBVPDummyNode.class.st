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

	^ (self buildTreePrivate: aCollection) first
]

{ #category : #'as yet unclassified' }
SBVPDummyNode class >> buildTreePrivate: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(self key: element key) children: (self buildTreePrivate: element value)]
			ifFalse: [self key: element]]
]

{ #category : #'as yet unclassified' }
SBVPDummyNode class >> connectionsMappingEntry [

	^ SBVPPropertyMapping
		getter: [:object | {object left. object right} reject: [:connection | connection isNil]]
		setter: [:object :vp |
			vp connections size >= 1
				ifTrue: [object left: vp connections first getObjectFromVisualPrimitive]
				ifFalse: [object left: nil].
			vp connections size >= 2
				ifTrue: [object right: vp connections second getObjectFromVisualPrimitive]
				ifFalse: [object right: nil]]
		vpProperty: #connections
		name: 'connections'
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
SBVPDummyNode class >> key: anObject [

	^ self new key: anObject
]

{ #category : #'as yet unclassified' }
SBVPDummyNode class >> visualPrimitiveMapping [

	^ {
		#shape -> (RectangleMorph new
			color: (Color r: 0.0 g: 1 b: 0.502);
			changeTableLayout;
			listCentering: #center;
			wrapCentering: #center;
			shrinkWrap;
			layoutInset: 8;
			yourself).
		#topLeftLabel -> SBIcon iconBug.
		SBVPPropertyMappingNumber property: #key vpProperty: #innerLabel.
		self connectionsMappingEntry}
]

{ #category : #'as yet unclassified' }
SBVPDummyNode >> children: aCollection [

	self left: (aCollection size >= 1 ifTrue: [aCollection first]).
	self right: (aCollection size >= 2 ifTrue: [aCollection second])
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

{ #category : #accessing }
SBVPDummyNode >> writeSourceOn: aStream [

	aStream
		nextPutAll: '((';
		nextPutAll: self className;
		nextPutAll: ' key: ';
		store: self key;
		nextPut: $).
	
	self left ifNotNil: [
		aStream nextPutAll: ' left: '.
		self left writeSourceOn: aStream].
	
	self right ifNotNil: [
		self left ifNotNil: [aStream nextPut: $;].
		aStream nextPutAll: ' right: '.
		self right writeSourceOn: aStream].
	
	aStream nextPut: $)
]
