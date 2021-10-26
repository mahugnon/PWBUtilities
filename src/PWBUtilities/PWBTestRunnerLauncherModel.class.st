Class {
	#name : #PWBTestRunnerLauncherModel,
	#superclass : #Object,
	#instVars : [
		'targetName',
		'izyProtectPath'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #initialization }
PWBTestRunnerLauncherModel >> initialize [
	izyProtectPath := 'E:\v2017' asFileReference
]

{ #category : #'as yet unclassified' }
PWBTestRunnerLauncherModel >> izProtectCIMV2017 [
	^ 'Z:\Version 2017.01' asFileReference
]

{ #category : #running }
PWBTestRunnerLauncherModel >> pathToTarget [

	^ izyProtectPath / self targetName
]

{ #category : #'as yet unclassified' }
PWBTestRunnerLauncherModel >> recreateIzyProtectPath [
	izyProtectPath ensureDeleteAll.
	izyProtectPath ensureCreateDirectory.
	self izProtectCIMV2017 files
		do: [ :aFile | aFile copyTo: izyProtectPath / aFile basename ]
]

{ #category : #running }
PWBTestRunnerLauncherModel >> run [
	[ [ true ]
		whileTrue: [ self recreateIzyProtectPath.
			self runUnitTests.
			(Duration days: 1) asDelay wait ] ] forkNamed: 'Test Runner'
]

{ #category : #running }
PWBTestRunnerLauncherModel >> runUnitTests [
	PWBUnitTestsRunner new
		testDatabase: 'CIM999NC';
		pathToTarget: self pathToTarget;
		run
]

{ #category : #running }
PWBTestRunnerLauncherModel >> targetName [
	^ 'cwm.pbt'
]
