"
I run Izy protect application tests unsing batch command
"
Class {
	#name : #PWBUnitTestsRunner,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase',
		'author',
		'delay',
		'numberOfTests'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #accessing }
PWBUnitTestsRunner >> author: aString [
	author := aString
]

{ #category : #'as yet unclassified' }
PWBUnitTestsRunner >> basicScript: liblist testSuite: aString [
	| exe |
	exe := self pathToTarget pathString
		copyReplaceAll: self pathToTarget extension
		with: 'exe'.
	^ 'start ' , exe , ' NOM_BAS=' , self testDatabase
		, ';TYP_TRT=PB_UNIT;EMP_INI=c:\WinNT\;target='
		, self pathToTarget pathString , ';liblist=' , liblist
		, ';testsuite=' , aString , ';'
]

{ #category : #running }
PWBUnitTestsRunner >> cleanName: aString [
	^ aString copyReplaceAll: '.src' with: ''
]

{ #category : #accessing }
PWBUnitTestsRunner >> errorsLogFilePath [

]

{ #category : #initialization }
PWBUnitTestsRunner >> initialize [
	super initialize.
	delay := 0
]

{ #category : #running }
PWBUnitTestsRunner >> isAllTestExecuted [
	PWBTestResult loadAll size < self numberOfTests
		ifTrue: [ Error
				signal:
					'I have ' , PWBTestResult loadAll size asString , 'instead of '
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
		ifNil: [ numberOfTests := PWBTestsFinder runOn: self testLibraries ].
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
	| testLibs iter stop testSuite |
	stop := false.
	iter := 1.
	testSuite := '0'.
	testLibs := self testLibraries.
	[ [ stop ]
		whileFalse: [ iter > 1
				ifTrue: [ testSuite := '1' ].
			self isNoProtectRunning
				ifTrue: [ LibC
						runCommand:
							(self
								basicScript: (self liblist: (self cleanName: (testLibs at: iter) basename))
								testSuite: testSuite).
					iter := iter + 1 ]
				ifFalse: [ self wait ].
			iter = testLibs size
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
PWBUnitTestsRunner >> testLibraries [
	^ (self pathToTarget parent / 'ws_objects') children
		select: [ :file | file basename matchesRegexIgnoringCase: 'pbunit_.*' ]
]

{ #category : #waiting }
PWBUnitTestsRunner >> wait [
	delay > 3
		ifTrue: [ LibC runCommand: 'taskkill /f /im cwm.exe' ]
		ifFalse: [ delay := delay + 1.
			(Duration minutes: 1) asDelay wait ]
]
