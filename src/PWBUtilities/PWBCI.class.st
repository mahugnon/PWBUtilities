Class {
	#name : #PWBCI,
	#superclass : #Object,
	#instVars : [
		'repoUrl',
		'repoLocal',
		'targetName',
		'commitMessage',
		'svnHeadAuthor'
	],
	#category : #'PWBUtilities-Core'
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

{ #category : #accessing }
PWBCI >> getSvnInfo [

	| info |
	info := [ 
	        (XMLDOMParser parse:
		         (LibC resultOfCommand:
			          'svn log ' , repoUrl , ' --limit 1 --xml')) document 
		        descendantElementsDetect: [ :xmlElt | xmlElt name = 'log' ] ]
		        on: XMLParserException
		        do: [  ].
	info ifNil: [ ^ self ].
	commitMessage := (info firstElement attributeNodeAt: 'message') value
		                 trim.
	svnHeadAuthor := (info firstElement descendantElementsDetect: [ 
		                  :xmlElt | xmlElt name = 'author' ]) nodes anyOne
		                 asString
]

{ #category : #initialization }
PWBCI >> initialize [

	super initialize.
	repoLocal := 'C:\Users\h.houekpetodji\Documents\EspaceDeTravail\Local_repository'
		             asFileReference
]

{ #category : #running }
PWBCI >> isPBLCommit [

	^ (commitMessage copyReplaceAll: String space with: '')
	  = '00000:commitpbl'
]

{ #category : #accessing }
PWBCI >> job [

	[ 
	[ true ] whileTrue: [ 
		self run.
		(Duration days: 1) asDelay wait ] ] forkNamed:
		self repoName , '_TestRunner'
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
PWBCI >> reportTestResult [

	PWBTestRepport new
		pathToTarget: self pathToTarget;
		author: svnHeadAuthor;
		run
]

{ #category : #running }
PWBCI >> run [

	self getSvnInfo.
"	self isPBLCommit ifFalse: [ ^ self ]."
	self loadLastChanges.
	self refreshPBLs.
	self runUnitTests.
	self reportTestResult
]

{ #category : #running }
PWBCI >> runUnitTests [

	PWBUnitTestsRunner new
		testDatabase: 'CIM999NC';
		pathToTarget: self pathToTarget;
		run
]

{ #category : #'as yet unclassified' }
PWBCI >> svnCheckout [

	LibC resultOfCommand: 'start svn checkout ' , self repoUrl , String space
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
