Class {
	#name : #SBVPPattern,
	#superclass : #SBBlock,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPattern class >> example [

	^ SBVPGroupPattern new: {SBVPBindingPattern new: 1. SBVPConstraintPattern new: [:a | a label = 10]}
]

{ #category : #'as yet unclassified' }
SBVPPattern class >> example2 [

	^ SBVPGroupPattern new: {
		(SBVPBindingPattern new: 1) connections: {SBVPBindingPattern new: 2}.
		SBVPConstraintPattern new: [:a :b | a label = (b label + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPattern class >> example3 [

	^ SBVPGroupPattern new: {
		(SBVPBindingPattern new: 1) connections: {
			SBVPWildcardPattern new connections: {(SBVPBindingPattern new: 2) connections: {SBVPWildcardPattern new}}}.
		SBVPConstraintPattern new: [:a :b | a label = (b label + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPattern class >> example4 [

	^ self example3
]

{ #category : #'as yet unclassified' }
SBVPPattern class >> example5 [

	^ SBVPGroupPattern new: {
		SBVPWildcardPattern new connections: {
			(SBVPBindingPattern new: 1) connections: {
				SBVPWildcardPattern new connections: {(SBVPBindingPattern new: 2) connections: {SBVPWildcardPattern new}}}}.
		SBVPConstraintPattern new: [:a :b | a label = (b label + 10)]}
]

{ #category : #'as yet unclassified' }
SBVPPattern class >> example6 [

	^ SBVPGroupPattern new: {
		(SBVPBindingPattern new: 1) connections: {SBVPBindingPattern new: 2. SBVPBindingPattern new: 3}.
		SBVPConstraintPattern new: [:a :b :c | a label = (b label + c label)]}
]

{ #category : #'as yet unclassified' }
SBVPPattern class >> example7 [

	^ SBVPGroupPattern new: {
		SBVPWildcardPattern new connections: {
			SBVPEllipsisPattern new.
			(SBVPBindingPattern new: 1) connections: {
				(SBVPBindingPattern new: 2) connections: {SBVPEllipsisPattern new}.
				(SBVPBindingPattern new: 3) connections: {SBVPEllipsisPattern new}}.
			SBVPEllipsisPattern new}.
		SBVPConstraintPattern new: [:a :b :c | a label = (b label + c label)]}
]

{ #category : #'as yet unclassified' }
SBVPPattern >> getNext: aVisualPrimitive [
	"updates the visual primitive the pattern will bind to and returns whether a new binding was found. Whether the binding is correct needs to be checked with matches: withBinding:."

	^ false
]

{ #category : #'as yet unclassified' }
SBVPPattern >> matches: aVisualPrimitive withBinding: aCollection [

	^ true
]

{ #category : #'as yet unclassified' }
SBVPPattern >> reset [
	"do nothing"

	
]

{ #category : #'as yet unclassified' }
SBVPPattern >> setBindingFor: aVisualPrimitive in: aCollection [

	^ true
]
