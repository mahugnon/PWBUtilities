Class {
	#name : #PWBCIModel,
	#superclass : #Object,
	#instVars : [
		'repoUrl',
		'repoLocal',
		'targetName',
		'commitMessage',
		'svnHeadAuthor',
		'svnHead',
		'svnPrev',
		'svnPrevAuthor'
	],
	#category : #'PWBUtilities-Core'
}

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
PWBCIModel >> cleanUp [
	(FileSystem workingDirectory / ('svnPrev' , self repoName))
		ensureDeleteAll.
		(FileSystem workingDirectory / ('svnHead' , self repoName))
		ensureDeleteAll.
		
]

{ #category : #'as yet unclassified' }
PWBCIModel >> diffFilesUrls [
	| diff |
	diff := LibC
		resultOfCommand:
			'svn diff -r ' , svnPrev asString , ':' , svnHead asString
				, String space , repoUrl , ' --summarize'.
	^ diff lines asOrderedCollection
		reject: [ :line | 
			(line beginsWith: 'D')
				or: [ {'.pbl' . '.pbd' . '.pbg' . 'pbt' . '.srd' . '.sra' . '.opt'.'.exe'}
						anySatisfy: [ :extension | line endsWith: extension ] ] ]
		thenCollect: [ :e | e copyFrom: 9 to: e size ]
]

{ #category : #'as yet unclassified' }
PWBCIModel >> downloadDiffFilesForHeadAndPrev [
	| diffFiles |
	diffFiles := self diffFilesUrls.
	self
		downloadFiles: diffFiles
		rev: svnPrev
		dest: (self ensureCreateDirStructure: 'svnPrev' , self repoName) pathString.
	self
		downloadFiles: diffFiles
		rev: svnHead
		dest: (self ensureCreateDirStructure: 'svnHead' , self repoName) pathString
]

{ #category : #'as yet unclassified' }
PWBCIModel >> downloadFiles: diffFiles rev: anInteger dest: aString [
	diffFiles
		do: [ :file | 
			| command |
			command := 'svn export -r ' , anInteger asString , String space
				, file , String space , aString.
			LibC resultOfCommand: command ]
]

{ #category : #'as yet unclassified' }
PWBCIModel >> ensureCreateDirStructure: aString [
	| dest |
	(FileSystem workingDirectory / aString) ensureDeleteAll.
	(FileSystem workingDirectory / aString) ensureCreateDirectory.
	dest := FileSystem workingDirectory / aString / 'lib'.
	^ dest ensureCreateDirectory
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
	repoLocal := 'C:\Users\h.houekpetodji\Documents\EspaceDeTravail\Local_repository'
		asFileReference.
	repoUrl := 'https://CIM-SVN.SA-CIM.local/svn/TestCI/'
]

{ #category : #running }
PWBCIModel >> isPBLCommit [

	^ (commitMessage copyReplaceAll: String space with: '')
	  = '00000:commitpbl'
]

{ #category : #initialization }
PWBCIModel >> isValidRepoUrl [
	^ repoUrl beginsWith: 'https://'
]

{ #category : #testing }
PWBCIModel >> isValidTargetName [
	^ targetName endsWith: '.pbt'
]

{ #category : #accessing }
PWBCIModel >> job [

	[ 
	[ true ] whileTrue: [ 
		self run.
		(Duration days: 1) asDelay wait ] ] forkNamed:
		self repoName , '_TestRunner'
]

{ #category : #'as yet unclassified' }
PWBCIModel >> loadLastChanges [

	self repoLocalPath hasChildren
		ifTrue: [ self svnUpdate ]
		ifFalse: [ self svnCheckout ]
]

{ #category : #running }
PWBCIModel >> pathToTarget [

	^ self repoLocalPath / self targetName
]

{ #category : #running }
PWBCIModel >> refreshPBLs [

	PBLRegenerator runOn: self pathToTarget
]

{ #category : #accessing }
PWBCIModel >> repoLocal [

	^ repoLocal
]

{ #category : #accessing }
PWBCIModel >> repoLocal: anObject [

	repoLocal := anObject
]

{ #category : #'as yet unclassified' }
PWBCIModel >> repoLocalPath [

	| path |
	path := self repoLocal / self repoName.
	path exists ifFalse: [ path ensureCreateDirectory ].
	^ path
]

{ #category : #'as yet unclassified' }
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
PWBCIModel >> reportTestResult [

	PWBTestRepport new
		pathToTarget: self pathToTarget;
		author: svnHeadAuthor;
		run
]

{ #category : #running }
PWBCIModel >> run [
	| lastHead |
	[ [ true ]
		whileTrue: [ lastHead := svnHead.
			self getSvnInfo.
			svnHead = lastHead
				ifFalse: [ self runViolations ].
			self runUnitTests.
			(Duration minutes: 5) asDelay wait ] ]
		forkNamed: 'PWBCI_' , self repoName
]

{ #category : #running }
PWBCIModel >> runUnitTests [
	self isPBLCommit
		ifFalse: [ ^ self ].
	self loadLastChanges.
	self refreshPBLs.
	PWBUnitTestsRunner new
		testDatabase: 'CIM999NC';
		pathToTarget: self pathToTarget;
		run.
	self reportTestResult
]

{ #category : #'as yet unclassified' }
PWBCIModel >> runViolations [
	self downloadDiffFilesForHeadAndPrev.
	(PWBSVNDiffViolationManager
		prev:
		(ViolationRunner
		importFromFolder: FileSystem workingDirectory / ('svnPrev' , self repoName))
		violations
		head:
		(ViolationRunner
				importFromFolder: FileSystem workingDirectory / ('svnHead' , self repoName))
				violations)
		headAuthor: svnHeadAuthor;
		prevAuthor: svnPrevAuthor;
		repoName: self repoName;
		publishDiff.
	self cleanUp
]

{ #category : #'as yet unclassified' }
PWBCIModel >> svnCheckout [

	LibC resultOfCommand: 'start svn checkout ' , self repoUrl , String space
		, self repoLocalPath pathString
]

{ #category : #'as yet unclassified' }
PWBCIModel >> svnUpdate [

	LibC runCommand: 'svn update ' , self repoLocalPath pathString
]

{ #category : #running }
PWBCIModel >> targetName [

	^ targetName
]

{ #category : #running }
PWBCIModel >> targetName: aString [

	targetName := aString
]
