"
I'm responsible  for executing PWBCI commands
"
Class {
	#name : #PWBCIModel,
	#superclass : #Object,
	#instVars : [
		'repoUrl',
		'targetName',
		'commitMessage',
		'svnHeadAuthor',
		'svnHead',
		'svnPrev',
		'svnPrevAuthor'
	],
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

{ #category : #running }
PWBCIModel >> buildProject [
	PWBBuilder runOn: self pathToTarget pathString
]

{ #category : #accessing }
PWBCIModel >> getSvnInfo [
	| info |
	info := [ (XMLDOMParser
		parse: (LibC resultOfCommand: 'svn log ' , repoUrl , ' --limit 2 --xml'))
		document descendantElementsDetect: [ :xmlElt | xmlElt name = 'log' ] ]
		on: XMLParserException
		do: [  ].
	info ifNil: [ ^ self ].
	svnHead := (info firstElement attributeNodeAt: 'revision') value
		asInteger.
	svnHeadAuthor := (info firstElement
		descendantElementsDetect: [ :xmlElt | xmlElt name = 'author' ])
		nodes anyOne asString.
	commitMessage := (info firstElement
		descendantElementsDetect: [ :xmlElt | xmlElt name = 'msg' ]) nodes
		anyOne asString.
	svnPrev := (info lastElement attributeNodeAt: 'revision') value
		asInteger.
	svnPrevAuthor := (info lastElement
		descendantElementsDetect: [ :xmlElt | xmlElt name = 'author' ])
		nodes anyOne asString
]

{ #category : #initialization }
PWBCIModel >> initialize [
	super initialize.
	repoUrl := 'https://CIM-SVN.SA-CIM.local/svn/TestCI/'
]

{ #category : #running }
PWBCIModel >> isNewCommit [
	| lastHead |
	lastHead := svnHead.
	self getSvnInfo.
	^ svnHead ~= lastHead
]

{ #category : #running }
PWBCIModel >> isPBLCommit [
	^ commitMessage trim includesSubstring: 'pbl'
]

{ #category : #testing }
PWBCIModel >> isValidLocalDirectory [
	^ self localDirectory isNil
]

{ #category : #initialization }
PWBCIModel >> isValidRepoUrl [
	^ repoUrl beginsWith: 'https://'
]

{ #category : #testing }
PWBCIModel >> isValidTargetName [
	^ targetName endsWith: '.pbt'
]

{ #category : #running }
PWBCIModel >> loadLastChanges [

	self repoLocalPath hasChildren
		ifTrue: [ self svnUpdate ]
		ifFalse: [ self svnCheckout.
			self buildProject ]
]

{ #category : #accessing }
PWBCIModel >> localDirectory [
	^ self class localDirectory
]

{ #category : #accessing }
PWBCIModel >> localDirectory: anObject [
	self class localDirectory: anObject
]

{ #category : #running }
PWBCIModel >> pathToTarget [

	^ self repoLocalPath / self targetName
]

{ #category : #running }
PWBCIModel >> refreshPBLs [

	PBLRegenerator runOn: self pathToTarget
]

{ #category : #running }
PWBCIModel >> repoLocalPath [

	| path |
	path := self localDirectory / self repoName.
	path exists ifFalse: [ path ensureCreateDirectory ].
	^ path
]

{ #category : #running }
PWBCIModel >> repoName [

	"https://CIM-SVN.SA-CIM.local/svn/TestCI>>TestCI"

	^ ('/' split: repoUrl) last
]

{ #category : #accessing }
PWBCIModel >> repoUrl [

	^ repoUrl
]

{ #category : #accessing }
PWBCIModel >> repoUrl: anObject [

	repoUrl := anObject
]

{ #category : #running }
PWBCIModel >> run [
	[ [ true ]
		whileTrue: [ self isNewCommit
				ifTrue: [ self runViolations.
					"self runUnitTests" ].
			(Duration minutes: 5) asDelay wait ] ]
		forkNamed: 'PWBCI_' , self repoName
]

{ #category : #running }
PWBCIModel >> runUnitTests [
	"	self isPBLCommit
		ifFalse: [ ^ self ]."

	self loadLastChanges.
	"self refreshPBLs."
	PWBUnitTestsRunner new
		testDatabase: 'CIM999NC';
		pathToTarget: self pathToTarget;
		author: svnHeadAuthor;
		run
]

{ #category : #running }
PWBCIModel >> runViolations [
	PWBViolationsRunner new
		commander: self;
		repoUrl: repoUrl;
		svnHead: svnHead;
		svnPrev: svnPrev;
		svnHeadAuthor: svnHeadAuthor;
		svnPrevAuthor: svnPrevAuthor;
		run
]

{ #category : #running }
PWBCIModel >> svnCheckout [

	LibC resultOfCommand: 'start svn checkout ' , self repoUrl , String space
		, self repoLocalPath pathString
]

{ #category : #running }
PWBCIModel >> svnUpdate [

	LibC runCommand: 'svn update --accept mc' , self repoLocalPath pathString
]

{ #category : #running }
PWBCIModel >> targetName [

	^ targetName
]

{ #category : #running }
PWBCIModel >> targetName: aString [

	targetName := aString
]

{ #category : #accessing }
PWBCIModel >> testJob [
	[ [ true ]
		whileTrue: [ self isNewCommit
				ifTrue: [ self runUnitTests ].
			(Duration minutes: 5) asDelay wait ] ]
		forkNamed: 'PWBCI_' , self repoName
]

{ #category : #accessing }
PWBCIModel >> violationJob [

	[ 
	[ true ] whileTrue: [ 
		self run.
		(Duration days: 1) asDelay wait ] ] forkNamed:
		self repoName , '_TestRunner'
]
