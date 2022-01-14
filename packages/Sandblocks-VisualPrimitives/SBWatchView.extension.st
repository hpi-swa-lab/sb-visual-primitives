Extension { #name : #SBWatchView }

{ #category : #'*Sandblocks-VisualPrimitives' }
SBWatchView >> reportValue: anObject [

	| morph vp |
	applyingChange ifTrue: [^ self].
	
	[
		applyingChange := true.
		hadValue ifFalse: [hadValue := true].
		(anObject isKindOf: SBVPDummyNode) 
			ifTrue: [
				morph := SBBlock new
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap;
					layoutInset: 6.
				vp := SBVisualPrimitive newFromObject: anObject in: morph.
				vp attachTreeDecorator.
				vp withDecorator: SBTreeDecorator do: [:dec | dec layout].
				self useDisplay: (SBRow new
					addMorphBack: morph;
					hResizing: #shrinkWrap;
					vResizing: #shrinkWrap)]
			ifFalse: [SBToggledCode comment: '' active: 1 do: {
				[self useDisplay: (SBExplorer on: anObject)].
				[self useDisplay: (anObject convertedFor: self watchObjectInterface do: #yourself)]}].
		
		clear
			disableLayout: false;
			visible: true.
		
		count contents: (count contents asInteger + 1) asString.
		lastValue := anObject] ensure: [applyingChange := false]
]