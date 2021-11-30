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
		'pathToHtmlReportFile',
		'message'
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

{ #category : #initialization }
PWBTestRepport >> initialize [
	super initialize.
	timeout := 0.
	reportStyle :='junit'
]

{ #category : #accessing }
PWBTestRepport >> logFilePath [

	
]

{ #category : #running }
PWBTestRepport >> message [
	message
		ifEmpty: [ message := 'Vous avez ' , PWBTestResult failingTests size asString
				, ' test(s) qui ont echoues' , String crlf ].
	^ message
]

{ #category : #accessing }
PWBTestRepport >> message: aString [ 
	message := aString
]

{ #category : #running }
PWBTestRepport >> run [
	PWBPublisher new
		text: self message;
		subject: 'Rapport de test PBUnit';
		run
]

{ #category : #waiting }
PWBTestRepport >> wait [
	timeout := timeout + 2.
	(Duration minutes: 2) asDelay wait
]
