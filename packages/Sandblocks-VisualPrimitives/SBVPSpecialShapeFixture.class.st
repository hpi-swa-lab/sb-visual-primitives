Class {
	#name : #SBVPSpecialShapeFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPSpecialShapeFixture class >> exampleBuildHeapSpecialShape: aTree [

	self
		example: [SBVPSpecialShapeFixture]
		args: [
			{
				((SBVPSpecialShapeFixture key: 9) left: ((SBVPSpecialShapeFixture key: 10)
					left: ((SBVPSpecialShapeFixture key: 3)
						left: ((SBVPSpecialShapeFixture key: 1)
							left: (SBVPSpecialShapeFixture key: 0);
							right: (SBVPSpecialShapeFixture key: 1));
						right: ((SBVPSpecialShapeFixture key: 2) left: (SBVPSpecialShapeFixture key: 5)));
					right: ((SBVPSpecialShapeFixture key: 7)
						left: ((SBVPSpecialShapeFixture key: 5)
							left: (SBVPSpecialShapeFixture key: 5);
							right: (SBVPSpecialShapeFixture key: 5));
						right: ((SBVPSpecialShapeFixture key: 2) left: (SBVPSpecialShapeFixture key: 8))))) showAsVisualPrimitive}]
		label: 'example'.
	^ (SBVPTransformation
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #a}
				children: {
					SBVPEllipsisPattern
						bindingDict: {#identity -> #b}
						visualizingClass: SBVPSpecialShapeFixture.
					SBVPBindingPattern
						bindingDict: {#identity -> #boi}
						children: {
							SBVPEllipsisPattern
								bindingDict: {#identity -> #e}
								visualizingClass: SBVPSpecialShapeFixture}
						visualizingClass: SBVPSpecialShapeFixture.
					SBVPEllipsisPattern
						bindingDict: {#identity -> #d}
						visualizingClass: SBVPSpecialShapeFixture}
				visualizingClass: SBVPSpecialShapeFixture.
			SBVPConstraintPattern constraint: [:bindings | (bindings at: #a) key < (bindings at: #boi) key]})
		output: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				bindingDict: {#identity -> #boi}
				children: {
					SBVPEllipsisPattern
						bindingDict: {#identity -> #b}
						visualizingClass: SBVPSpecialShapeFixture.
					SBVPBindingPattern
						bindingDict: {#identity -> #a}
						children: {
							SBVPEllipsisPattern
								bindingDict: {#identity -> #e}
								visualizingClass: SBVPSpecialShapeFixture}
						visualizingClass: SBVPSpecialShapeFixture.
					SBVPEllipsisPattern
						bindingDict: {#identity -> #d}
						visualizingClass: SBVPSpecialShapeFixture}
				visualizingClass: SBVPSpecialShapeFixture})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> false;
			yourself)
		visualizePatternsAs: SBVPSpecialShapeFixture) replaceAllMatches: aTree
]

{ #category : #'as yet unclassified' }
SBVPSpecialShapeFixture class >> visualPrimitiveMapping [

	^ {
		SBVPPropertyMapping
			getter: [:object |
				CircleMorph new
					color: (Color r: 0.5 g: 0.5 b: (object key ifNotNil: [:key | key asInteger / 255] ifNil: [0]));
					yourself]
			setter: [:object :vp | object key: ((vp propertyAt: #shape) color blue * 255) rounded]
			patternValue: (CircleMorph new color: (Color r: 0.5 g: 0.5 b: 0.1))
			vpProperty: #shape
			name: 'shape'.
		SBVPPropertyMappingNumber property: #key vpProperty: #innerLabel.
		self childrenMappingEntry}
]
