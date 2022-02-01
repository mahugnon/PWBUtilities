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
		'curentTestObject',
		'stop',
		'logFile'
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

{ #category : #running }
PWBUnitTestsRunner >> isDeadProtectRunning [
	^ (LibC resultOfCommand: 'tasklist /fi "imagename eq cwm.exe"') trim
		lines size = 3
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

{ #category : #accessing }
PWBUnitTestsRunner >> logFilePath [
	^ 'E:\CITest.log' asFileReference
]

{ #category : #tests }
PWBUnitTestsRunner >> numberOfTests [
	numberOfTests
		ifNil: [ numberOfTests := PWBTestsFinder runOn: self testObjects ].
	^ numberOfTests
]

{ #category : #running }
PWBUnitTestsRunner >> reportTestResult [
	PWBTestRepporter
		nonExecuted: self numberOfTests - PWBTestResult loadAll size
]

{ #category : #running }
PWBUnitTestsRunner >> run [
	| testObjects iter testSuite |
	stop := false.
	iter := 0.
	self logFilePath ensureDelete.
	testSuite := '0'.
	testObjects := self testObjects.
	[ stop ]
		whileFalse: [ iter := iter + 1.
			iter > 1
				ifTrue: [ testSuite := '1' ].
			self isNoProtectRunning
				ifTrue: [ curentTestObject := testObjects at: iter.
					self trace: iter asString , '/' , testObjects size asString.
					LibC runCommand: (self basicScriptWthTestSuite: testSuite) ].
			iter = testObjects size
				ifTrue: [ stop := true.
					self reportTestResult ] ]
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

{ #category : #running }
PWBUnitTestsRunner >> trace: aString [
	self logFilePath
		writeStreamDo: [ :stream | 
			stream
				setToEnd;
				<< aString;
				space;
				<< curentTestObject basenameWithoutExtension;
				cr ]
]

{ #category : #running }
PWBUnitTestsRunner >> watchDeadProtect [
	| runningObject |
	self deprecated: 'Not sure if it solve the problem it suppose to solve'.
	[ [ stop ]
		whileFalse: [ runningObject := curentTestObject.
			(Duration hours: 1) asDelay wait.
			(runningObject = curentTestObject
				and: [ self isDeadProtectRunning ])
				ifTrue: [ 
					LibC runCommand: 'taskkill /f /im cwm.exe' ] ] ]
		forkNamed: 'Timer'
]
