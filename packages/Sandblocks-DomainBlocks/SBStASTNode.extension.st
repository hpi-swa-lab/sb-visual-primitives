Extension { #name : #SBStASTNode }

{ #category : #'*Sandblocks-DomainBlocks' }
SBStASTNode >> visualize [
	<action>

	| domainBlockContainer objectClass |
	domainBlockContainer := [(SBDomainBlockContainer code: self copy) isImplicit: true]
		on: Error
		do: [^ false].
	
	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: domainBlockContainer;
		shouldMergeWithNext: false;
		yourself).
	
	objectClass := (self evaluate isBlock
		ifTrue: [self evaluate value]
		ifFalse: [self evaluate]) class.
	(objectClass class canUnderstandBeforeObject: #domainBlockMapping) ifFalse: [
		self flag: #TODO.
		"Toms Feedback einarbeiten dass die some positions zu unknowns werden"
		SBPopup new
			addMorphBack: (SBStMethod new
				selector: 'domainBlockMapping' arguments: #() class: objectClass class;
				body: (SBStBlockBody new statements: {
					[:b | b return: '{ #shape dbConstant: (RectangleMorph new color: (Color green)).
			#identityLabelPosition dbConstant: #somePosition.
			#somePosition dbNumberFor: #someNumberAccessor.
			#somePosition dbStringFor: #someStringAccessor.
		}' parseAsSandblock] sbStBuild}));
			showBelow: domainBlockContainer closeOnDeselect: true.
		self inform: 'The class ', objectClass name asString, ' does not implement domainBlockMapping which is required to visualize its instance. Please do so']
]
