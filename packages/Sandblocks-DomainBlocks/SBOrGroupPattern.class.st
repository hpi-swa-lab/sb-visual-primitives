"
An SBOrGroupPattern is an SBGroupPattern with the separator 'or'.

Instance Variables
	matchingPattern:	Object

matchingPattern
	- represents the current matching pattern

"
Class {
	#name : #SBOrGroupPattern,
	#superclass : #SBGroupPattern,
	#instVars : [
		'matchingPattern'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #examples }
SBOrGroupPattern class >> example: aDummyNode [

	self
		example: [SBOrGroupPattern]
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
		input: (SBOrGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> [10]}
				patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> [3]}
				patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> [42]}
				patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aDummyNode
]

{ #category : #examples }
SBOrGroupPattern class >> exampleNested: aDummyNode [

	self
		example: [SBOrGroupPattern]
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
		input: (SBOrGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> [10]}
				patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBGroupPattern patterns: {
				SBBindingPattern
					bindingDict: {#innerLabel -> #k. #identity -> #a}
					patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
					visualizingClass: SBDummyNode.
				SBConstraintPattern constraint: [:bindings | (bindings at: #k) = 3]}})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> [42]}
				patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode
		replaceCount: Float infinity) value: aDummyNode
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> getNext: aDomainBlock [

	self patternChildren do: [:pattern | (pattern getNext: aDomainBlock) ifTrue: [^ true]].
	self matchingPattern patternSiblingIndex = self patternChildren size ifTrue: [^ false].
	self matchingPattern: (self patternChildren at: self matchingPattern patternSiblingIndex + 1).
	^ true
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> matches: aDomainBlock withBinding: aCollection [

	^ self matchingPattern matches: aDomainBlock withBinding: aCollection
]

{ #category : #accessing }
SBOrGroupPattern >> matchingPattern [

	^ matchingPattern ifNil: [self patternChildren first]
]

{ #category : #accessing }
SBOrGroupPattern >> matchingPattern: aPattern [

	matchingPattern := aPattern
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> reset [

	self matchingPattern: nil
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> separatorString [

	^ ' or '
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> setBindingFor: aDomainBlock in: aCollection [

	^ self matchingPattern setBindingFor: aDomainBlock in: aCollection
]
