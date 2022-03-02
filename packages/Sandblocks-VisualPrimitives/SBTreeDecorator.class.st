"
An SBTreeDecorator allows to layout a group of decorated SBBlocks to be arranged in a tree like manner.

Algorithm modified from https://llimllib.github.io/pymag-trees/
"
Class {
	#name : #SBTreeDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'ancestor',
		'change',
		'children',
		'connectorToParent',
		'depth',
		'mod',
		'parent',
		'shift',
		'thread',
		'x'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #examples }
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

{ #category : #examples }
SBTreeDecorator class >> example [

	SBMorphExample
		setUp: [SBBlock new]
		cases: {
			SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:container | SBTreeDecorator createExampleIn: container]}
		extent: 1000 @ 1000
]

{ #category : #children }
SBTreeDecorator >> addChild: anSBTreeDecorator [

	self addChild: anSBTreeDecorator afterIndex: self children size
]

{ #category : #children }
SBTreeDecorator >> addChild: anSBTreeDecorator afterIndex: anIndex [

	| newConnector |
	self children add: anSBTreeDecorator afterIndex: anIndex.
	anSBTreeDecorator parent: self.
	
	newConnector := (SBConnectorLine connect: self morph to: anSBTreeDecorator morph)
		connectorType: #line;
		lineWidth: 1;
		color: Color black.
	
	anSBTreeDecorator connectorToParent: newConnector
]

{ #category : #children }
SBTreeDecorator >> addConnectorLineToWorld [

	self connectorToParent ifNotNil: [:connector |
		connector owner ifNotNil: [:owner | owner removeMorph: connector].
		(self morph containingFloat owner ifNil: [self morph containingFloat]) addMorphBack: self connectorToParent]
]

{ #category : #children }
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
SBTreeDecorator >> ancestor: anSBTreeDecorator [

	ancestor := anSBTreeDecorator
]

{ #category : #layouting }
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
SBTreeDecorator >> change: aNumber [

	change := aNumber
]

{ #category : #accessing }
SBTreeDecorator >> children [

	^ children
]

{ #category : #accessing }
SBTreeDecorator >> children: anOrderedCollection [

	children := anOrderedCollection
]

{ #category : #accessing }
SBTreeDecorator >> connectorToParent [

	^ connectorToParent
]

{ #category : #accessing }
SBTreeDecorator >> connectorToParent: aMorph [

	connectorToParent := aMorph.
	self addConnectorLineToWorld
]

{ #category : #accessing }
SBTreeDecorator >> depth [

	^ depth
]

{ #category : #accessing }
SBTreeDecorator >> depth: aNumber [

	depth := aNumber
]

{ #category : #layouting }
SBTreeDecorator >> distance [

	^ self morph fullBounds width + 10
]

{ #category : #layouting }
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

{ #category : #layouting }
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

{ #category : #'initialize-release' }
SBTreeDecorator >> initialize [

	super initialize.
	children := OrderedCollection new.
	parent := nil.
	self reset
]

{ #category : #layouting }
SBTreeDecorator >> layout [

	self parent ifNotNil: [:parent | parent layout] ifNil: [
		self
			resetAll;
			firstWalk;
			assert: self mod = 0;
			secondWalk: 0 layerHeights: self maximumHeight]
]

{ #category : #layouting }
SBTreeDecorator >> leftMostSibling [

	^ self parent ifNotNil: [ | left |
		left := self parent children first.
		left = self ifFalse: [left]]
]

{ #category : #children }
SBTreeDecorator >> leftSibling [

	^ self parent ifNotNil: [:parent | | index |
		index := parent children indexOf: self.
		index > 1 ifTrue: [parent children at: index - 1]]
]

{ #category : #layouting }
SBTreeDecorator >> maximumHeight [

	| height |
	height := self morph fullBounds height.
	self children do: [:child | height := height max: child maximumHeight].
	^ height
]

{ #category : #accessing }
SBTreeDecorator >> mod [

	^ mod
]

{ #category : #accessing }
SBTreeDecorator >> mod: aNumber [

	mod := aNumber
]

{ #category : #layouting }
SBTreeDecorator >> moveSubtree: aNode by: aShiftValue [

	| numberOfSubtrees |
	numberOfSubtrees := aNode siblingIndex - self siblingIndex.
	aNode change: aNode change - aShiftValue / numberOfSubtrees.
	aNode shift: aNode shift + aShiftValue.
	aNode x: aNode x + aShiftValue.
	aNode mod: aNode mod + aShiftValue.
	self change: self change + aShiftValue / numberOfSubtrees
]

{ #category : #layouting }
SBTreeDecorator >> nextLeft [

	^ self children ifEmpty: [self thread] ifNotEmpty: [self children first]
]

{ #category : #layouting }
SBTreeDecorator >> nextRight [

	^ self children ifEmpty: [self thread] ifNotEmpty: [self children last]
]

{ #category : #accessing }
SBTreeDecorator >> parent [

	^ parent
]

{ #category : #accessing }
SBTreeDecorator >> parent: anSBTreeDecorator [

	parent := anSBTreeDecorator
]

{ #category : #accessing }
SBTreeDecorator >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ' for '.
	self morph printOn: aStream
]

{ #category : #children }
SBTreeDecorator >> removeChild: aSandblock [

	aSandblock withDecorator: SBTreeDecorator do: [:childDecorator |
		self children remove: childDecorator.
		childDecorator connectorToParent abandon.
		childDecorator connectorToParent: nil.
		childDecorator parent: nil]
]

{ #category : #'initialize-release' }
SBTreeDecorator >> reset [

	depth := 1.
	mod := 0.
	shift := 0.
	change := 0.
	ancestor := self.
	thread := nil.
	x := -1000
]

{ #category : #'initialize-release' }
SBTreeDecorator >> resetAll [

	self reset.
	self children do: [:child | child resetAll]
]

{ #category : #layouting }
SBTreeDecorator >> secondWalk: aValue layerHeights: height [

	self x: self x + aValue.
	self morph
		fullBounds;
		center: self x - (self distance / 2) @ (height * self depth).
	self addConnectorLineToWorld.
	self children do: [:child | child secondWalk: aValue + self mod layerHeights: height]
]

{ #category : #accessing }
SBTreeDecorator >> shift [

	^ shift
]

{ #category : #accessing }
SBTreeDecorator >> shift: aNumber [

	shift := aNumber
]

{ #category : #children }
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

{ #category : #accessing }
SBTreeDecorator >> x: aNumber [

	x := aNumber
]
