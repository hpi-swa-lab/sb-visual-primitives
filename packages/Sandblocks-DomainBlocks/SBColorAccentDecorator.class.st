Class {
	#name : #SBColorAccentDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'message',
		'color'
	],
	#category : #'Sandblocks-DomainBlocks'
}

{ #category : #callbacks }
SBColorAccentDecorator >> attached: aMorph [

	self message ifNotNil: [
	aMorph balloonText: self message].
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
