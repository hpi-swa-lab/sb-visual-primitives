"
An SBTreeDecorator allows to layout a group of decorated SBBlocks to be arranged in a tree like manner.

Algorithm modified from https://llimllib.github.io/pymag-trees/
"
Class {
	#name : #SBTreeLayoutPolicy,
	#superclass : #LayoutPolicy,
	#instVars : [
		'layoutData'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #accessing }
SBTreeLayoutPolicy >> ancestorOf: aPattern [

	^ (self layoutDataAt: aPattern) first
]

{ #category : #layouting }
SBTreeLayoutPolicy >> apportion: aPattern defaultAncestor: aDefaultAncestor [

	| left shift sil sir sol sor vil vir vol vor newDefaultAncestor |
	newDefaultAncestor := aDefaultAncestor.
	left := aPattern leftSibling.
	left ifNotNil: [
		vir := aPattern.
		vor := aPattern.
		vil := left.
		vol := self leftMostSibling: aPattern.
		sir := self modOf: aPattern.
		sor := self modOf: aPattern.
		sil := self modOf: vil.
		sol := self modOf: vol.
		[(self nextRight: vil) notNil and: (self nextLeft: vir) notNil] whileTrue: [
			vil := self nextRight: vil.
			vir := self nextLeft: vir.
			vol := self nextLeft: vol.
			vor := self nextRight: vor.
			self setAncestorOf: vor to: aPattern.
			shift := (self xOf: vil) + sil - ((self xOf: vir) + sir) + (self distance: aPattern).
			
			shift > 0 ifTrue: [ | a |
				a := (aPattern parent children includes: (self ancestorOf: vil))
					ifTrue: [self ancestorOf: vil]
					ifFalse: [newDefaultAncestor].
				self moveSubtree: aPattern by: shift of: a.
				sir := sir + shift.
				sor := sor + shift].
			sil := sil + (self modOf: vil).
			sir := sir + (self modOf: vir).
			sol := sol + (self modOf: vol).
			sor := sor + (self modOf: vor)].
		((self nextRight: vil) notNil and: (self nextRight: vor) isNil)
			ifTrue: [
				self setThreadOf: vor to: (self nextRight: vil).
				self setModOf: vor to: (self modOf: vor) + sil - sor]
			ifFalse: [
				((self nextLeft: vir) notNil and: (self nextLeft: vol) isNil) ifTrue: [
					self setThreadOf: vol to: (self nextLeft: vir).
					self setModOf: vol to: (self modOf: vol) + sir - sol].
				newDefaultAncestor := self]].
	^ newDefaultAncestor
]

{ #category : #accessing }
SBTreeLayoutPolicy >> changeOf: aPattern [

	^ (self layoutDataAt: aPattern) second
]

{ #category : #accessing }
SBTreeLayoutPolicy >> defaultLayoutEntry: aPattern [

	^ {aPattern. 0. 1. 0. 0. nil. -1000}
]

{ #category : #accessing }
SBTreeLayoutPolicy >> depthOf: aPattern [

	^ (self layoutDataAt: aPattern) third
]

{ #category : #layouting }
SBTreeLayoutPolicy >> distance: aPattern [

	^ aPattern fullBounds width + self inset
]

{ #category : #layouting }
SBTreeLayoutPolicy >> executeShifts: aPattern [

	| shift change |
	shift := 0.
	change := 0.
	aPattern children reverseDo: [:child |
		self setXOf: child to: (self xOf: child) + shift.
		self setModOf: child to: (self modOf: child) + shift.
		change := change + (self changeOf: child).
		shift := shift + (self shiftOf: child) + change]
]

{ #category : #layouting }
SBTreeLayoutPolicy >> firstWalk: aPattern [

	| left |
	left := aPattern leftSibling.
	
	aPattern children
		ifEmpty: [self setXOf: aPattern to: (self distance: aPattern) + (left ifNil: [0] ifNotNil: [self xOf: left])]
		ifNotEmpty: [ | defaultAncestor midpoint dist |
			defaultAncestor := aPattern children first.
			aPattern children do: [:child |
				self setDepthOf: child to: (self depthOf: aPattern) + 1.
				self firstWalk: child.
				defaultAncestor := self apportion: child defaultAncestor: defaultAncestor].
			self executeShifts: aPattern.
			midpoint := (self xOf: aPattern children first) - (self distance: aPattern children first) + (self xOf: aPattern children last) / 2.
			dist := self distance: aPattern.
			left ifNil: [self setXOf: aPattern to: midpoint + (dist / 2)] ifNotNil: [
				self setXOf: aPattern to: (self xOf: left) + dist.
				self setModOf: aPattern to: (self xOf: aPattern) - midpoint - (dist / 2)]]
]

{ #category : #'initialize-release' }
SBTreeLayoutPolicy >> initialize [

	super initialize.
	layoutData := Dictionary new
]

{ #category : #layouting }
SBTreeLayoutPolicy >> inset [

	^ 10
]

{ #category : #layouting }
SBTreeLayoutPolicy >> layout: aMorph in: aRectangle [

	| root |
	(aMorph submorphsSatisfying: #isConnector) do: #abandon.
	root := aMorph submorphs detect: [:submorph | submorph isTreeLayoutRoot].
	self
		resetAll;
		firstWalk: root;
		secondWalk: root modSum: 0 layerHeights: (self maximumHeight: root) + self inset.
	root addConnectorLinesIn: aMorph
]

{ #category : #accessing }
SBTreeLayoutPolicy >> layoutData [

	^ layoutData
]

{ #category : #accessing }
SBTreeLayoutPolicy >> layoutData: aDict [

	layoutData := aDict
]

{ #category : #accessing }
SBTreeLayoutPolicy >> layoutDataAt: aPattern [

	^ layoutData at: aPattern ifAbsentPut: (self defaultLayoutEntry: aPattern)
]

{ #category : #layouting }
SBTreeLayoutPolicy >> leftMostSibling: aPattern [

	^ aPattern parent ifNotNil: [ | left |
		left := aPattern parent children first.
		left = aPattern ifFalse: [left]]
]

{ #category : #layouting }
SBTreeLayoutPolicy >> maximumHeight: aPattern [

	| height |
	height := aPattern fullBounds height.
	aPattern children do: [:child | height := height max: (self maximumHeight: child)].
	^ height
]

{ #category : #layouting }
SBTreeLayoutPolicy >> minExtentOf: aMorph in: aRectangle [

	^ aMorph extent
]

{ #category : #accessing }
SBTreeLayoutPolicy >> modOf: aPattern [

	^ (self layoutDataAt: aPattern) fourth
]

{ #category : #layouting }
SBTreeLayoutPolicy >> moveSubtree: aPattern by: aShiftValue of: aParentPattern [

	| numberOfSubtrees |
	numberOfSubtrees := aPattern siblingIndex - aParentPattern siblingIndex.
	self setChangeOf: aPattern to: (self changeOf: aPattern) - aShiftValue / numberOfSubtrees.
	self setShiftOf: aPattern to: (self shiftOf: aPattern) + aShiftValue.
	self setXOf: aPattern to: (self xOf: aPattern) + aShiftValue.
	self setModOf: aPattern to: (self modOf: aPattern) + aShiftValue.
	self
		setChangeOf: aParentPattern
		to: (self changeOf: aParentPattern) + aShiftValue / numberOfSubtrees
]

{ #category : #layouting }
SBTreeLayoutPolicy >> nextLeft: aPattern [

	^ aPattern children
		ifEmpty: [self threadOf: aPattern]
		ifNotEmpty: [aPattern children first]
]

{ #category : #layouting }
SBTreeLayoutPolicy >> nextRight: aPattern [

	^ aPattern children
		ifEmpty: [self threadOf: aPattern]
		ifNotEmpty: [aPattern children last]
]

{ #category : #'initialize-release' }
SBTreeLayoutPolicy >> resetAll [

	self layoutData removeAll
]

{ #category : #layouting }
SBTreeLayoutPolicy >> secondWalk: aPattern modSum: aValue layerHeights: anotherValue [

	aPattern
		fullBounds;
		center: (self xOf: aPattern) + aValue - ((self distance: aPattern) / 2) @ (anotherValue * (self depthOf: aPattern)).
	"	self addConnectorLineToWorld."
	aPattern children do: [:child | self secondWalk: child modSum: aValue + (self modOf: aPattern) layerHeights: anotherValue]
]

{ #category : #accessing }
SBTreeLayoutPolicy >> setAncestorOf: aPattern to: anotherPattern [

	(self layoutDataAt: aPattern) at: 1 put: anotherPattern
]

{ #category : #accessing }
SBTreeLayoutPolicy >> setChangeOf: aPattern to: anotherPattern [

	(self layoutDataAt: aPattern) at: 2 put: anotherPattern
]

{ #category : #accessing }
SBTreeLayoutPolicy >> setDepthOf: aPattern to: anotherPattern [

	(self layoutDataAt: aPattern) at: 3 put: anotherPattern
]

{ #category : #accessing }
SBTreeLayoutPolicy >> setModOf: aPattern to: anotherPattern [

	(self layoutDataAt: aPattern) at: 4 put: anotherPattern
]

{ #category : #accessing }
SBTreeLayoutPolicy >> setShiftOf: aPattern to: anotherPattern [

	(self layoutDataAt: aPattern) at: 5 put: anotherPattern
]

{ #category : #accessing }
SBTreeLayoutPolicy >> setThreadOf: aPattern to: anotherPattern [

	(self layoutDataAt: aPattern) at: 6 put: anotherPattern
]

{ #category : #accessing }
SBTreeLayoutPolicy >> setXOf: aPattern to: anotherPattern [

	(self layoutDataAt: aPattern) at: 7 put: anotherPattern
]

{ #category : #accessing }
SBTreeLayoutPolicy >> shiftOf: aPattern [

	^ (self layoutDataAt: aPattern) fifth
]

{ #category : #accessing }
SBTreeLayoutPolicy >> threadOf: aPattern [

	^ (self layoutDataAt: aPattern) sixth
]

{ #category : #accessing }
SBTreeLayoutPolicy >> xOf: aPattern [

	^ (self layoutDataAt: aPattern) seventh
]
