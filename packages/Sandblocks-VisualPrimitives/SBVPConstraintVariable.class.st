Class {
	#name : #SBVPConstraintVariable,
	#superclass : #SBStName,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPConstraintVariable >> replaceBy: aMorph [

	(aMorph isKindOf: SBStName) ifFalse: [super replaceBy: aMorph]
]

{ #category : #'as yet unclassified' }
SBVPConstraintVariable >> writeSourceOn: aStream [

	aStream
		nextPutAll: '(';
		nextPutAll: SBVPConstraintPattern constraintInputName;
		nextPutAll: ' at: #';
		nextPutAll: text contents;
		nextPutAll: ')'
]
