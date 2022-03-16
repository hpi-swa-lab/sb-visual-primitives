Class {
	#name : #SBGrammarObject,
	#superclass : #Object,
	#instVars : [
		'type',
		'members',
		'content',
		'objectName',
		'objectValue'
	],
	#category : #'Sandblocks-DomainBlocks-Fixtures'
}

{ #category : #'as yet unclassified' }
SBGrammarObject class >> domainBlockMapping [

	^ {
		#shape vpConstant: (CircleMorph new color: Color white).
		#identityLabelPosition vpConstant: #bottomCenterLabel.
		#topLeftLabel vpSelectFrom: {'SEQ'. 'REPEAT'. 'REPEAT1'. 'SYMBOL'} for: #type.
		#innerLabel vpStringFor: #objectName.
		
		SBPropertyMappingChildren
			getter: [:object | object members ifNil: [{object content} asOrderedCollection]]
			setter: [:object :patternChildren |
				patternChildren size < 1 ifTrue: [] ifFalse: [
					patternChildren size > 1
						ifTrue: [object members: patternChildren]
						ifFalse: [object content: patternChildren first]]]}
]

{ #category : #'as yet unclassified' }
SBGrammarObject class >> fromJsonObject: aJsonObject [

	SBGrammarObject new
		type: (aJsonObject at: 'type');
		members: ((aJsonObject at: 'members') do: [:member | SBGrammarObject fromJsonObject: member]);
		content: (SBGrammarObject fromJsonObject: (aJsonObject at: 'content'));
		objectName: (aJsonObject at: 'name');
		objectValue: (aJsonObject at: 'value')
]

{ #category : #accessing }
SBGrammarObject >> content [

	^ content
]

{ #category : #accessing }
SBGrammarObject >> content: anObject [

	content := anObject
]

{ #category : #'as yet unclassified' }
SBGrammarObject >> exampleGrammarRuleMergeWithExpression: aGrammarObject [

	| variableType |
	self
		example: [SBGrammarObject new]
		args: [
			{
				(SBGrammarObject new
					objectName: '';
					type: 'SEQ';
					members: {
						SBGrammarObject new
							objectName: 'a';
							type: 'SYMBOL';
							members: {}.
						SBGrammarObject new
							objectName: '';
							type: 'REPEAT';
							members: {
								SBGrammarObject new
									objectName: 'a';
									type: 'SYMBOL';
									members: {}}}) showAsDomainBlock}]
		label: 'example'.
	"We can also use variables to define the bindings"
	variableType := 'SEQ'.
	^ (SBTransformation
		input: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #a}
				expressionDict: {#topLeftLabel -> [variableType]}
				patternChildren: {
					SBBindingPattern
						bindingDict: {#identity -> #b}
						expressionDict: {#topLeftLabel -> ['SYMBOL']}
						visualizingClass: SBGrammarObject.
					SBBindingPattern
						bindingDict: {#identity -> #c}
						expressionDict: {#topLeftLabel -> ['REPEAT']}
						patternChildren: {
							SBBindingPattern
								bindingDict: {#identity -> #d}
								expressionDict: {#topLeftLabel -> ['SYMBOL']}
								visualizingClass: SBGrammarObject}
						visualizingClass: SBGrammarObject}
				visualizingClass: SBGrammarObject.
			SBConstraintPattern constraint: [:bindings | (bindings at: #b) objectName = (bindings at: #d) objectName]})
		output: (SBGroupPattern patterns: {
			SBBindingPattern
				bindingDict: {#identity -> #c}
				expressionDict: {#topLeftLabel -> ['REPEAT1']}
				patternChildren: {SBBindingPattern bindingDict: {#identity -> #b} visualizingClass: SBGrammarObject}
				visualizingClass: SBGrammarObject})
		strategy: (Dictionary new
			add: #explicitRootMatching -> false;
			add: #explicitChildrenMatching -> true;
			yourself)
		visualizePatternsAs: SBGrammarObject
		replaceCount: Float infinity) value: aGrammarObject
]

{ #category : #'as yet unclassified' }
SBGrammarObject >> initialize [

	super initialize.
	members := nil.
	content := nil.
	objectName := nil.
	objectValue := ''.
	type := ''
]

{ #category : #accessing }
SBGrammarObject >> members [

	^ members
]

{ #category : #accessing }
SBGrammarObject >> members: anArray [

	members := anArray
]

{ #category : #accessing }
SBGrammarObject >> objectName [

	^ objectName
]

{ #category : #accessing }
SBGrammarObject >> objectName: aString [

	objectName := aString
]

{ #category : #accessing }
SBGrammarObject >> objectValue [

	^ objectValue
]

{ #category : #accessing }
SBGrammarObject >> objectValue: aString [

	objectValue := aString
]

{ #category : #accessing }
SBGrammarObject >> type [

	^ type
]

{ #category : #accessing }
SBGrammarObject >> type: aString [

	type := aString
]

{ #category : #accessing }
SBGrammarObject >> writeSourceOn: aStream [

	aStream
		nextPutAll: self className;
		nextPutAll: ' new objectName:';
		store: self objectName;
		nextPutAll: '; type: ';
		store: self type.
	self members ifNotNil: [
		aStream nextPutAll: '; members: {'.
		self members
			do: [:member | member writeSourceOn: aStream]
			separatedBy: [aStream nextPut: $.].
		aStream nextPut: $}].
	self content ifNotNil: [
		aStream nextPutAll: '; content: ('.
		self content writeSourceOn: aStream.
		aStream nextPut: $)]
]
