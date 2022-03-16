"
An SBColorAccentDecorator is a decorator that allows to draw sandblocks with a border. Currently used only for highlighting changes in patterns; needs to be turned on in the preferences in the category Sandblocks-DomainBlocks-PatternMatching.

Instance Variables
	color:				Color
	message:		String

color
	- the color of the border

message
	- if specified, this will be displayed as a balloonText of the sandblock 

"
Class {
	#name : #SBColorAccentDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'message',
		'color'
	],
	#category : #'Sandblocks-DomainBlocks-PatternMatching'
}

{ #category : #callbacks }
SBColorAccentDecorator >> attached: aMorph [

	self message ifNotNil: [aMorph balloonText: self message].
	aMorph borderWidth: self borderWidth.
	super attached: aMorph
]

{ #category : #drawing }
SBColorAccentDecorator >> borderWidth [

	^ 3
]

{ #category : #accessing }
SBColorAccentDecorator >> color [

	^ color
]

{ #category : #accessing }
SBColorAccentDecorator >> color: aColor [

	color := aColor
]

{ #category : #callbacks }
SBColorAccentDecorator >> detached: aMorph [

	aMorph balloonText: nil.
	aMorph borderWidth: 0.
	super detached: aMorph
]

{ #category : #accessing }
SBColorAccentDecorator >> message [

	^ message
]

{ #category : #accessing }
SBColorAccentDecorator >> message: aString [

	message := aString
]

{ #category : #drawing }
SBColorAccentDecorator >> postDrawOn: aCanvas [

	aCanvas frameRoundRect: self morph bounds radius: 5 width: self borderWidth color: self color
]
