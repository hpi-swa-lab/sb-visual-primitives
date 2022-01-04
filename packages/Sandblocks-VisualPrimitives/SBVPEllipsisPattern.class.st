Class {
	#name : #SBVPEllipsisPattern,
	#superclass : #SBVPBindingPattern,
	#instVars : [
		'currentSize'
	],
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> buildFromBinding: anArray [

	^ (anArray at: self bindingIndex) veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> buildImplicitChildren: anArray [

	
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> connections: aCollection [

	self assert: aCollection isEmpty description: 'Ellipses should not have children'.
	super connections: aCollection
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> couldMatch: aVisualPrimitive [

	^ true
]

{ #category : #accessing }
SBVPEllipsisPattern >> currentSize [

	^ currentSize
]

{ #category : #accessing }
SBVPEllipsisPattern >> currentSize: anObject [

	currentSize := anObject
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> getNext: aVisualPrimitive [

	self currentSize: self currentSize + 1.
	^ true
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> indexOffset [

	^ self currentSize - 1
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> initialize [

	super initialize.
	self currentSize: 0.
	self firstSubmorph addMorph: (SBIcon iconEllipsisH scale: 1.5)
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> reset [

	super reset.
	self currentSize: 0
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> searchRootFor: aVisualPrimitive at: anIndex [

	^ aVisualPrimitive connections
		copyFrom: anIndex
		to: anIndex + self indexOffset
]

{ #category : #'as yet unclassified' }
SBVPEllipsisPattern >> wantsImplicitNeighbors [

	^ false
]
