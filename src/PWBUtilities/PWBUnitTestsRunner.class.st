Class {
	#name : #PWBUnitTestsRunner,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #accessing }
PWBUnitTestsRunner >> errorsLogFilePath [

]

{ #category : #running }
PWBUnitTestsRunner >> pathToPBUnitReportFile [

	^ (self pathToTarget parent / 'pbunit-results.xml') pathString
]

{ #category : #running }
PWBUnitTestsRunner >> run [

	| exe command |
	exe := self pathToTarget pathString
		       copyReplaceAll: self pathToTarget extension
		       with: 'exe'.
	command := 'start ' , exe , ' NOM_BAS=' , self testDatabase
	           , ';TYP_TRT=PB_UNIT;EMP_INI=c:\WinNT\;target='
	           , self pathToTarget pathString , ';'.
	LibC runCommand: command
]

{ #category : #running }
PWBUnitTestsRunner >> testDatabase [

	^ testDatabase
]

{ #category : #running }
PWBUnitTestsRunner >> testDatabase: aString [

	testDatabase := aString
]
