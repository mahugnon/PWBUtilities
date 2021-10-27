Class {
	#name : #PWBTestRunnerLauncherModel,
	#superclass : #Object,
	#instVars : [
		'targetName',
		'izyProtectPath'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #running }
PWBTestRunnerLauncherModel >> checkoutWsObject [
	LibC
		resultOfCommand:
			'start svn checkout ' , self wsObjectUrl , String space
				, (izyProtectPath / 'ws_objects') pathString
]

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
			self checkoutWsObject.
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

{ #category : #'as yet unclassified' }
PWBTestRunnerLauncherModel >> wsObjectUrl [
	^ 'https://cim-svn.sa-cim.local/svn/IzyProtect_Production/branches/developpement/ws_objects'
]
