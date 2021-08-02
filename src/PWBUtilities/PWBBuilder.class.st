"
I am a tool to build a powerbuilder project. My runner pbc
"
Class {
	#name : #PWBBuilder,
	#superclass : #PWBAbstractCommand,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #api }
PWBBuilder >> binaryResultName: aBaseNameWithoutExtension [
	^ (self powerbuilderProjetDirectory
		/ (aBaseNameWithoutExtension , '.exe')) pathString
]

{ #category : #running }
PWBBuilder >> errorsLogFilePath [
^ self powerbuilderProjetDirectory / 'deploymentErrors.log'
]

{ #category : #initialization }
PWBBuilder >> initialize [ 
super initialize .
runner := 'pbc170'
]

{ #category : #running }
PWBBuilder >> run [
	| command |
	command := self runner , String space , self script , String space
		, '2>' , String space , self errorsLogFilePath pathString.
	LibC runCommand: command.
	^ self errorsLogFilePath contents lines
]

{ #category : #accessing }
PWBBuilder >> script [ 
^'/d "',
	pathToTarget pathString ,
	'" /o "',
	(self binaryResultName:'cwm'),
	'" /w n /f /m n /x 32 /bg y /p "PowerBuilder Enterprise Series" /cp "Appeon" /de "Appeon Product File" /v "1.0.0.1" /vn "1.0.0.1" /fv "1.0.0.1" /fvn "1.0.0.1" /ge 0 '
]
