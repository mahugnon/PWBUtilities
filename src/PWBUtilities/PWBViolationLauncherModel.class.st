Class {
	#name : #PWBViolationLauncherModel,
	#superclass : #Object,
	#instVars : [
		'repoUrl',
		'commitMessage',
		'svnHeadAuthor',
		'svnHead',
		'svnPrev',
		'svnPrevAuthor'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #accessing }
PWBViolationLauncherModel >> getSvnInfo [
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
PWBViolationLauncherModel >> initialize [
	super initialize.
	repoUrl := 'https://CIM-SVN.SA-CIM.local/svn/TestCI/'
]

{ #category : #running }
PWBViolationLauncherModel >> isNewCommit [
	| lastHead |
	lastHead := svnHead.
	self getSvnInfo.
	^ svnHead ~= lastHead
]

{ #category : #initialization }
PWBViolationLauncherModel >> isValidRepoUrl [
	^ repoUrl beginsWith: 'https://'
]

{ #category : #running }
PWBViolationLauncherModel >> repoName [

	"https://CIM-SVN.SA-CIM.local/svn/TestCI>>TestCI"

	^ ('/' split: repoUrl) last
]

{ #category : #accessing }
PWBViolationLauncherModel >> repoUrl [

	^ repoUrl
]

{ #category : #accessing }
PWBViolationLauncherModel >> repoUrl: anObject [

	repoUrl := anObject
]

{ #category : #running }
PWBViolationLauncherModel >> run [
	[ [ true ]
		whileTrue: [ self isNewCommit
				ifTrue: [ self runViolations ].
			(Duration minutes: 5) asDelay wait ] ]
		forkNamed: 'Violation_' , self repoName
]

{ #category : #running }
PWBViolationLauncherModel >> runViolations [
	PWBViolationsRunner new
		commander: self;
		repoUrl: repoUrl;
		svnHead: svnHead;
		svnPrev: svnPrev;
		svnHeadAuthor: svnHeadAuthor;
		svnPrevAuthor: svnPrevAuthor;
		run
]
