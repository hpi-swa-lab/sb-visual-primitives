"
An SBWildcardPattern is xxxxxxxxx.

Instance Variables
	searchStack:		LinkedList
	visitedPrimitives:	Set

searchStack
	- xxxxx

visitedPrimitives
	- xxxxx

"
Class {
	#name : #SBWildcardPattern,
	#superclass : #SBBindingPattern,
	#instVars : [
		'searchStack',
		'visitedPrimitives'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #accessing }
SBWildcardPattern >> bindingFor: aDomainBlock [

	^ {#root -> self searchStack last. #leaf -> self currentTop} asDictionary
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> buildFromBinding: anArray [

	| binding |
	binding := anArray at: self bindingIndex.
	^ {self buildFromBinding: anArray currentPrimitive: (binding at: #root)}
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> buildFromBinding: anArray currentPrimitive: aDomainBlock [

	| output binding leaf |
	binding := anArray at: self bindingIndex.
	leaf := binding at: #leaf.
	
	output := aDomainBlock copy.
	aDomainBlock = leaf
		ifTrue: [output children: (self buildChildrenFromBinding: anArray)]
		ifFalse: [output children: (aDomainBlock children collect: [:primitive | self buildFromBinding: anArray currentPrimitive: primitive])].
	^ output
]

{ #category : #accessing }
SBWildcardPattern >> currentTop [

	^ self searchStack first
]

{ #category : #accessing }
SBWildcardPattern >> exampleExtractLeaf: aTree [

	self
		example: [SBWildcardPattern new]
		args: [
			{
				((SBDummyNode key: 1) left: ((SBDummyNode key: 2) left: ((SBDummyNode key: 3) left: ((SBDummyNode key: 4) left: (SBDummyNode key: 5))))) showAsDomainBlock}]
		label: 'example'.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #root}
				children: {
					SBWildcardPattern
						bindingDict: {#identity -> #pathToLeaf}
						children: {SBBindingPattern bindingDict: {#identity -> #leaf} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {SBBindingPattern bindingDict: {#identity -> #leaf} visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> exampleExtractNodeWithTwoChildren: aTree [

	self
		example: [SBWildcardPattern new]
		args: [
			{
				((SBDummyNode key: 1) left: ((SBDummyNode key: 2) left: ((SBDummyNode key: 3) left: ((SBDummyNode key: 4)
					left: (SBDummyNode key: 5);
					right: (SBDummyNode key: 6))))) showAsDomainBlock}]
		label: 'example'.
	
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #root}
				children: {
					SBWildcardPattern
						bindingDict: {#identity -> #pathToNode}
						children: {
							SBBindingPattern
								bindingDict: {#identity -> #node}
								children: {SBEllipsisPattern bindingDict: {#identity -> #children} visualizingClass: SBDummyNode}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #children) size = 2]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #node}
				children: {SBEllipsisPattern bindingDict: {#identity -> #children} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> getCurrentPrimitive: aDomainBlock [

	^ self searchStack ifEmpty: [aDomainBlock] ifNotEmpty: [self currentTop]
]

{ #category : #accessing }
SBWildcardPattern >> getNext: aDomainBlock [

	(super getNext: aDomainBlock) ifTrue: [^ true].
	self searchStack isEmpty ifTrue: [
		self pushToStack: aDomainBlock.
		^ true].
	[self searchStack notEmpty] whileTrue: [
		self currentTop children do: [:child |
			(self visitedPrimitives includes: child) ifFalse: [
				self pushToStack: child.
				self resetChildren.
				^ true]].
		self searchStack removeFirst].
	^ false
]

{ #category : #accessing }
SBWildcardPattern >> initialize [

	super initialize.
	self
		searchStack: LinkedList new;
		visitedPrimitives: Set new.
	self firstSubmorph addMorph: (SBIcon iconAsterisk scale: 1.5)
]

{ #category : #accessing }
SBWildcardPattern >> pushToStack: aDomainBlock [

	self searchStack addFirst: aDomainBlock.
	self visitedPrimitives add: aDomainBlock
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> reset [

	super reset.
	self searchStack: LinkedList new
]

{ #category : #accessing }
SBWildcardPattern >> searchStack [

	^ searchStack
]

{ #category : #accessing }
SBWildcardPattern >> searchStack: aLinkedList [

	searchStack := aLinkedList
]

{ #category : #accessing }
SBWildcardPattern >> setBindingFor: aDomainBlock in: aCollection [

	self assert: (self searchStack isEmpty or: [self searchStack last = aDomainBlock]).
	
	self searchStack isEmpty ifTrue: [self pushToStack: aDomainBlock].
	^ super setBindingFor: self currentTop in: aCollection
]

{ #category : #accessing }
SBWildcardPattern >> visitedPrimitives [

	^ visitedPrimitives
]

{ #category : #accessing }
SBWildcardPattern >> visitedPrimitives: aSet [

	visitedPrimitives := aSet
]
