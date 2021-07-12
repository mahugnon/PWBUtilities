"
I responsable for creating a report for last test result
"
Class {
	#name : #PWBTestRepport,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase',
		'author',
		'numberOfFailures',
		'timeout',
		'reportStyle',
		'pathToJUnitReportFile',
		'pathToHtmlReportFile'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #accessing }
PWBTestRepport >> author [

	^ author
]

{ #category : #accessing }
PWBTestRepport >> author: anObject [

	author := anObject
]

{ #category : #accessing }
PWBTestRepport >> errorsLogFilePath [

	
]

{ #category : #initialization }
PWBTestRepport >> initialize [
	super initialize.
	timeout := 0.
	reportStyle :='junit'
]

{ #category : #running }
PWBTestRepport >> message [
	^ 'Vous avez ' , numberOfFailures asString
		, ' test(s) qui ont echoues' , String crlf
		, pathToHtmlReportFile asFileReference contents
]

{ #category : #running }
PWBTestRepport >> parseReport [
	[ self transformReport ]
		on: FileDoesNotExistException
		do: [ timeout < 6
				ifTrue: [ self wait.
					self parseReport ]
				ifFalse:
					[ Exception signal: 'Something went wrong. Tests are not executed' ] ].
	^ XMLDOMParser parse: pathToJUnitReportFile asFileReference contents
]

{ #category : #running }
PWBTestRepport >> pathToPBUnitReportFile [
	^ self pathToTarget parent / 'pbunit-results.xml'
]

{ #category : #running }
PWBTestRepport >> pathToSaxonTransformer [

	^ 'c:\saxon\saxon.jar '
]

{ #category : #running }
PWBTestRepport >> pathToXMLStyle [

	^ '"C:\PBCI_Utilities\',reportStyle ,'.xsl"'
]

{ #category : #running }
PWBTestRepport >> report [
	PWBPublisher new
		attachment: pathToHtmlReportFile asFileReference;
		author: self author;
		text: self message;
		subject: 'Rapport de test PBUnit';
		run
]

{ #category : #running }
PWBTestRepport >> run [
	| xmlResult |
	[ xmlResult := self parseReport.
	numberOfFailures := (xmlResult nodes anyOne
		attributeNodeAt: 'failures') value asInteger.
	numberOfFailures > 0
		ifTrue: [ self report ] ] forkNamed: 'TestReport'
]

{ #category : #running }
PWBTestRepport >> transformReport [
	| command |
	pathToJUnitReportFile := self pathToPBUnitReportFile pathString
		copyReplaceAll: self pathToPBUnitReportFile basenameWithoutExtension
		with: 'junit-report'.
	command := 'java -jar ' , self pathToSaxonTransformer , ' -s:'
		, self pathToPBUnitReportFile pathString , ' -xsl:'
		, self pathToXMLStyle , ' -o:' , pathToJUnitReportFile.
	LibC runCommand: command.
	pathToHtmlReportFile := self pathToTarget parent
		/ 'pbunit-results.html'
]

{ #category : #waiting }
PWBTestRepport >> wait [
	timeout := timeout + 2.
	(Duration minutes: 2) asDelay wait
]
