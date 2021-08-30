"
I run Izy protect application tests unsing batch command
"
Class {
	#name : #PWBUnitTestsRunner,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase',
		'author'
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
	| testLibs |
	self clean.
	testLibs := self testLibraries.
	LibC
		runCommand:
			(self
				basicScript: (self liblist: testLibs first basename)
				testSuite: '0').
	2 to: testLibs size do: [ :iter | 
		LibC
			runCommand:
				(self
					basicScript: (self liblist: (testLibs at: iter) basename)
					testSuite: '1') ].
	self reportTestResult
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
	^ self pathToTarget parent directories
		select: [ :dir | dir basename beginsWith: 'pbunit_' ]
]
