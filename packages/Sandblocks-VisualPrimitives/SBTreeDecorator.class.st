"
Algorithm modified from https://llimllib.github.io/pymag-trees/
"
Class {
	#name : #SBTreeDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'children',
		'depth',
		'mod',
		'parent',
		'x',
		'ancestor',
		'shift',
		'change',
		'connectorToParent',
		'thread'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBTreeDecorator class >> createExampleIn: aContainer [

	| child1 child2 root child3 |
	root := SBTreeDecorator new.
	aContainer addMorph: (SBStPlayground new
		attachDecorator: root;
		detachDecorators: SBForceMoveDecorator).
	child1 := root addExampleChildIn: aContainer.
	child2 := root addExampleChildIn: aContainer.
	child3 := root addExampleChildIn: aContainer.
	child1
		addExampleChildIn: aContainer;
		addExampleChildIn: aContainer.
	child3
		addExampleChildIn: aContainer;
		addExampleChildIn: aContainer.
	root layout
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> addChild: aDecorator [

	self addChild: aDecorator afterIndex: self children size
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> addChild: aDecorator afterIndex: anIndex [

	| newConnector |
	self children add: aDecorator afterIndex: anIndex.
	aDecorator parent: self.
	
	newConnector := (SBConnectorLine connect: self morph to: aDecorator morph)
		connectorType: #line;
		lineWidth: 1;
		color: Color black.
	
	(self morph containingFloat owner ifNil: [self morph containingFloat]) addMorphBack: newConnector.
	aDecorator connectorToParent: newConnector
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> addExampleChildIn: aContainer [

	| child |
	child := SBTreeDecorator new.
	aContainer addMorph: (SBStPlayground new
		attachDecorator: child;
		detachDecorators: SBForceMoveDecorator;
		attachDecorator: SBMoveDecorator new).
	self addChild: child.
	^ child
]

{ #category : #accessing }
SBTreeDecorator >> ancestor [

	^ ancestor
]

{ #category : #accessing }
SBTreeDecorator >> ancestor: anObject [

	ancestor := anObject
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> apportion: aDefaultAncestor [

	| left shift sil sir sol sor vil vir vol vor newDefaultAncestor |
	newDefaultAncestor := aDefaultAncestor.
	left := self leftSibling.
	left ifNotNil: [
		vir := self.
		vor := self.
		vil := left.
		vol := self leftMostSibling.
		sir := self mod.
		sor := self mod.
		sil := vil mod.
		sol := vol mod.
		[vil nextRight notNil and: vir nextLeft notNil] whileTrue: [
			vil := vil nextRight.
			vir := vir nextLeft.
			vol := vol nextLeft.
			vor := vor nextRight.
			vor ancestor: self.
			shift := vil x + sil - (vir x + sir) + self distance.
			
			shift > 0 ifTrue: [ | a |
				a := (self parent children includes: vil ancestor)
					ifTrue: [vil ancestor]
					ifFalse: [newDefaultAncestor].
				a moveSubtree: self by: shift.
				sir := sir + shift.
				sor := sor + shift].
			sil := sil + vil mod.
			sir := sir + vir mod.
			sol := sol + vol mod.
			sor := sor + vor mod].
		(vil nextRight notNil and: vor nextRight isNil)
			ifTrue: [
				vor thread: vil nextRight.
				vor mod: vor mod + sil - sor]
			ifFalse: [
				(vir nextLeft notNil and: vol nextLeft isNil) ifTrue: [
					vol thread: vir nextLeft.
					vol mod: vol mod + sir - sol].
				newDefaultAncestor := self]].
	^ newDefaultAncestor
]

{ #category : #accessing }
SBTreeDecorator >> change [

	^ change
]

{ #category : #accessing }
SBTreeDecorator >> change: anObject [

	change := anObject
]

{ #category : #accessing }
SBTreeDecorator >> children [

	^ children
]

{ #category : #accessing }
SBTreeDecorator >> children: anObject [

	children := anObject
]

{ #category : #accessing }
SBTreeDecorator >> connectorToParent [

	^ connectorToParent
]

{ #category : #accessing }
SBTreeDecorator >> connectorToParent: aMorph [

	connectorToParent := aMorph
]

{ #category : #accessing }
SBTreeDecorator >> depth [

	^ depth
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> depth: aValue [

	depth := aValue
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> distance [

	^ self morph fullBounds width + 10
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> example [

	SBMorphExample
		setUp: [SBBlock new]
		cases: {
			SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:container | SBTreeDecorator createExampleIn: container]}
		extent: 1000 @ 1000
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> executeShifts [

	| shift change |
	shift := 0.
	change := 0.
	self children reverseDo: [:child |
		child x: child x + shift.
		child mod: child mod + shift.
		change := change + child change.
		shift := shift + child shift + change]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> firstWalk [

	| left |
	left := self leftSibling.
	
	self children
		ifEmpty: [self x: self distance + (left ifNil: [0] ifNotNil: [left x])]
		ifNotEmpty: [ | defaultAncestor midpoint |
			defaultAncestor := self children first.
			self children do: [:child |
				child depth: self depth + 1.
				child firstWalk.
				defaultAncestor := child apportion: defaultAncestor].
			self executeShifts.
			midpoint := self children first x - self children first distance + self children last x / 2.
			left ifNil: [self x: midpoint + (self distance / 2)] ifNotNil: [
				self x: left x + self distance.
				self mod: self x - midpoint - (self distance / 2)]]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> initialize [

	super initialize.
	children := OrderedCollection new.
	parent := nil.
	self reset
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> layout [

	self parent ifNotNil: [:parent | parent layout] ifNil: [
		self
			resetAll;
			firstWalk;
			assert: self mod = 0;
			secondWalk: 0 layerHeights: self maximumHeight]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> leftMostSibling [

	^ self parent ifNotNil: [ | left |
		left := self parent children first.
		left = self ifFalse: [left]]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> leftSibling [

	^ self parent ifNotNil: [:parent | | index |
		index := parent children indexOf: self.
		index > 1 ifTrue: [parent children at: index - 1]]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> maximumHeight [

	| h |
	h := self morph fullBounds height.
	self children do: [:child | h := h max: child maximumHeight].
	^ h
]

{ #category : #accessing }
SBTreeDecorator >> mod [

	^ mod
]

{ #category : #accessing }
SBTreeDecorator >> mod: anObject [

	mod := anObject
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> moveSubtree: aNode by: aShiftValue [

	| numberOfSubtrees |
	numberOfSubtrees := aNode siblingIndex - self siblingIndex.
	aNode change: aNode change - aShiftValue / numberOfSubtrees.
	aNode shift: aNode shift + aShiftValue.
	aNode x: aNode x + aShiftValue.
	aNode mod: aNode mod + aShiftValue.
	self change: self change + aShiftValue / numberOfSubtrees
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> nextLeft [

	^ self children ifEmpty: [self thread] ifNotEmpty: [self children first]
]

{ #category : #nil }
SBTreeDecorator >> nextRight [

	^ self children ifEmpty: [self thread] ifNotEmpty: [self children last]
]

{ #category : #accessing }
SBTreeDecorator >> parent [

	^ parent
]

{ #category : #accessing }
SBTreeDecorator >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
SBTreeDecorator >> removeChild: aSandblock [

	aSandblock withDecorator: SBTreeDecorator do: [:childDecorator |
		self children remove: childDecorator.
		childDecorator connectorToParent abandon.
		childDecorator parent: nil]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> reset [

	depth := 1.
	mod := 0.
	shift := 0.
	change := 0.
	ancestor := self.
	thread := nil.
	x := -1000
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> resetAll [

	self reset.
	self children do: [:child | child reset]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> secondWalk: aValue layerHeights: height [

	self x: self x + aValue.
	self morph
		fullBounds;
		center: self x - (self distance / 2) @ (height * self depth).
	self children do: [:child | child secondWalk: aValue + self mod layerHeights: height]
]

{ #category : #accessing }
SBTreeDecorator >> shift [

	^ shift
]

{ #category : #accessing }
SBTreeDecorator >> shift: anObject [

	shift := anObject
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> siblingIndex [

	^ self parent ifNotNil: [self parent children indexOf: self] ifNil: [1]
]

{ #category : #accessing }
SBTreeDecorator >> thread [

	^ thread
]

{ #category : #accessing }
SBTreeDecorator >> thread: anObject [

	thread := anObject
]

{ #category : #accessing }
SBTreeDecorator >> x [

	^ x
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> x: aValue [

	x := aValue
]
