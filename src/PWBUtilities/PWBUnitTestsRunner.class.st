"
I run Izy protect application tests unsing batch command
"
Class {
	#name : #PWBUnitTestsRunner,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase',
		'author',
		'delay'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #accessing }
PWBUnitTestsRunner >> author: aString [
	author := aString
]

{ #category : #'as yet unclassified' }
PWBUnitTestsRunner >> basicScript [
	| exe |
	exe := self pathToTarget pathString
		copyReplaceAll: self pathToTarget extension
		with: 'exe'.
	^ 'start ' , exe , ' NOM_BAS=' , self testDatabase
		, ';TYP_TRT=PB_UNIT;EMP_INI=c:\WinNT\;target='
		, self pathToTarget pathString , ';liblist='
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

{ #category : #cleaning }
PWBUnitTestsRunner >> clean [
	(self pathToTarget parent / 'pbunit-results.xml') ensureDelete.
	(self pathToTarget parent / 'pbunit-results.txt') ensureDelete.
	(self pathToTarget parent / 'junit-report.xml') ensureDelete
]

{ #category : #accessing }
PWBUnitTestsRunner >> errorsLogFilePath [

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

{ #category : #running }
PWBUnitTestsRunner >> pathToPBUnitReportFile [

	^ (self pathToTarget parent / 'pbunit-results.xml') pathString
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
	self clean.
	testLibs := self testLibraries.
	[ [ stop ]
		whileFalse: [ iter > 1
				ifTrue: [ testSuite := '1' ].
			self isNoProtectRunning
				ifTrue: [ LibC
						runCommand:
							(self
								basicScript: (self liblist: (testLibs at: iter) basename)
								testSuite: testSuite).
					iter := iter + 1 ]
				ifFalse: [ self wait ].
			iter = testLibs size
				ifTrue: [ stop := true.
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
	^ self pathToTarget parent children
		select: [ :file | file basename matchesRegexIgnoringCase: 'pbunit_.*.pbl' ]
]

{ #category : #waiting }
PWBUnitTestsRunner >> wait [
	delay > 3
		ifTrue: [ LibC runCommand: 'taskkill /f /im cwm.exe' ]
		ifFalse: [ delay := delay + 1.
			(Duration minutes: 1) asDelay wait ]
]
