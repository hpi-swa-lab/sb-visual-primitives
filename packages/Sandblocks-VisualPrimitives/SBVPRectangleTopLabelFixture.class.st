Class {
	#name : #SBVPRectangleTopLabelFixture,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPRectangleTopLabelFixture >> visualPrimitiveMapping [

	^ {
		#shape -> RectangleMorph.
		#topCenterLabel -> 'top'.
		SBVPPropertyMapping
			getter: [SBTextBubble new contents: 'Test']
			setter: [:aString | Transcript showln: aString]
			position: #bottomCenterLabel
			optionalArgs: {} asDictionary.
		#innerLabel -> #key.
		#connections -> ({self left. self right} reject: [:connection | connection isNil])}
]
