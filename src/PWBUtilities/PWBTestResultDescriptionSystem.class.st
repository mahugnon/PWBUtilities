Class {
	#name : #PWBTestResultDescriptionSystem,
	#superclass : #DescriptorSystem,
	#category : #'PWBUtilities-GlopModel'
}

{ #category : #private }
PWBTestResultDescriptionSystem >> allTableNames [
	"Return a list of all the table names that this system uses."
	^#('testresult')
]

{ #category : #private }
PWBTestResultDescriptionSystem >> classModelForTestresult: aClassModel [
	aClassModel newAttributeNamed: #suite_name.
	aClassModel newAttributeNamed: #case_name.
	aClassModel newAttributeNamed: #executed.
	aClassModel newAttributeNamed: #success.
	aClassModel newAttributeNamed: #case_time.
	aClassModel newAttributeNamed: #asserts.
	aClassModel newAttributeNamed: #failure_message.
	aClassModel newAttributeNamed: #stack_trace.
	aClassModel newAttributeNamed: #target_name.
]

{ #category : #private }
PWBTestResultDescriptionSystem >> cleanTableName: aString [
^ (aString  copyReplaceAll: 'PUBLIC.' with:'' ) copyReplaceAll: '"' with: ''
]

{ #category : #private }
PWBTestResultDescriptionSystem >> descriptorForPWBTestResult: aDescriptor [
	| table |
	table := self tableNamed: 'public."testresult"'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #suiteName
		to: (table fieldNamed: 'suite_name').
	(aDescriptor newMapping: DirectMapping)
		from: #caseName
		to: (table fieldNamed: 'case_name').
	(aDescriptor newMapping: DirectMapping)
		from: #executed
		to: (table fieldNamed: 'executed').
	(aDescriptor newMapping: DirectMapping)
		from: #success
		to: (table fieldNamed: 'success').
	(aDescriptor newMapping: DirectMapping)
		from: #caseTime
		to: (table fieldNamed: 'case_time').
	(aDescriptor newMapping: DirectMapping)
		from: #asserts
		to: (table fieldNamed: 'asserts').
	(aDescriptor newMapping: DirectMapping)
		from: #failureMessage
		to: (table fieldNamed: 'failure_message').
	(aDescriptor newMapping: DirectMapping)
		from: #stackTrace
		to: (table fieldNamed: 'stack_trace').
	(aDescriptor newMapping: DirectMapping)
		from: #targetName
		to: (table fieldNamed: 'target_name')
]

{ #category : #private }
PWBTestResultDescriptionSystem >> initializeTable: newTable [
	| initializerName |
	initializerName := ('tableFor' , ( self cleanTableName: 'TESTRESULT') , ':') asSymbol.
	(self respondsTo: initializerName)
		ifTrue: [self perform: initializerName with: newTable]
		ifFalse: [self noTableInitializerFound: newTable].
	newTable postInitializeIn: self.
	self deferentialSetSchema: newTable.
]

{ #category : #private }
PWBTestResultDescriptionSystem >> tableForTESTRESULT: aTable [
	aTable createFieldNamed: 'suite_name' type: (platform varChar: 100).
	aTable createFieldNamed: 'case_name' type: (platform varChar: 100).
	aTable createFieldNamed: 'executed' type: (platform varChar: 100).
	aTable createFieldNamed: 'success' type: (platform varChar: 100).
	aTable createFieldNamed: 'case_time' type: platform double.
	aTable createFieldNamed: 'asserts' type: (platform int4).
	aTable createFieldNamed: 'failure_message' type: (platform varChar: 100).
	aTable createFieldNamed: 'stack_trace' type: (platform varChar: 100).
	aTable createFieldNamed: 'target_name' type: (platform varChar: 100).
	
]
