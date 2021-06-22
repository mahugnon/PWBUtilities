"
I refresh PBLs given a Powerbuilder project path.  You should feed me with a path to a .pbt file .
I suppose that orcascript 17 is installed. If not you should change the  orcascript runner.
"
Class {
	#name : #PBLRegenerator,
	#superclass : #PWBAbstractCommand,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #api }
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
		ifFalse: [ file writeStreamDo: [ :stream | stream << self script ] ].
	^ file
]

{ #category : #api }
PBLRegenerator >> ensurePBGFilesAreWellSet [
self cleanUpPBg .
PBGRefactor runOn: self powerbuilderProjetDirectory 
]

{ #category : #accessing }
PBLRegenerator >> errorsLogFilePath [
	^ self powerbuilderProjetDirectory / 'errors.log'
]

{ #category : #initialization }
PBLRegenerator >> initialize [ 
super initialize .
runner := 'orcascr170'
]

{ #category : #running }
PBLRegenerator >> run [
	| command |
	"Orcascript will put error log in the log file"
	self ensurePBGFilesAreWellSet.
	command := self runner , String space
		, self ensureCreateOrcascriptFile pathString.
	LibC runCommand: command.
	self cleanUpPBg.
	^ self errorsLogFilePath
		readStreamEncoded: 'utf16le'
		do: [ :stream | ^ stream contents ]
]

{ #category : #api }
PBLRegenerator >> script [
	^ 'start session',String lf,
'set debug true' ,String lf,
'scc set connect property logfile "' , self errorsLogFilePath pathString
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
