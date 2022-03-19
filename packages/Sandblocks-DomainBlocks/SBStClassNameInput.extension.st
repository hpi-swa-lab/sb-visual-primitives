Extension { #name : #SBStClassNameInput }

{ #category : #'*Sandblocks-DomainBlocks' }
SBStClassNameInput >> promptClassForDBCase [

	(UIManager default
		chooseClassOrTrait: 'Choose the class of the objects used it this case'
		from: Smalltalk globals) ifNotNil: [:class | self selectedClass: class]
]
