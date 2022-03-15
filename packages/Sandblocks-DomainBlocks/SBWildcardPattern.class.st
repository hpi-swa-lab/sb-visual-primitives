"
An SBWildcardPattern used to represent a non-empty subtree. Its children can be below any node in that subtree. To that end, it searches the subtree via a depth-first search.


Instance Variables
	searchStack:		LinkedList
	visited:				Set

searchStack
	- the current stack of the depth-first search

visited
	- the domain blocks that have already been found by the depth-first search

"
Class {
	#name : #SBWildcardPattern,
	#superclass : #SBBindingPattern,
	#instVars : [
		'searchStack',
		'visited'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #accessing }
SBWildcardPattern >> bindingFor: aDomainBlock [

	^ {#root -> self searchStack last. #leaf -> self currentTop} asDictionary
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> buildFromBinding: anArray [

	| binding |
	binding := anArray at: self bindingName.
	^ {self buildFromBinding: anArray currentPrimitive: (binding at: #root)}
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> buildFromBinding: anArray currentPrimitive: aDomainBlock [

	| output binding leaf |
	binding := anArray at: self bindingName.
	leaf := binding at: #leaf.
	
	output := aDomainBlock copy.
	aDomainBlock = leaf
		ifTrue: [output patternChildren: (self buildChildrenFromBinding: anArray)]
		ifFalse: [output patternChildren: (aDomainBlock patternChildren collect: [:primitive | self buildFromBinding: anArray currentPrimitive: primitive])].
	^ output
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> convertToBindingPattern [
	<action>

	self convertToPatternClass: SBBindingPattern
]

{ #category : #'as yet unclassified' }
SBWildcardPattern >> convertToWildcardPattern [

	
]

{ #category : #accessing }
SBWildcardPattern >> currentTop [

	^ self searchStack first
]

{ #category : #'as yet unclassified' }
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
				patternChildren: {
					SBWildcardPattern
						bindingDict: {#identity -> #pathToLeaf}
						patternChildren: {SBBindingPattern bindingDict: {#identity -> #leaf} visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {SBBindingPattern bindingDict: {#identity -> #leaf} visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aTree
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
				patternChildren: {
					SBWildcardPattern
						bindingDict: {#identity -> #pathToNode}
						patternChildren: {
							SBBindingPattern
								bindingDict: {#identity -> #node}
								patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #children} visualizingClass: SBDummyNode}
								visualizingClass: SBDummyNode}
						visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #children) size = 2]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #node}
				patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #children} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aTree
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
		self currentTop patternChildren do: [:child |
			(self visited includes: child) ifFalse: [
				self pushToStack: child.
				self resetChildren.
				^ true]].
		self searchStack removeFirst].
	^ false
]

{ #category : #initialization }
SBWildcardPattern >> initialize [

	super initialize.
	self
		searchStack: LinkedList new;
		visited: Set new.
	self firstSubmorph addMorph: (SBIcon iconAsterisk scale: 1.5)
]

{ #category : #accessing }
SBWildcardPattern >> pushToStack: aDomainBlock [

	self searchStack addFirst: aDomainBlock.
	self visited add: aDomainBlock
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
SBWildcardPattern >> visited [

	^ visited
]

{ #category : #accessing }
SBWildcardPattern >> visited: aSet [

	visited := aSet
]
