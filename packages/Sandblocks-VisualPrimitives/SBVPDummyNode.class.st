Class {
	#name : #SBDummyNode,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'parent',
		'key'
	],
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBDummyNode class >> buildTree: aCollection [

	^ (self buildTreePrivate: aCollection) first
]

{ #category : #'as yet unclassified' }
SBDummyNode class >> buildTreePrivate: aCollection [

	^ aCollection collect: [:element |
		element isVariableBinding
			ifTrue: [(self key: element key) children: (self buildTreePrivate: element value)]
			ifFalse: [self key: element]]
]

{ #category : #'as yet unclassified' }
SBDummyNode class >> childrenMappingEntry [

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
SBDummyNode class >> exampleRootWithTwoChildren [

	| n1 n2 root |
	root := SBDummyNode new.
	root key: 'Carl-Friedrich'.
	n1 := SBDummyNode new.
	n1 key: 'peter'.
	n2 := SBDummyNode new.
	n2 key: 'n2'.
	root
		left: n1;
		right: n2.
	^ root
]

{ #category : #'as yet unclassified' }
SBDummyNode class >> key: anObject [

	^ self new key: anObject
]

{ #category : #'as yet unclassified' }
SBDummyNode class >> domainBlockMapping [

	^ {
		#shape vpConstant: (RectangleMorph new
			color: (Color r: 0.0 g: 1 b: 0.502);
			changeTableLayout;
			listCentering: #center;
			wrapCentering: #center;
			shrinkWrap;
			layoutInset: 8;
			yourself).
		#identityLabelPosition vpConstant: #bottomCenterLabel.
		#innerLabel vpNumberFor: #key.
		self childrenMappingEntry}
]

{ #category : #'as yet unclassified' }
SBDummyNode >> children: aCollection [

	self left: (aCollection size >= 1 ifTrue: [aCollection first]).
	self right: (aCollection size >= 2 ifTrue: [aCollection second])
]

{ #category : #'as yet unclassified' }
SBDummyNode >> exampleHeapTransformation [

	^ SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #boi) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode
]

{ #category : #'as yet unclassified' }
SBDummyNode >> exampleMultipleBindings: aTree [

	self
		example: [SBDummyNode new]
		args: [
			{
				((SBDummyNode key: 9) left: ((SBDummyNode key: 10)
					left: ((SBDummyNode key: 3)
						left: ((SBDummyNode key: 1)
							left: (SBDummyNode key: 0);
							right: (SBDummyNode key: 1));
						right: ((SBDummyNode key: 2) left: (SBDummyNode key: 5)));
					right: ((SBDummyNode key: 7)
						left: ((SBDummyNode key: 5)
							left: (SBDummyNode key: 5);
							right: (SBDummyNode key: 5));
						right: ((SBDummyNode key: 2) left: (SBDummyNode key: 8))))) showAsDomainBlock}]
		label: 'example'.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBEllipsisPattern bindingDict: {#identity -> #aa} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBEllipsisPattern bindingDict: {#identity -> #ac} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #ab} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | false].
			SBBindingPattern
				bindingDict: {#identity -> #a}
				children: {}
				visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBEllipsisPattern bindingDict: {#identity -> #aa} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBEllipsisPattern bindingDict: {#identity -> #ac} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #ab} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBDummyNode >> exampleMultipleTransformations: aTree [

	| maxHeap |
	self
		example: [SBDummyNode new]
		args: [
			{
				((SBDummyNode key: 9) left: ((SBDummyNode key: 10)
					left: ((SBDummyNode key: 3)
						left: ((SBDummyNode key: 1)
							left: (SBDummyNode key: 0);
							right: (SBDummyNode key: 1));
						right: ((SBDummyNode key: 2) left: (SBDummyNode key: 5)));
					right: ((SBDummyNode key: 7)
						left: ((SBDummyNode key: 5)
							left: (SBDummyNode key: 5);
							right: (SBDummyNode key: 5));
						right: ((SBDummyNode key: 2) left: (SBDummyNode key: 8))))) showAsDomainBlock}]
		label: 'example'.
	maxHeap := self exampleHeapTransformation replaceAllMatches: aTree.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #a) key > (bindings at: #boi) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: maxHeap
]

{ #category : #'as yet unclassified' }
SBDummyNode >> exampleTransformWithMessage: aTree [

	self
		example: [SBDummyNode new]
		args: [
			{
				((SBDummyNode key: 9) left: ((SBDummyNode key: 10)
					left: ((SBDummyNode key: 3)
						left: ((SBDummyNode key: 1)
							left: (SBDummyNode key: 0);
							right: (SBDummyNode key: 1));
						right: ((SBDummyNode key: 2) left: (SBDummyNode key: 5)));
					right: ((SBDummyNode key: 7)
						left: ((SBDummyNode key: 5)
							left: (SBDummyNode key: 5);
							right: (SBDummyNode key: 5));
						right: ((SBDummyNode key: 2) left: (SBDummyNode key: 8))))) showAsDomainBlock}]
		label: 'example'.
	^ self exampleHeapTransformation replaceAllMatches: aTree
]

{ #category : #accessing }
SBDummyNode >> key [

	^ key
]

{ #category : #accessing }
SBDummyNode >> key: aValue [

	key := aValue
]

{ #category : #accessing }
SBDummyNode >> left [

	^ left
]

{ #category : #accessing }
SBDummyNode >> left: aNode [

	left := aNode
]

{ #category : #accessing }
SBDummyNode >> parent [

	^ parent
]

{ #category : #accessing }
SBDummyNode >> parent: aNode [

	parent := aNode
]

{ #category : #accessing }
SBDummyNode >> right [

	^ right
]

{ #category : #accessing }
SBDummyNode >> right: aNode [

	right := aNode
]

{ #category : #accessing }
SBDummyNode >> writeSourceOn: aStream [

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
