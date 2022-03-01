"
An SBVPCase is the visual representation of a pattern matching rule with SBVisualPrimitives. It consists of an input and an output pattern (see SBVPPattern). For the pattern matching see SBVPPatternMatcher. You can choose a default class that determines the visualPrimitiveMapping for the SBVPBindingPatterns.

By applying the case on an input object, the input pattern gets matched on this object and the matched part gets transformed to match the output pattern.

Instance Variables
	classNameInput:					SBStClassNameInput
	defaultPatternVisualizationClass:	Class
	informationRow:					SBRow
	input:								SBBlock (SBVPPattern)
	output:								SBBlock (SBVPPattern)
	strategy:							Dictionary

classNameInput
	- allows to select the defaultPatternVisualizationClass

defaultPatternVisualizationClass
	- SBVPBindingPatterns use this class's visualPrimitiveMapping to determine how to display themselves per default

informationRow
	- container for all other components

input
	- the input pattern that is matched on
	- can be every kind of SBVPPattern

output
	- this is the result of the transformation
	if true, the root of every SBVPBindingPattern only matches the root of the input
	if false, the pattern can also match somewhere else in the input without further specification

strategy
	- a dict to specify the matching strategy
	- current specifiers with their defaults:
		- #explicitRootMatching -> true
			- if true, the root of every SBVPBindingPattern only matches the root of the input
			- if false, the pattern can also match somewhere else in the input without further specification
		- #explicitChildrenMatching -> true
			- if true, every child has to be specified explicitly
			- if false, the pattern can also match if the specified children have more siblings than the pattern has. 
			  If there are no children specified in the pattern, an SBVPEllipsisPattern is implicitely added.

