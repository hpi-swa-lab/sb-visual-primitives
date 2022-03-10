"
An SBPatternContainer is the visual representation of a pattern matching rule with SBDomainBlocks. It consists of an input and an output pattern (see SBPattern). For the pattern matching see SBPatternMatcher. You can choose a default class that determines the domainBlockMapping for the SBBindingPatterns.

By applying the case on an input object, the input pattern gets matched on this object and the matched part gets transformed to match the output pattern.

Instance Variables
	classNameInput:				SBStClassNameInput
	defaultVisualizationClass:	Class
	informationRow:				SBRow
	pattern:							SBBlock (SBPattern)
	strategy:							Dictionary

classNameInput
	- allows to select the defaultVisualizationClass

defaultVisualizationClass
	- SBBindingPatterns use this class's domainBlockMapping to determine how to display themselves per default

informationRow
	- container for all other components

pattern
	- the input pattern that is matched on
	- can be every kind of SBPattern

strategy
	- a dict to specify the matching strategy
	- current specifiers with their defaults:
		- #explicitRootMatching -> true
			- if true, the root of every SBBindingPattern only matches the root of the input
			- if false, the pattern can also match somewhere else in the input without further specification
		- #explicitChildrenMatching -> true
			- if true, every child has to be specified explicitly
			- if false, the pattern can also match if the specified children have more siblings than the pattern has
		- if there are no children specified in the pattern, an SBEllipsisPattern is implicitely added

"
Class {
	#name : #SBPatternContainer,
	#superclass : #SBStSubstitution,
	#instVars : [
		'classNameInput',
		'defaultVisualizationClass',
		'informationRow',
		'pattern',
		'strategy'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBPatternContainer class >> buttonSpecifications [

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
SBPatternContainer class >> childrenStrategy [

	^ #explicitChildrenMatching
]

{ #category : #'as yet unclassified' }
SBPatternContainer class >> matches: aMessageSend [

	^ false
]

{ #category : #'as yet unclassified' }
SBPatternContainer class >> rootStrategy [

	^ #explicitRootMatching
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> addToggleButtonFor: aSymbol [

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
SBPatternContainer >> artefactChanged: aMethodBlock [

	classNameInput ifNotNil: [classNameInput selectedClass ~= self defaultVisualizationClass ifTrue: [self defaultVisualizationClass: classNameInput selectedClass]]
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> binding: aString for: block class: aClass ifPresent: aBlock [

	| bindingsSet |
	bindingsSet := Set new.
	self patternRoots ifNotNil: [self patternRoots do: [:patternRoot | patternRoot collectBindingsInto: bindingsSet]].
	bindingsSet
		detect: [:b | b notNil and: [b contents = aString]]
		ifFound: [:b | ^ aBlock value: b].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> buildImplicitChildrenMatchingPattern [

	self pattern ifNotNil: [
		self pattern removeImplicitChildren.
		self explicitChildrenMatching ifFalse: [self pattern buildImplicitChildren: Dictionary new]]
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> cellInset [

	^ 3
]

{ #category : #accessing }
SBPatternContainer >> classNameInput [

	^ classNameInput
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> color [

	^ color
]

{ #category : #accessing }
SBPatternContainer >> defaultVisualizationClass [

	^ defaultVisualizationClass
]

{ #category : #accessing }
SBPatternContainer >> defaultVisualizationClass: aClass [

	defaultVisualizationClass := aClass
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> explicitChildrenMatching [

	^ self strategy at: #explicitChildrenMatching ifAbsent: [true]
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> explicitRootMatching [

	^ self strategy at: #explicitRootMatching ifAbsent: [true]
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> findAllBindings: aPattern [

	| bindings |
	bindings := Set new.
	
	aPattern collectBindingsInto: bindings.
	
	^ bindings
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> findAllBindingsAsDict: aPattern [

	^ Dictionary new addAll: ((self findAllBindings: aPattern) asOrderedCollection collect: [:aSBStName | aSBStName contents -> aSBStName]); yourself
]

{ #category : #accessing }
SBPatternContainer >> informationRow [

	^ informationRow
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> initialize [

	super initialize.
	informationRow := SBRow new cellInset: self cellInset.
	self
		changeTableLayout;
		shrinkWrap;
		cellInset: self cellInset;
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself)
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> isValidBinding: aString [

	^ (self findAllBindings: self pattern) contains: [:binding | binding contents = aString]
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> noteNewOwner: aMorph [

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
				cellInset: self cellInset;
				cellPositioning: #center)).
		row addMorphBack: self pattern]
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> objectInterfaceNear: aBlock at: aSymbol [

	^ {[:o | o isKindOf: SBDomainBlock]}
]

{ #category : #accessing }
SBPatternContainer >> pattern [

	^ pattern
]

{ #category : #accessing }
SBPatternContainer >> pattern: anSBBlock [

	pattern := anSBBlock
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> patternRoots [

	^ self pattern children isEmpty
		ifTrue: [nil]
		ifFalse: [self pattern children select: [:child | child isKindOf: SBBindingPattern]]
]

{ #category : #accessing }
SBPatternContainer >> strategy [

	^ strategy
]

{ #category : #accessing }
SBPatternContainer >> strategy: aDict [

	strategy ifNotNil: [strategy addAll: aDict] ifNil: [strategy := aDict].
	self class buttonSpecifications keysDo: [:strategySymbol | self addToggleButtonFor: strategySymbol].
	self buildImplicitChildrenMatchingPattern
]

{ #category : #accessing }
SBPatternContainer >> strategyButtonFor: aSymbol [

	| index |
	index := (self class buttonSpecifications at: aSymbol) at: #index.
	^ self informationRow submorphs at: index ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> toggleImplicitChildTo: aBoolean withBinding: aString [

	self toggleImplicitChildTo: aBoolean withBinding: aString on: self pattern
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> toggleImplicitChildTo: aBoolean withBinding: aString on: aSBPattern [

	aSBPattern allChildrenDo: [:child |
		child bindingIndex = aString ifTrue: [
			child isImplicitChild: aBoolean.
			^ self]]
]

{ #category : #'as yet unclassified' }
SBPatternContainer >> toggleStrategy: aSymbol [

	self strategy at: aSymbol put: (self strategy at: aSymbol) not.
	aSymbol = self class childrenStrategy ifTrue: [self buildImplicitChildrenMatchingPattern].
	self addToggleButtonFor: aSymbol
]
