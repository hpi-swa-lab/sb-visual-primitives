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
SBVPDummyNode class >> childrenMappingEntry [

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
SBVPDummyNode >> children: aCollection [

	self left: (aCollection size >= 1 ifTrue: [aCollection first]).
	self right: (aCollection size >= 2 ifTrue: [aCollection second])
]

{ #category : #'as yet unclassified' }
SBVPDummyNode >> exampleHeapTransformation [

	^ SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBVPEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBVPEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode
]

{ #category : #'as yet unclassified' }
SBVPDummyNode >> exampleMultipleBindings: aTree [

	self
		example: [SBVPDummyNode new]
		args: [
			{
				((SBVPDummyNode key: 9) left: ((SBVPDummyNode key: 10)
					left: ((SBVPDummyNode key: 3)
						left: ((SBVPDummyNode key: 1)
							left: (SBVPDummyNode key: 0);
							right: (SBVPDummyNode key: 1));
						right: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 5)));
					right: ((SBVPDummyNode key: 7)
						left: ((SBVPDummyNode key: 5)
							left: (SBVPDummyNode key: 5);
							right: (SBVPDummyNode key: 5));
						right: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 8))))) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBVPEllipsisPattern bindingDict: {#identity -> #aa} visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #ac} visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern bindingDict: {#identity -> #ab} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode.
			SBVPConstraintPattern constraint: [:bindings | false].
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {}
				visualizingClass: SBVPDummyNode})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBVPEllipsisPattern bindingDict: {#identity -> #aa} visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #ac} visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern bindingDict: {#identity -> #ab} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPDummyNode >> exampleMultipleTransformations: aTree [

	| maxHeap |
	self
		example: [SBVPDummyNode new]
		args: [
			{
				((SBVPDummyNode key: 9) left: ((SBVPDummyNode key: 10)
					left: ((SBVPDummyNode key: 3)
						left: ((SBVPDummyNode key: 1)
							left: (SBVPDummyNode key: 0);
							right: (SBVPDummyNode key: 1));
						right: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 5)));
					right: ((SBVPDummyNode key: 7)
						left: ((SBVPDummyNode key: 5)
							left: (SBVPDummyNode key: 5);
							right: (SBVPDummyNode key: 5));
						right: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 8))))) showAsVisualPrimitive}]
		label: 'example'.
	maxHeap := self exampleHeapTransformation replaceAllMatches: aTree.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBVPEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #boi}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key > (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBVPEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBVPDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #a}
						children: {SBVPEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBVPDummyNode}
						visualizingClass: SBVPDummyNode.
					SBVPEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: maxHeap
]

{ #category : #'as yet unclassified' }
SBVPDummyNode >> exampleTransformWithMessage: aTree [

	self
		example: [SBVPDummyNode new]
		args: [
			{
				((SBVPDummyNode key: 9) left: ((SBVPDummyNode key: 10)
					left: ((SBVPDummyNode key: 3)
						left: ((SBVPDummyNode key: 1)
							left: (SBVPDummyNode key: 0);
							right: (SBVPDummyNode key: 1));
						right: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 5)));
					right: ((SBVPDummyNode key: 7)
						left: ((SBVPDummyNode key: 5)
							left: (SBVPDummyNode key: 5);
							right: (SBVPDummyNode key: 5));
						right: ((SBVPDummyNode key: 2) left: (SBVPDummyNode key: 8))))) showAsVisualPrimitive}]
		label: 'example'.
	^ self exampleHeapTransformation replaceAllMatches: aTree
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
