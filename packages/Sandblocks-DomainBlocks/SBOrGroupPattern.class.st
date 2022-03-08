"
An SBOrGroupPattern is xxxxxxxxx.

"
Class {
	#name : #SBOrGroupPattern,
	#superclass : #SBGroupPattern,
	#instVars : [
		'matchingPattern'
	],
	#category : #'Sandblocks-DomainBlocks'
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
				expressionDict: {#innerLabel -> ['10']}
				children: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode.
			SBGroupPattern patterns: {
				SBBindingPattern
					bindingDict: {#innerLabel -> #k. #identity -> #a}
					children: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
					visualizingClass: SBDummyNode.
				SBConstraintPattern constraint: [:bindings | (bindings at: #k) = 3]}})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> ['42']}
				children: {SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBDummyNode}
				visualizingClass: SBDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBDummyNode) replaceAllMatches: aDummyNode
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> getNext: aDomainBlock [

	| gotNext |
	gotNext := false.
	self children do: [:pattern | (pattern getNext: aDomainBlock) ifTrue: [gotNext := true]].
	^ gotNext
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> matches: aDomainBlock withBinding: aCollection [

	^ self matchingPattern matches: aDomainBlock withBinding: aCollection
]

{ #category : #accessing }
SBOrGroupPattern >> matchingPattern [

	^ matchingPattern
]

{ #category : #accessing }
SBOrGroupPattern >> matchingPattern: anObject [

	matchingPattern := anObject.
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> separatorString [

	^ ' or '
]

{ #category : #'as yet unclassified' }
SBOrGroupPattern >> setBindingFor: aDomainBlock in: aCollection [

	| originalCollection |
	originalCollection := aCollection copy.
	^ self children
		detect: [:pattern |
			aCollection removeAll.
			aCollection addAll: originalCollection.
			pattern setBindingFor: aDomainBlock in: aCollection]
		ifFound: [:pattern |
			self matchingPattern: pattern.
			true]
		ifNone: [false]
]
