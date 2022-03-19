"
An SBSelectProperty displays the currently selected value of a number of choices as their corresponding representation. On double click a pop up allows to select a new value.

SBSelectProperties are created through SBPropertyMappingSelects.

Instance Variables
	choices: 					OrderedCollection
	currentValueIndex:	Object
	representations:		OrderedCollection
	title:						String

choices
	- contains the selectable options of the select

currentValueIndex
	- the actual selected object

representations
	- contains the visualizations of the choices
	- if there are no visualizations, choices are shown as Strings

title
	- this is the name of the select property as a String

"
Class {
	#name : #SBSelectProperty,
	#superclass : #SBBlock,
	#instVars : [
		'choices',
		'currentValueIndex',
		'representations',
		'title'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #'as yet unclassified' }
SBSelectProperty class >> choices: anOrderedCollection representations: anotherOrderedCollection initialValue: anObject title: aString [

	| index |
	index := anOrderedCollection indexOf: anObject.
	
	^ SBSelectProperty new
		choices: anOrderedCollection;
		representations: anotherOrderedCollection;
		currentValueIndex: index;
		title: aString
]

{ #category : #accessing }
SBSelectProperty >> addDBLabel: aMorph [

	| temp |
	^ self hasSubmorphs
		ifTrue: [
			temp := self submorphs first.
			temp layoutPolicy ifNil: [
				temp
					changeTableLayout;
					listCentering: #center;
					wrapCentering: #center;
					shrinkWrap].
			temp addDBLabel: aMorph]
		ifFalse: [super addDBLabel: aMorph]
]

{ #category : #accessing }
SBSelectProperty >> balloonText [

	^ 'Double click to change value.'
]

{ #category : #accessing }
SBSelectProperty >> choices [

	^ choices
]

{ #category : #accessing }
SBSelectProperty >> choices: anOrderedCollection [

	choices := anOrderedCollection
]

{ #category : #accessing }
SBSelectProperty >> contents [

	^ self currentChoice
]

{ #category : #accessing }
SBSelectProperty >> currentChoice [

	^ self choices at: self currentValueIndex
]

{ #category : #accessing }
SBSelectProperty >> currentValueIndex [

	^ currentValueIndex
]

{ #category : #accessing }
SBSelectProperty >> currentValueIndex: aNumber [

	currentValueIndex := aNumber.
	self
		removeAllMorphs;
		addMorphBack: (self getRepresentationMorphAt: currentValueIndex)
]

{ #category : #'event handling' }
SBSelectProperty >> doubleClick: anEvent [

	| selectedIndex |
	selectedIndex := UIManager default chooseFrom: self choices title: self title.
	(selectedIndex <= self choices size and: [selectedIndex > 0]) ifTrue: [
		self sandblockEditor do: (SBMutatePropertyCommand new
			target: self;
			selector: #currentValueIndex;
			mutateSelector: #currentValueIndex:;
			value: selectedIndex)]
]

{ #category : #accessing }
SBSelectProperty >> getRepresentationMorphAt: anIndex [

	| representation |
	representation := self representations
		at: anIndex
		ifAbsent: (SBIcon iconWarning color: Color orange).
	
	(representation isNumber or: [representation isString]) ifTrue: [^ SBStringMorph new contents: representation asString].
	representation isMorph ifTrue: [^ representation].
	
	^ nil
]

{ #category : #initialization }
SBSelectProperty >> initialize [

	super initialize.
	self
		changeTableLayout;
		shrinkWrap
]

{ #category : #accessing }
SBSelectProperty >> representations [

	^ representations
]

{ #category : #accessing }
SBSelectProperty >> representations: anOrderedCollection [

	representations := anOrderedCollection
]

{ #category : #accessing }
SBSelectProperty >> title [

	^ title
]

{ #category : #accessing }
SBSelectProperty >> title: aString [

	title := aString
]

{ #category : #'halos and balloon help' }
SBSelectProperty >> wantsBalloon [

	^ true
]

{ #category : #printing }
SBSelectProperty >> writeSourceOn: aStream [

	aStream store: self contents
]
