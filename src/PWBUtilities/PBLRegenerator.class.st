"
I refresh PBLs given a Powerbuilder project path.  You should feed me with a path to a .pbt file .
I suppose that orcascript 17 is installed. If not you should change the  orcascript runner.
"
Class {
	#name : #PBLRegenerator,
	#superclass : #Object,
	#instVars : [
		'pathToTarget',
		'runner'
	],
	#category : #'PWBUtilities-PBLRegenerator'
}

{ #category : #running }
PBLRegenerator class >> runOn: aPathToPowerbuilderProjectTargetString [
	^ self new
		pathToTarget: aPathToPowerbuilderProjectTargetString;
		runOcascript
]

{ #category : #'as yet unclassified' }
PBLRegenerator >> cleanUpPBg [
	self powerbuilderProjetDirectory files
		select: [ :file | file extension = 'pbg' ]
		thenDo: #delete
]

{ #category : #api }
PBLRegenerator >> ensureCreateOrcascriptFile [
	| file |
	file := self powerbuilderProjetDirectory / 'refreshPbls.orca'.
	file exists
		ifFalse: [ file writeStreamDo: [ :stream | stream << self orcascript ] ].
	^ file
]

{ #category : #'as yet unclassified' }
PBLRegenerator >> ensurePBGFilesAreWellSet [
self cleanUpPBg .
PBGRefactor runOn: self powerbuilderProjetDirectory 
]

{ #category : #initialization }
PBLRegenerator >> initialize [ 
super initialize .
runner := 'orcascr170'
]

{ #category : #accessing }
PBLRegenerator >> logFilePath [
	^ self powerbuilderProjetDirectory / 'errors.log'
]

{ #category : #api }
PBLRegenerator >> orcascript [
	^ 'start session',String lf,
'set debug true' ,String lf,
'scc set connect property logfile "' , self logFilePath pathString
		,
			'"',String lf,
'scc connect offline',String lf,
'scc set target "' , pathToTarget pathString
		,
			'" importonly',String lf,
'scc refresh target 3pass',String lf,
'scc close',String lf,
'end session'
]

{ #category : #accessing }
PBLRegenerator >> pathToTarget [
	^ pathToTarget
]

{ #category : #accessing }
PBLRegenerator >> pathToTarget: anObject [
	pathToTarget := anObject asFileReference
]

{ #category : #'as yet unclassified' }
PBLRegenerator >> powerbuilderProjetDirectory [
	^ pathToTarget parent
]

{ #category : #'as yet unclassified' }
PBLRegenerator >> runOcascript [
	| command |
	"Orcascript will put error log in the log file"
	self ensurePBGFilesAreWellSet.
	command := self runner , String space
		, self ensureCreateOrcascriptFile pathString.
	LibC runCommand: command.
	self cleanUpPBg.
	^ self logFilePath
		readStreamEncoded: 'utf16le'
		do: [ :stream | ^ stream contents ]
]

{ #category : #'as yet unclassified' }
PBLRegenerator >> runner [
	^ runner
]

{ #category : #accessing }
PBLRegenerator >> runner: anObject [
	runner := anObject
]
