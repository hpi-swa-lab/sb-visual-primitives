"
An SBVPSelectProperty displays the currently selected value of a number of choices as their corresponding representation. On double click a pop up allows to select a new value.

SBVPSelectProperties are created through SBVPPropertyMappingSelects.
"
Class {
	#name : #SBVPSelectProperty,
	#superclass : #SBBlock,
	#instVars : [
		'currentValueIndex',
		'choices',
		'representations',
		'title'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPSelectProperty class >> choices: aCollection representations: anotherCollection initialValue: anObject title: aString [

	| index |
	index := aCollection indexOf: anObject.
	
	^ SBVPSelectProperty new
		choices: aCollection;
		representations: anotherCollection;
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
SBVPSelectProperty >> choices: anObject [

	choices := anObject
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
SBVPSelectProperty >> currentValueIndex: anObject [

	currentValueIndex := anObject.
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
	"maybe throw error, because we don't support this right noẁ"
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
SBVPSelectProperty >> representations: anObject [

	representations := anObject
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
