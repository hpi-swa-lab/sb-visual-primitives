Class {
	#name : #SBSpecialShapeFixture,
	#superclass : #SBDummyNode,
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBSpecialShapeFixture class >> domainBlockMapping [

	^ {
		SBPropertyMapping
			getter: [:object |
				CircleMorph new
					color: (Color r: 0.5 g: 0.5 b: (object key ifNotNil: [:key | key asInteger / 255] ifNil: [0]));
					yourself]
			setter: [:object :vp | object key: ((vp propertyAt: #shape) color blue * 255) rounded]
			patternValue: (CircleMorph new color: (Color r: 0.5 g: 0.5 b: 0.1))
			vpProperty: #shape
			name: 'shape'.
		SBPropertyMappingNumber property: #key vpProperty: #innerLabel.
		self childrenMappingEntry}
]

{ #category : #'as yet unclassified' }
SBSpecialShapeFixture class >> exampleBuildHeapSpecialShape: aTree [

	self
		example: [SBSpecialShapeFixture]
		args: [
			{
				((SBSpecialShapeFixture key: 9) left: ((SBSpecialShapeFixture key: 10)
					left: ((SBSpecialShapeFixture key: 3)
						left: ((SBSpecialShapeFixture key: 1)
							left: (SBSpecialShapeFixture key: 0);
							right: (SBSpecialShapeFixture key: 1));
						right: ((SBSpecialShapeFixture key: 2) left: (SBSpecialShapeFixture key: 5)));
					right: ((SBSpecialShapeFixture key: 7)
						left: ((SBSpecialShapeFixture key: 5)
							left: (SBSpecialShapeFixture key: 5);
							right: (SBSpecialShapeFixture key: 5));
						right: ((SBSpecialShapeFixture key: 2) left: (SBSpecialShapeFixture key: 8))))) showAsDomainBlock}]
		label: 'example'.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBEllipsisPattern
						bindingDict: {#identity -> #b}
						visualizingClass: SBSpecialShapeFixture.
					SBBindingPattern
						bindingDict: {#identity -> #boi}
						children: {
							SBEllipsisPattern
								bindingDict: {#identity -> #e}
								visualizingClass: SBSpecialShapeFixture}
						visualizingClass: SBSpecialShapeFixture.
					SBEllipsisPattern
						bindingDict: {#identity -> #d}
						visualizingClass: SBSpecialShapeFixture}
				visualizingClass: SBSpecialShapeFixture.
			SBConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #boi) key]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBEllipsisPattern
						bindingDict: {#identity -> #b}
						visualizingClass: SBSpecialShapeFixture.
					SBBindingPattern
						bindingDict: {#identity -> #a}
						children: {
							SBEllipsisPattern
								bindingDict: {#identity -> #e}
								visualizingClass: SBSpecialShapeFixture}
						visualizingClass: SBSpecialShapeFixture.
					SBEllipsisPattern
						bindingDict: {#identity -> #d}
						visualizingClass: SBSpecialShapeFixture}
				visualizingClass: SBSpecialShapeFixture})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBSpecialShapeFixture
		replaceCount: Float infinity) value: aTree
]
