Class {
	#name : #PWBCI,
	#superclass : #Object,
	#instVars : [
		'repoUrl',
		'repoLocal',
		'targetName'
	],
	#category : #PWBUtilities
}

{ #category : #accessing }
PWBCI class >> repoUrl: aString [

	self new
		repoUrl: aString;
		run
]

{ #category : #run }
PWBCI class >> repoUrl: aRepoStringUrl targetName: aTargetName [

	self new
		repoUrl: aRepoStringUrl;
		targetName: aTargetName;
		run
]

{ #category : #initialization }
PWBCI >> initialize [

	super initialize.
	repoLocal := 'C:\Users\h.houekpetodji\Documents\EspaceDeTravail\Local_repository'
		             asFileReference
]

{ #category : #'as yet unclassified' }
PWBCI >> loadLastChanges [

	self repoLocalPath hasChildren
		ifTrue: [ self svnUpdate ]
		ifFalse: [ self svnCheckout ]
]

{ #category : #running }
PWBCI >> pathToTarget [

	^ self repoLocalPath / self targetName
]

{ #category : #running }
PWBCI >> refreshPBLs [

	PBLRegenerator runOn: self pathToTarget
]

{ #category : #accessing }
PWBCI >> repoLocal [

	^ repoLocal
]

{ #category : #accessing }
PWBCI >> repoLocal: anObject [

	repoLocal := anObject
]

{ #category : #'as yet unclassified' }
PWBCI >> repoLocalPath [

	| path |
	path := self repoLocal / self repoName.
	path exists ifFalse: [ path ensureCreateDirectory ].
	^ path
]

{ #category : #'as yet unclassified' }
PWBCI >> repoName [

	"https://CIM-SVN.SA-CIM.local/svn/TestCI>>TestCI"

	^ ('/' split: repoUrl) last
]

{ #category : #accessing }
PWBCI >> repoUrl [

	^ repoUrl
]

{ #category : #accessing }
PWBCI >> repoUrl: anObject [

	repoUrl := anObject
]

{ #category : #running }
PWBCI >> run [

	self loadLastChanges.
	self refreshPBLs.
	self runUnitTests
]

{ #category : #running }
PWBCI >> runUnitTests [

	PBUnitTestsRunner new
		testDatabase: 'CIM125';
		pathToTarget: self pathToTarget;
		run
]

{ #category : #'as yet unclassified' }
PWBCI >> svnCheckout [

	LibC runCommand: 'start svn checkout ' , self repoUrl , String space
		, self repoLocalPath pathString
]

{ #category : #'as yet unclassified' }
PWBCI >> svnUpdate [

	LibC runCommand: 'svn update ' , self repoLocalPath pathString
]

{ #category : #running }
PWBCI >> targetName [

	^ targetName
]

{ #category : #running }
PWBCI >> targetName: aString [

	targetName := aString
]
