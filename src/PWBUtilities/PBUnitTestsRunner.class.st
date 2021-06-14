Class {
	#name : #PBUnitTestsRunner,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase'
	],
	#category : #'PWBUtilities-PBLRegenerator'
}

{ #category : #running }
PBUnitTestsRunner >> run [

	| exe command |
	exe := self pathToTarget pathString
		       copyReplaceAll: self pathToTarget extension
		       with: '.exe'.
	command := exe , ' NOM_BAS=' , self testDatabase
	           , ';TYP_TRT=PB_UNIT;EMP_INI=c:\WinNT\;'.
	LibC runCommand: command
]

{ #category : #running }
PBUnitTestsRunner >> testDatabase [

	^ testDatabase
]

{ #category : #running }
PBUnitTestsRunner >> testDatabase: aString [

	testDatabase := aString
]
