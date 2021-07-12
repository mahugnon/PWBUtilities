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
	| exe command |
	self clean.
	exe := self pathToTarget pathString
		copyReplaceAll: self pathToTarget extension
		with: 'exe'.
	command := 'start ' , exe , ' NOM_BAS=' , self testDatabase
		, ';TYP_TRT=PB_UNIT;EMP_INI=c:\WinNT\;target=cwm.pbt;project='
		, self pathToTarget parent pathString , ';'.
	LibC runCommand: command.
	self reportTestResult .
	
]

{ #category : #running }
PWBUnitTestsRunner >> testDatabase [

	^ testDatabase
]

{ #category : #running }
PWBUnitTestsRunner >> testDatabase: aString [

	testDatabase := aString
]
