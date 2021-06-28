Class {
	#name : #PWBTestRepport,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase',
		'author',
		'numberOfFailures',
		'pathToJunitReportFile'
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

{ #category : #running }
PWBTestRepport >> message [
^'Vous avez ', numberOfFailures  asString ,' test(s) qui ont echoues'
]

{ #category : #running }
PWBTestRepport >> pathToJunitXMLStyle [

	^ ' -xsl:"C:\PBCI_Utilities\junit.xsl"'
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
PWBTestRepport >> report [
	PWBPublisher new
		attachment: pathToJunitReportFile asFileReference;
		author: self author;
		text: self message;
		run
]

{ #category : #running }
PWBTestRepport >> run [
	| xmlResult |
	[ self wait.
	self transformReportToJunitFormat asFileReference exists
		ifFalse: [ self wait ].
	xmlResult := XMLDOMParser
		parse: self transformReportToJunitFormat asFileReference contents.
	numberOfFailures := (xmlResult nodes anyOne
		attributeNodeAt: 'failures') value asInteger.
	numberOfFailures > 0
		ifTrue: [ self report ] ] forkNamed: 'TestReport'
]

{ #category : #running }
PWBTestRepport >> transformReportToJunitFormat [
	| command |
	pathToJunitReportFile := self pathToPBUnitReportFile pathString
		copyReplaceAll: self pathToPBUnitReportFile basenameWithoutExtension
		with: 'junit-report'.
	command := 'java -jar ' , self pathToSaxonTransformer , ' -s:'
		, self pathToPBUnitReportFile pathString , self pathToJunitXMLStyle
		, ' -o:' , pathToJunitReportFile.
	LibC runCommand: command.
	^ pathToJunitReportFile
]

{ #category : #waiting }
PWBTestRepport >> wait [ 
(Duration minutes: 2) asDelay wait.
]