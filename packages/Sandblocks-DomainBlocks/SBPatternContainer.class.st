"
An SBPatternContainer is the visual representation of a pattern matching rule with SBDomainBlocks. It consists of an input and an output pattern (SBGroupPatterns). For the pattern matching see SBPatternMatcher. You can choose a default class that determines the domainBlockMapping for the SBBindingPatterns.

By applying the case on an input object, the input pattern gets matched on this object and the matched part gets transformed to match the output pattern.

Instance Variables
	classNameInput:				SBStClassNameInput
	defaultVisualizationClass:	Class
	informationRow:				SBRow
	pattern:							SBGroupPattern
	strategy:							Dictionary

classNameInput
	- allows to select the defaultVisualizationClass

defaultVisualizationClass
	- SBBindingPatterns use this class's domainBlockMapping to determine how to display themselves per default

informationRow
	- container for all other components

pattern
	- the input SBGroupPattern that is matched on

strategy
	- a dict to specify the matching strategy
	- current specifiers with their defaults:
		- #explicitRootMatching -> true
			- if true, the root of every SBBindingPattern only matches the root of the input
			- if false, the pattern can also match somewhere else in the input without further specification
		- #explicitChildrenMatching -> true
			- if true, every child has to be specified explicitly
			- if false, the pattern can also match if the specified patternChildren have more siblings than the pattern has
		- if there are no patternChildren specified in the pattern, an SBEllipsisPattern is implicitely added

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
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
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
			#text -> {true -> 'explicit patternChildren'. false -> 'implicit patternChildren'} asDictionary} asDictionary} asDictionary
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

{ #category : #'adding/removing' }
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

{ #category : #callbacks }
SBPatternContainer >> artefactChanged: aMethodBlock [

	classNameInput ifNotNil: [classNameInput selectedClass ~= self defaultVisualizationClass ifTrue: [self defaultVisualizationClass: classNameInput selectedClass]]
]

{ #category : #'ast helpers' }
SBPatternContainer >> binding: aString for: block class: aClass ifPresent: aBlock [

	self findAllBindings
		detect: [:b | b notNil and: [b contents = aString]]
		ifFound: [:b | ^ aBlock value: b].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'pattern matching' }
SBPatternContainer >> buildImplicitChildrenMatchingPattern [

	self pattern ifNotNil: [
		self pattern removeImplicitChildren.
		self explicitChildrenMatching ifFalse: [self pattern buildImplicitChildren: Dictionary new]]
]

{ #category : #accessing }
SBPatternContainer >> cellInset [

	^ 3
]

{ #category : #accessing }
SBPatternContainer >> classNameInput [

	^ classNameInput
]

{ #category : #accessing }
SBPatternContainer >> color [

	^ color
]

{ #category : #accessing }
SBPatternContainer >> defaultVisualizationClass [

	^ defaultVisualizationClass
]

{ #category : #accessing }
SBPatternContainer >> defaultVisualizationClass: aClass [

	defaultVisualizationClass := aClass.
	self classNameInput object: aClass
]

{ #category : #'pattern matching' }
SBPatternContainer >> explicitChildrenMatching [

	^ self strategy at: #explicitChildrenMatching ifAbsent: [true]
]

{ #category : #'pattern matching' }
SBPatternContainer >> explicitRootMatching [

	^ self strategy at: #explicitRootMatching ifAbsent: [true]
]

{ #category : #'pattern matching' }
SBPatternContainer >> findAllBindings [

	| bindings |
	bindings := Set new.
	self pattern collectBindingsInto: bindings.
	^ bindings
]

{ #category : #'insert/delete' }
SBPatternContainer >> findAllIdentityBindingsAsDict: aPattern [

	| bindings |
	bindings := Set new.
	aPattern collectIdentityBindingsInto: bindings.
	^ Dictionary new
		addAll: (bindings asOrderedCollection collect: [:aSBStName | aSBStName contents -> aSBStName]);
		yourself
]

{ #category : #'insert/delete' }
SBPatternContainer >> identifierForIndex: aNumber [

	^ ('', (Character alphabet at: aNumber - 1 // Character alphabet size + 1)) asSymbol
]

{ #category : #'insert/delete' }
SBPatternContainer >> implicitPrefix [

	^ 'i_'
]

{ #category : #accessing }
SBPatternContainer >> informationRow [

	^ informationRow
]

{ #category : #accessing }
SBPatternContainer >> initialize [

	super initialize.
	informationRow := SBRow new cellInset: self cellInset.
	self
		changeTableLayout;
		shrinkWrap;
		listDirection: #topToBottom;
		cellPositioning: #center;
		cellInset: self cellInset;
		strategy: (Dictionary new
			add: #explicitRootMatching -> true;
			add: #explicitChildrenMatching -> true;
			yourself).
	
	classNameInput := SBStClassNameInput new prefix: 'Class: '.
	self
		addMorphBack: classNameInput;
		addMorphBack: self informationRow
]

{ #category : #'pattern matching' }
SBPatternContainer >> isValidBinding: aString [

	^ self findAllBindings contains: [:binding | binding contents = aString]
]

{ #category : #'insert/delete' }
SBPatternContainer >> nextIdentifier [

	| invalidIdentifiers currentAttempt possibleIdentifer |
	invalidIdentifiers := Array streamContents: [:stream |
		self pattern allChildrenDo: [:child | | element |
			element := child bindingName.
			element := element ifNotNil: [
				(child bindingName beginsWith: self implicitPrefix)
					ifTrue: [element from: self implicitPrefix size + 1]
					ifFalse: [element]].
			stream nextPut: element]].
	
	currentAttempt := 1.
	[
		possibleIdentifer := self identifierForIndex: currentAttempt.
		invalidIdentifiers includes: possibleIdentifer] whileTrue: [currentAttempt := currentAttempt + 1].
	
	^ possibleIdentifer
]

{ #category : #accessing }
SBPatternContainer >> pattern [

	^ pattern
]

{ #category : #accessing }
SBPatternContainer >> pattern: anSBGroupPattern [

	| row |
	pattern := anSBGroupPattern.
	self addMorphBack: (row := SBRow new
		cellInset: self cellInset;
		cellPositioning: #center).
	row addMorphBack: self pattern
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

{ #category : #'pattern matching' }
SBPatternContainer >> toggleImplicitChildTo: aBoolean withBinding: aString [

	self toggleImplicitChildTo: aBoolean withBinding: aString on: self pattern
]

{ #category : #'pattern matching' }
SBPatternContainer >> toggleImplicitChildTo: aBoolean withBinding: aString on: anSBPattern [

	anSBPattern allChildrenDo: [:child |
		child bindingName = aString ifTrue: [
			(child isKindOf: SBEllipsisPattern) ifTrue: [child isImplicitChild: aBoolean].
			^ self]]
]

{ #category : #'pattern matching' }
SBPatternContainer >> toggleStrategy: aSymbol [

	self strategy at: aSymbol put: (self strategy at: aSymbol) not.
	aSymbol = self class childrenStrategy ifTrue: [self buildImplicitChildrenMatchingPattern].
	self addToggleButtonFor: aSymbol
]
