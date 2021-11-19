Class {
	#name : #SBVPPipelineTest,
	#superclass : #Object,
	#category : #'Sandblocks-VisualPrimitives'
}

{ #category : #'as yet unclassified' }
SBVPPipelineTest >> examplePipeline [

	| input output world visualizeData case |
	world := SBEditor open.
	input := [ | root n1 n2 |
		root := SBVPDummyNode new.
		root key: 'Carl-Friedrich'.
		n1 := SBVPDummyNode new.
		n1 key: 'n1'.
		n2 := SBVPDummyNode new.
		n2 key: 'n2'.
		root
			left: n1;
			right: n2.
		root].
	visualizeData := [:inputStuff | | inputContainer inputCanvas |
		inputContainer := TransformMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addMorph: (inputCanvas := SBSandboxPasteUpMorph new
				hResizing: #shrinkWrap;
				vResizing: #shrinkWrap;
				when: #reportError send: #reportError: to: self).
		world openMorphInView: inputContainer.
		
		inputStuff value asVisualPrimitiveIn: inputCanvas].
	
	visualizeData value: input.
	
	case := SBVPCase
		input: (SBVPGroupPattern patterns: {
			SBVPBindingPattern
				label: 1
				connections: {SBVPBindingPattern label: 2 connections: {}. SBVPBindingPattern label: 3 connections: {}}.
			SBVPConstraintPattern constraint: [:a :b :c | true]})
		output: (SBVPBindingPattern
			label: 1
			connections: {SBVPBindingPattern label: 3 connections: {}. SBVPBindingPattern label: 2 connections: {}}).
	
	output := case value: input.
	visualizeData value: output
]
