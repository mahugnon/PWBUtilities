Class {
	#name : #PWBViolationsRunner,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'svnHeadAuthor',
		'svnPrevAuthor',
		'svnPrev',
		'svnHead',
		'repoUrl',
		'commander'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #cleanup }
PWBViolationsRunner >> cleanUp [
	(FileSystem workingDirectory / ('svnPrev' , self repoName))
		ensureDeleteAll.
		(FileSystem workingDirectory / ('svnHead' , self repoName))
		ensureDeleteAll.
		
]

{ #category : #accessing }
PWBViolationsRunner >> commander: anObject [
	commander := anObject
]

{ #category : #'as yet unclassified' }
PWBViolationsRunner >> diffFilesUrls [
	| diff |
	diff := LibC
		resultOfCommand:
			'svn diff -r ' , svnPrev asString , ':' , svnHead asString
				, String space , repoUrl , ' --summarize'.
	^ diff lines asOrderedCollection
		reject: [ :line | 
			(line beginsWith: 'D')
				or:
					[ {'.pbl' . '.pbd' . '.pbg' . 'pbt' . '.srd' . '.sra' . '.opt' . '.exe'.
					'.log'} anySatisfy: [ :extension | line endsWith: extension ] ] ]
		thenCollect: [ :e | e copyFrom: 9 to: e size ]
]

{ #category : #'as yet unclassified' }
PWBViolationsRunner >> downloadDiffFilesForHeadAndPrev [
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
PWBViolationsRunner >> downloadFiles: diffFiles rev: anInteger dest: aString [
	diffFiles
		do: [ :file | 
			| command |
			command := 'svn export -r ' , anInteger asString , String space
				, file , String space , aString.
			LibC resultOfCommand: command ]
]

{ #category : #'as yet unclassified' }
PWBViolationsRunner >> ensureCreateDirStructure: aString [
	| dest |
	(FileSystem workingDirectory / aString) ensureDeleteAll.
	(FileSystem workingDirectory / aString) ensureCreateDirectory.
	dest := FileSystem workingDirectory / aString / 'lib'.
	^ dest ensureCreateDirectory
]

{ #category : #accessing }
PWBViolationsRunner >> errorsLogFilePath [

]

{ #category : #accessing }
PWBViolationsRunner >> repoName [

	"https://CIM-SVN.SA-CIM.local/svn/TestCI>>TestCI"

	^ ('/' split: repoUrl) last
]

{ #category : #accessing }
PWBViolationsRunner >> repoUrl: anObject [
	repoUrl := anObject
]

{ #category : #running }
PWBViolationsRunner >> run [
	self downloadDiffFilesForHeadAndPrev.
	(PWBSVNViolationsReporter
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
		run.
	self cleanUp
]

{ #category : #accessing }
PWBViolationsRunner >> svnHead: anObject [
	svnHead := anObject
]

{ #category : #accessing }
PWBViolationsRunner >> svnHeadAuthor: anObject [
	svnHeadAuthor := anObject
]

{ #category : #accessing }
PWBViolationsRunner >> svnPrev: anObject [
	svnPrev := anObject
]

{ #category : #accessing }
PWBViolationsRunner >> svnPrevAuthor: anObject [
	svnPrevAuthor := anObject
]
