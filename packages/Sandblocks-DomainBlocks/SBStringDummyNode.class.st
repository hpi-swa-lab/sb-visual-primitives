Class {
	#name : #SBStringDummyNode,
	#superclass : #SBDummyNode,
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBStringDummyNode class >> domainBlockMapping [

	^ {#innerLabel dbStringFor: #key. self childrenMappingEntry}
]

{ #category : #'as yet unclassified' }
SBStringDummyNode class >> exampleBuildHeapStrings: aTree [

	self
		example: [SBStringDummyNode]
		args: [
			{
				((SBStringDummyNode key: 'a') left: ((SBStringDummyNode key: 'b')
					left: ((SBStringDummyNode key: 'cre')
						left: ((SBStringDummyNode key: 'dko')
							left: (SBStringDummyNode key: 'e');
							right: (SBStringDummyNode key: 'f'));
						right: ((SBStringDummyNode key: 'ghui') left: (SBStringDummyNode key: 'h')));
					right: ((SBStringDummyNode key: 'alk')
						left: ((SBStringDummyNode key: 'i')
							left: (SBStringDummyNode key: 'j');
							right: (SBStringDummyNode key: 'k'));
						right: ((SBStringDummyNode key: 'l') left: (SBStringDummyNode key: 'm'))))) showAsDomainBlock}]
		label: 'example'.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				patternChildren: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBStringDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #toSort}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBStringDummyNode}
						visualizingClass: SBStringDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBStringDummyNode}
				visualizingClass: SBStringDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #toSort) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #toSort}
				patternChildren: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBStringDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #a}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBStringDummyNode}
						visualizingClass: SBStringDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBStringDummyNode}
				visualizingClass: SBStringDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBStringDummyNode
		replaceCount: Float infinity) value: aTree
]

{ #category : #'as yet unclassified' }
SBStringDummyNode >> exampleBuildHeapStrings: aTree [

	self
		example: [SBStringDummyNode]
		args: [
			{
				((SBStringDummyNode key: 'a') left: ((SBStringDummyNode key: 'b')
					left: ((SBStringDummyNode key: 'cre')
						left: ((SBStringDummyNode key: 'dko')
							left: (SBStringDummyNode key: 'e');
							right: (SBStringDummyNode key: 'f'));
						right: ((SBStringDummyNode key: 'ghui') left: (SBStringDummyNode key: 'h')));
					right: ((SBStringDummyNode key: 'alk')
						left: ((SBStringDummyNode key: 'i')
							left: (SBStringDummyNode key: 'j');
							right: (SBStringDummyNode key: 'k'));
						right: ((SBStringDummyNode key: 'l') left: (SBStringDummyNode key: 'm'))))) showAsDomainBlock}]
		label: 'example'.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				patternChildren: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBStringDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #toSort}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBStringDummyNode}
						visualizingClass: SBStringDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBStringDummyNode}
				visualizingClass: SBStringDummyNode.
			SBConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #toSort) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #toSort}
				patternChildren: {
					SBEllipsisPattern bindingDict: {#identity -> #b} visualizingClass: SBStringDummyNode.
					SBBindingPattern
						bindingDict: {#identity -> #a}
						patternChildren: {SBEllipsisPattern bindingDict: {#identity -> #e} visualizingClass: SBStringDummyNode}
						visualizingClass: SBStringDummyNode.
					SBEllipsisPattern bindingDict: {#identity -> #d} visualizingClass: SBStringDummyNode}
				visualizingClass: SBStringDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBStringDummyNode
		replaceCount: Float infinity) value: aTree
]

{ #category : #'as yet unclassified' }
SBStringDummyNode >> key [

	^ key asString
]

{ #category : #'as yet unclassified' }
SBStringDummyNode >> key: aValue [

	key := aValue asString
]
