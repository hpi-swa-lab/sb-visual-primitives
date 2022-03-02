"
An SBVPSelectProperty displays the currently selected value of a number of choices as their corresponding representation. On double click a pop up allows to select a new value.

SBVPSelectProperties are created through SBVPPropertyMappingSelects.

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
	#name : #SBVPSelectProperty,
	#superclass : #SBBlock,
	#instVars : [
		'choices',
		'currentValueIndex',
		'representations',
		'title'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPSelectProperty class >> choices: anOrderedCollection representations: anotherOrderedCollection initialValue: anObject title: aString [

	| index |
	index := anOrderedCollection indexOf: anObject.
	
	^ SBVPSelectProperty new
		choices: anOrderedCollection;
		representations: anotherOrderedCollection;
		currentValueIndex: index;
		title: aString
]

{ #category : #accessing }
SBVPSelectProperty >> addVPLabel: aMorph [

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
			temp addVPLabel: aMorph]
		ifFalse: [super addVPLabel: aMorph]
]

{ #category : #accessing }
SBVPSelectProperty >> balloonText [

	^ 'Double click to change value.'
]

{ #category : #accessing }
SBVPSelectProperty >> choices [

	^ choices
]

{ #category : #accessing }
SBVPSelectProperty >> choices: anOrderedCollection [

	choices := anOrderedCollection
]

{ #category : #accessing }
SBVPSelectProperty >> contents [

	^ self currentChoice
]

{ #category : #accessing }
SBVPSelectProperty >> currentChoice [

	^ self choices at: self currentValueIndex
]

{ #category : #accessing }
SBVPSelectProperty >> currentRepresentation [

	^ self representations at: self currentValueIndex
]

{ #category : #accessing }
SBVPSelectProperty >> currentValueIndex [

	^ currentValueIndex
]

{ #category : #accessing }
SBVPSelectProperty >> currentValueIndex: aNumber [

	currentValueIndex := aNumber.
	self
		removeAllMorphs;
		addMorphBack: (self getRepresentationMorphAt: currentValueIndex)
]

{ #category : #accessing }
SBVPSelectProperty >> doubleClick: anEvent [

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
SBVPSelectProperty >> getRepresentationMorphAt: anIndex [

	| representation |
	representation := self representations
		at: anIndex
		ifAbsent: (SBIcon iconWarning color: Color orange).
	
	(representation isNumber or: [representation isString]) ifTrue: [^ SBStringMorph new contents: representation asString].
	representation isMorph ifTrue: [^ representation].
	
	^ nil
]

{ #category : #accessing }
SBVPSelectProperty >> initialize [

	super initialize.
	self
		changeTableLayout;
		shrinkWrap
]

{ #category : #accessing }
SBVPSelectProperty >> representations [

	^ representations
]

{ #category : #accessing }
SBVPSelectProperty >> representations: anOrderedCollection [

	representations := anOrderedCollection
]

{ #category : #accessing }
SBVPSelectProperty >> title [

	^ title
]

{ #category : #accessing }
SBVPSelectProperty >> title: aString [

	title := aString
]

{ #category : #accessing }
SBVPSelectProperty >> wantsBalloon [

	^ true
]

{ #category : #accessing }
SBVPSelectProperty >> writeSourceOn: aStream [

	aStream store: self contents
]
