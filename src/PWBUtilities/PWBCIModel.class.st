"
I'm responsible  for executing PWBCI commands
"
Class {
	#name : #PWBCIModel,
	#superclass : #Object,
	#classInstVars : [
		'localDirectory'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #'class initialization' }
PWBCIModel class >> initialize [
	localDirectory := 'C:\Users\h.houekpetodji\Documents\EspaceDeTravail\Local_repository'
		asFileReference
]

{ #category : #accessing }
PWBCIModel class >> localDirectory [
	^ localDirectory
]

{ #category : #accessing }
PWBCIModel class >> localDirectory: anObject [
	anObject ifNotNil: [ localDirectory := anObject ]
]

{ #category : #accessing }
PWBCIModel class >> repoUrl: aString [

	self new
		repoUrl: aString;
		run
]

{ #category : #run }
PWBCIModel class >> repoUrl: aRepoStringUrl targetName: aTargetName [

	self new
		repoUrl: aRepoStringUrl;
		targetName: aTargetName;
		run
]

{ #category : #'as yet unclassified' }
PWBCIModel class >> runTestsExample [
	<script>
	PWBUnitTestsRunner new
		testDatabase: 'CIM999NC';
		pathToTarget:
			'C:\Users\h.houekpetodji\Documents\EspaceDeTravail\Local_repository\cwm\cwm.pbt'
				asFileReference;
		run
]

{ #category : #action }
PWBCIModel >> runTests [
	PWBTestRunnerLauncherModel new run
]

{ #category : #action }
PWBCIModel >> runViolations [
	^ PWBViolationLauncher new openWithSpec
]
