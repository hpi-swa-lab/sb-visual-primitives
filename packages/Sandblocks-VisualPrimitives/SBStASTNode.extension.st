Extension { #name : #SBStASTNode }

{ #category : #'*Sandblocks-VisualPrimitives' }
SBStASTNode >> visualize [
	<action>

	| visualizer objectClass |
	visualizer := [(SBVPVisualizer code: self copy showCode: false) isImplicit: true]
		on: Error
		do: [^ false].
	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: visualizer;
		shouldMergeWithNext: false;
		yourself).
	
	objectClass := (self evaluate isBlock ifTrue: [self evaluate value] ifFalse: [self evaluate]) class. 
	(objectClass class canUnderstandBeforeObject: #visualPrimitiveMapping) ifFalse: [
		SBPopup new
			  addMorphBack: (SBStMethod new
		selector: 'visualPrimitiveMapping'
			arguments: #()
			class: objectClass class;
		body: SBStBlockBody new);
			  showBelow: visualizer closeOnDeselect: true.
		self inform: 'The class ', objectClass name asString, ' does not implement visualPrimitiveMapping which is required to visualize its instance. Please do so'.]
]
