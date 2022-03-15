Extension { #name : #SBStASTNode }

{ #category : #'*Sandblocks-DomainBlocks' }
SBStASTNode >> visualize [
	<action>

	| domainblockcontainer objectClass |
	domainblockcontainer := [(SBDomainBlockContainer code: self copy) isImplicit: true]
		on: Error
		do: [^ false].
	
	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: domainblockcontainer;
		shouldMergeWithNext: false;
		yourself).
	
	objectClass := (self evaluate isBlock
		ifTrue: [self evaluate value]
		ifFalse: [self evaluate]) class.
	(objectClass class canUnderstandBeforeObject: #domainBlockMapping) ifFalse: [
		SBPopup new
			addMorphBack: (SBStMethod new
				selector: 'domainBlockMapping' arguments: #() class: objectClass class;
				body: (SBStBlockBody new statements: {
					self grammarHandler newCommentBlock contents: 'Allowed positions are #topLeftLabel, #topCenterLabel, #topRightLabel, leftLabel, #shape, #rightLabel, #bottomLeftLabel, #bottomCenterLabel, #bottomRightLabel.'.
					[:b | b return: '{ #shape vpConstant: (RectangleMorph new color: (Color green)).
			#identityLabelPosition vpConstant: #somePosition.
			#somePosition vpNumberFor: #someNumberAccessor.
			#somePosition vpStringFor: #someStringAccessor.
		}' parseAsSandblock] sbStBuild}));
			showBelow: domainblockcontainer closeOnDeselect: true.
		self inform: 'The class ', objectClass name asString, ' does not implement domainBlockMapping which is required to visualize its instance. Please do so']
]
