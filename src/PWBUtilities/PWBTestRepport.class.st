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
	^ 'Vous avez ' , PWBTestResult failingTests size asString
		, ' test(s) qui ont echoues' , String crlf
		, pathToHtmlReportFile asFileReference contents
]

{ #category : #running }
PWBTestRepport >> run [
	PWBPublisher new
		attachment: pathToHtmlReportFile asFileReference;
		author: self author;
		text: self message;
		subject: 'Rapport de test PBUnit';
		run
	
]

{ #category : #waiting }
PWBTestRepport >> wait [
	timeout := timeout + 2.
	(Duration minutes: 2) asDelay wait
]
