Class {
	#name : #SBRectangleTopLabelFixture,
	#superclass : #SBDummyNode,
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBRectangleTopLabelFixture class >> domainBlockMapping [

	^ {
		#shape dbConstant: (RectangleMorph new
			color: (Color r: 0.0 g: 1 b: 0.502);
			changeTableLayout;
			listCentering: #center;
			wrapCentering: #center;
			shrinkWrap;
			layoutInset: 8;
			yourself).
		#identityLabelPosition dbConstant: #bottomCenterLabel.
		#innerLabel dbStringFor: #key.
		self childrenMappingEntry}
]
