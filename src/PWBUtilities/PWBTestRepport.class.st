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
	self transformReport.
	^ XMLDOMParser
		parse: self pathToJUnitReportFile asFileReference contents
]

{ #category : #running }
PWBTestRepport >> pathToJUnitReportFile [
	^ self pathToTarget parent / 'junit-report.xml'
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
	[ self pathToPBUnitReportFile exists ]
		whileFalse: [ self wait.
			timeout > 6
				ifTrue: [ Error signal: 'Something went wrong. Tests are not executed' ] ].
	LibC runCommand: self transformationCommand.
	pathToHtmlReportFile := self pathToTarget parent
		/ 'pbunit-results.html'
]

{ #category : #running }
PWBTestRepport >> transformationCommand [
	^ String
		streamContents: [ :stream | 
			stream
				<< 'java';
				space;
				<< '-jar';
				space;
				<< self pathToSaxonTransformer;
				space;
				<< '-s:';
				<< self pathToPBUnitReportFile pathString;
				space;
				<< '-xsl:';
				<< self pathToXMLStyle;
				space;
				<< '-o:';
				<< self pathToJUnitReportFile pathString ]
]

{ #category : #waiting }
PWBTestRepport >> wait [
	timeout := timeout + 2.
	(Duration minutes: 2) asDelay wait
]
