"
I run Izy protect application tests unsing batch command
"
Class {
	#name : #PWBUnitTestsRunner,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase',
		'author',
		'numberOfTests',
		'curentTestObject'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #accessing }
PWBUnitTestsRunner >> author: aString [
	author := aString
]

{ #category : #'as yet unclassified' }
PWBUnitTestsRunner >> basicScriptWthTestSuite: aString [
	| exe liblist |
	liblist := self
		liblist: (self cleanName: curentTestObject parent basename).
	exe := self pathToTarget pathString
		copyReplaceAll: self pathToTarget extension
		with: 'exe'.
	^ exe , ' NOM_BAS=' , self testDatabase
		, ';TYP_TRT=PB_UNIT;EMP_INI=c:\WinNT\;target='
		, self pathToTarget pathString , ';liblist=' , liblist
		, ';testObjectName=' , curentTestObject basenameWithoutExtension
		, ';testsuite=' , aString , ';'
]

{ #category : #running }
PWBUnitTestsRunner >> cleanName: aString [
	^ aString copyReplaceAll: '.src' with: ''
]

{ #category : #accessing }
PWBUnitTestsRunner >> errorsLogFilePath [

]

{ #category : #running }
PWBUnitTestsRunner >> isAllTestExecuted [
	PWBTestResult loadAll size < self numberOfTests
		ifTrue: [ Error
				signal:
					'I have ' , PWBTestResult loadAll size asString , ' units tests executed instead of '
						, self numberOfTests asString  ]
]

{ #category : #running }
PWBUnitTestsRunner >> isNoProtectRunning [
	^ (LibC resultOfCommand: 'tasklist /fi "imagename eq cwm.exe"')
		beginsWith: 'Inform'
]

{ #category : #'as yet unclassified' }
PWBUnitTestsRunner >> liblist: aString [
	^ 'pbunit.pbl,' , aString
]

{ #category : #tests }
PWBUnitTestsRunner >> numberOfTests [
	numberOfTests
		ifNil: [ numberOfTests := PWBTestsFinder runOn: self testObjects ].
	^ numberOfTests
]

{ #category : #running }
PWBUnitTestsRunner >> reportTestResult [
	PWBTestRepport new
		pathToTarget: self pathToTarget;
		author: author;
		run
]

{ #category : #running }
PWBUnitTestsRunner >> run [
	| testObjects iter stop testSuite |
	stop := false.
	iter := 1.
	testSuite := '0'.
	testObjects := self testObjects.
	[ [ stop ]
		whileFalse: [ iter > 1
				ifTrue: [ testSuite := '1' ].
			self isNoProtectRunning
				ifTrue: [ curentTestObject := testObjects at: iter.
					LibC runCommand: (self basicScriptWthTestSuite: testSuite).
					iter := iter + 1 ].
			iter = testObjects size
				ifTrue: [ stop := true.
					self isAllTestExecuted.
					self reportTestResult ] ] ] forkNamed: 'PWBCI_Test'
]

{ #category : #running }
PWBUnitTestsRunner >> testDatabase [

	^ testDatabase
]

{ #category : #running }
PWBUnitTestsRunner >> testDatabase: aString [

	testDatabase := aString
]

{ #category : #tests }
PWBUnitTestsRunner >> testObjects [
	| libs |
	libs := (self pathToTarget parent / 'ws_objects') children
		select: [ :dir | dir basename matchesRegexIgnoringCase: 'pbunit_.*' ].
	^ (libs flatCollect: #files)
		select:
			[ :file | file basenameWithoutExtension matchesRegex: 'test_.*|.*_test' ]
]
