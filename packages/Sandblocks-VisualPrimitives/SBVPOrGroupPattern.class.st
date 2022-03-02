"
An SBVPOrGroupPattern is xxxxxxxxx.

"
Class {
	#name : #SBVPOrGroupPattern,
	#superclass : #SBVPGroupPattern,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #examples }
SBVPOrGroupPattern class >> example: aDummyNode [

	self
		example: [SBVPOrGroupPattern]
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
		input: (SBVPOrGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> ['10']}
				children: {SBVPEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode.
			SBVPGroupPattern patterns: {
				SBVPBindingPattern
					bindingDict: {#innerLabel -> #k. #identity -> #a}
					children: {SBVPEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBVPDummyNode}
					visualizingClass: SBVPDummyNode.
				SBVPConstraintPattern constraint: [:bindings | (bindings at: #k) = 3]}})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#innerLabel -> ['42']}
				children: {SBVPEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBVPDummyNode}
				visualizingClass: SBVPDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPDummyNode) replaceAllMatches: aDummyNode
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> getNext: aVisualPrimitive [

	| gotNext |
	gotNext := false.
	self children do: [:pattern | (pattern getNext: aVisualPrimitive) ifTrue: [gotNext := true]].
	^ gotNext
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ boundPattern matches: aVisualPrimitive withBinding: aCollection
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> seperatorString [

	^ ' or '
]

{ #category : #'as yet unclassified' }
SBVPOrGroupPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	| originalCollection |
	originalCollection := aCollection copy.
	^ self children
		detect: [:pattern |
			aCollection removeAll.
			aCollection addAll: originalCollection.
			pattern setBindingFor: aVisualPrimitive in: aCollection]
		ifFound: [:pattern |
			boundPattern := pattern.
			true]
		ifNone: [false]
]
