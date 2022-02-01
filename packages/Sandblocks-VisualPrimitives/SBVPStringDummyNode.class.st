Class {
	#name : #SBVPStringDummyNode,
	#superclass : #SBVPDummyNode,
	#category : #'Sandblocks-VisualPrimitives-Fixtures'
}

{ #category : #'as yet unclassified' }
SBVPStringDummyNode class >> visualPrimitiveMapping [

	^ {SBVPPropertyMappingString property: #key vpProperty: #innerLabel. self connectionsMappingEntry}
]

{ #category : #'as yet unclassified' }
SBVPStringDummyNode >> key [

	^ key asString
]

{ #category : #'as yet unclassified' }
SBVPStringDummyNode >> key: aValue [

	key := aValue asString
]
