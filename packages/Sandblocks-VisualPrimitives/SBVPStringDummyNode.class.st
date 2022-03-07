Class {
	#name : #SBVPStringDummyNode,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPStringDummyNode class >> exampleBuildHeapStrings: aTree [

	self
		example: [SBVPStringDummyNode]
		args: [
			{
				((SBVPStringDummyNode key: 'a') left: ((SBVPStringDummyNode key: 'b')
					left: ((SBVPStringDummyNode key: 'cre')
						left: ((SBVPStringDummyNode key: 'dko')
							left: (SBVPStringDummyNode key: 'e');
							right: (SBVPStringDummyNode key: 'f'));
						right: ((SBVPStringDummyNode key: 'ghui') left: (SBVPStringDummyNode key: 'h')));
					right: ((SBVPStringDummyNode key: 'alk')
						left: ((SBVPStringDummyNode key: 'i')
							left: (SBVPStringDummyNode key: 'j');
							right: (SBVPStringDummyNode key: 'k'));
						right: ((SBVPStringDummyNode key: 'l') left: (SBVPStringDummyNode key: 'm'))))) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBVPEllipsisPattern
						bindingDict: {#identity -> #b}
						visualizingClass: SBVPStringDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #toSort}
						children: {
							SBVPEllipsisPattern
								bindingDict: {#identity -> #e}
								visualizingClass: SBVPStringDummyNode}
						visualizingClass: SBVPStringDummyNode.
					SBVPEllipsisPattern
						bindingDict: {#identity -> #d}
						visualizingClass: SBVPStringDummyNode}
				visualizingClass: SBVPStringDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #toSort) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #toSort}
				children: {
					SBVPEllipsisPattern
						bindingDict: {#identity -> #b}
						visualizingClass: SBVPStringDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #a}
						children: {
							SBVPEllipsisPattern
								bindingDict: {#identity -> #e}
								visualizingClass: SBVPStringDummyNode}
						visualizingClass: SBVPStringDummyNode.
					SBVPEllipsisPattern
						bindingDict: {#identity -> #d}
						visualizingClass: SBVPStringDummyNode}
				visualizingClass: SBVPStringDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPStringDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPStringDummyNode class >> visualPrimitiveMapping [

	^ {SBVPPropertyMappingString property: #key vpProperty: #innerLabel. self childrenMappingEntry}
]

{ #category : #'as yet unclassified' }
SBVPStringDummyNode >> exampleBuildHeapStrings: aTree [

	self
		example: [SBVPStringDummyNode]
		args: [
			{
				((SBVPStringDummyNode key: 'a') left: ((SBVPStringDummyNode key: 'b')
					left: ((SBVPStringDummyNode key: 'cre')
						left: ((SBVPStringDummyNode key: 'dko')
							left: (SBVPStringDummyNode key: 'e');
							right: (SBVPStringDummyNode key: 'f'));
						right: ((SBVPStringDummyNode key: 'ghui') left: (SBVPStringDummyNode key: 'h')));
					right: ((SBVPStringDummyNode key: 'alk')
						left: ((SBVPStringDummyNode key: 'i')
							left: (SBVPStringDummyNode key: 'j');
							right: (SBVPStringDummyNode key: 'k'));
						right: ((SBVPStringDummyNode key: 'l') left: (SBVPStringDummyNode key: 'm'))))) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBVPEllipsisPattern
						bindingDict: {#identity -> #b}
						visualizingClass: SBVPStringDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #toSort}
						children: {
							SBVPEllipsisPattern
								bindingDict: {#identity -> #e}
								visualizingClass: SBVPStringDummyNode}
						visualizingClass: SBVPStringDummyNode.
					SBVPEllipsisPattern
						bindingDict: {#identity -> #d}
						visualizingClass: SBVPStringDummyNode}
				visualizingClass: SBVPStringDummyNode.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key < toSort key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #toSort}
				children: {
					SBVPEllipsisPattern
						bindingDict: {#identity -> #b}
						visualizingClass: SBVPStringDummyNode.
					SBVPBindingPattern
						bindingDict: {#identity -> #a}
						children: {
							SBVPEllipsisPattern
								bindingDict: {#identity -> #e}
								visualizingClass: SBVPStringDummyNode}
						visualizingClass: SBVPStringDummyNode.
					SBVPEllipsisPattern
						bindingDict: {#identity -> #d}
						visualizingClass: SBVPStringDummyNode}
				visualizingClass: SBVPStringDummyNode})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBVPStringDummyNode) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPStringDummyNode >> key [

	^ key asString
]

{ #category : #'as yet unclassified' }
SBVPStringDummyNode >> key: aValue [

	key := aValue asString
]