"
Class {
	#name : #SBVPPatternContainer,
	#superclass : #SBStSubstitution,
	#instVars : [
		'pattern',
		'strategy',
		'informationRow',
		'defaultVisualizationClass',
		'classNameInput'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPatternContainer class >> buttonSpecifications [

	^ {
		self rootStrategy -> {
			#index -> 1.
			#icons -> {true -> SBIcon iconAnchor. false -> SBIcon iconTree} asDictionary.
			#text -> {true -> 'root matching'. false -> 'subtree matching'} asDictionary} asDictionary.
		self childrenStrategy -> {
			#index -> 2.
			#icons -> {true -> SBIcon iconChild. false -> SBIcon iconEyeSlash} asDictionary.
			#text -> {true -> 'explicit children'. false -> 'implicit children'} asDictionary} asDictionary} asDictionary
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer class >> childrenStrategy [

	^ #explicitChildrenMatching
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer class >> matches: aMessageSend [

	^ false
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer class >> rootStrategy [

	^ #explicitRootMatching
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> addToggleButtonFor: aSymbol [

	| correctIcon correctText button isExplicit |
	isExplicit := self strategy at: aSymbol.
	correctIcon := ((self class buttonSpecifications at: aSymbol) at: #icons) at: isExplicit.
	correctText := ((self class buttonSpecifications at: aSymbol) at: #text) at: isExplicit.
	button := SBButton new icon: correctIcon label: correctText do: [
		self sandblockEditor do: (SBDoItCommand new
			artefactFrom: self containingArtefact;
			do: [self toggleStrategy: aSymbol])].
	
	(self strategyButtonFor: aSymbol)
		ifNil: [self informationRow addMorphBack: button]
		ifNotNil: [:existingButton | existingButton replaceBy: button]
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> artefactChanged: aMethodBlock [

	classNameInput ifNotNil: [classNameInput selectedClass ~= self defaultVisualizationClass ifTrue: [self defaultVisualizationClass: classNameInput selectedClass]]
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> binding: aString for: block class: aClass ifPresent: aBlock [

	| bindingsSet |
	bindingsSet := Set new.
	self patternRoots ifNotNil: [self patternRoots do: [:patternRoot | patternRoot collectBindingsInto: bindingsSet]].
	bindingsSet
		detect: [:b | b notNil and: [b contents = aString]]
		ifFound: [:b | ^ aBlock value: b].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> buildImplicitChildrenMatchingPattern [

	self pattern notNil ifTrue: [
		self pattern removeImplicitChildren.
		self explicitChildrenMatching ifFalse: [
			self pattern
				buildImplicitChildren: Dictionary new;
				attachTreeDecorator].
		self pattern layout]
]

{ #category : #accessing }
SBVPPatternContainer >> classNameInput [

	^ classNameInput
]

{ #category : #accessing }
SBVPPatternContainer >> classNameInput: aBlock [

	classNameInput := aBlock
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> color [

	^ color
]

{ #category : #accessing }
SBVPPatternContainer >> defaultVisualizationClass [

	^ defaultVisualizationClass
]

{ #category : #accessing }
SBVPPatternContainer >> defaultVisualizationClass: anObject [

	defaultVisualizationClass := anObject.
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> explicitChildrenMatching [

	^ self strategy at: #explicitChildrenMatching ifAbsent: [true]
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> explicitRootMatching [

	^ self strategy at: #explicitRootMatching ifAbsent: [true]
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> findAllBindings: aPattern [

	| bindings |
	bindings := Set new.
	
	aPattern collectBindingsInto: bindings.
	
	^ bindings
]

{ #category : #accessing }
SBVPPatternContainer >> informationRow [

	^ informationRow
]

{ #category : #accessing }
SBVPPatternContainer >> informationRow: aBlock [

	informationRow := aBlock
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> initialize [

	super initialize.
	informationRow := SBRow new cellInset: 3.
	self
		changeTableLayout;
		shrinkWrap;
		cellInset: 3;
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> isValidBinding: aString [

	^ (self findAllBindings: self pattern) contains: [:binding | binding contents = aString]
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	classNameInput ifNil: [ | row |
		classNameInput := SBStClassNameInput new
			object: self defaultVisualizationClass;
			prefix: 'Class: '.
		self addMorph: (SBColumn new
			cellPositioning: #center;
			addMorphBack: classNameInput;
			addMorphBack: self informationRow;
			addMorphBack: (row := SBRow new
				cellInset: 3;
				cellPositioning: #center)).
		row addMorphBack: self pattern]
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> objectInterfaceNear: aBlock at: aSymbol [

	^ {[:o | o isKindOf: SBVisualPrimitive]}
]

{ #category : #accessing }
SBVPPatternContainer >> pattern [

	^ pattern
]

{ #category : #accessing }
SBVPPatternContainer >> pattern: anSBBlock [

	pattern := anSBBlock
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> patternRoot [

	self flag: #tooOptimistic.
	^ self pattern children first
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> patternRoots [

	^ self pattern children isEmpty
		ifTrue: [nil]
		ifFalse: [self pattern children select: [:child | child isKindOf: SBVPBindingPattern]]
]

{ #category : #accessing }
SBVPPatternContainer >> strategy [

	^ strategy
]

{ #category : #accessing }
SBVPPatternContainer >> strategy: aDict [

	strategy ifNotNil: [strategy addAll: aDict] ifNil: [strategy := aDict].
	self class buttonSpecifications keysDo: [:strategySymbol | self addToggleButtonFor: strategySymbol].
	self buildImplicitChildrenMatchingPattern
]

{ #category : #accessing }
SBVPPatternContainer >> strategyButtonFor: aSymbol [

	| index |
	index := (self class buttonSpecifications at: aSymbol) at: #index.
	^ self informationRow submorphs at: index ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> toggleImplicitChildTo: aBoolean withBinding: aString on: aSBVPPattern [

	aSBVPPattern allConnectionsDo: [:pattern |
		pattern bindingIndex = aString ifTrue: [
			pattern isImplicitChild: aBoolean.
			^ self]]
]

{ #category : #'as yet unclassified' }
SBVPPatternContainer >> toggleStrategy: aSymbol [

	self strategy at: aSymbol put: (self strategy at: aSymbol) not.
	aSymbol = self class childrenStrategy ifTrue: [self buildImplicitChildrenMatchingPattern].
	self addToggleButtonFor: aSymbol
]
