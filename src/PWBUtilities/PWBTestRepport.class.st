"
I responsable for creating a report for last test result
"
Class {
	#name : #PWBTestRepport,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase',
		'numberOfFailures',
		'timeout',
		'reportStyle',
		'message',
		'nonExecuted'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepport class >> accept: aNumber [
	^ self subclassResponsibility
]

{ #category : #visiting }
PWBTestRepport class >> nonExecuted: aNumber [
	self subclasses
		detect: [ :sub | sub accept: aNumber ]
		ifFound: [ :founded | 
			founded new
				nonExecuted: aNumber;
				run ]
		ifNone: [ Exception signal: 'case not found' ]
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
		ifEmpty: [ message := 'Nombre de tests non executer : ' , String cr
				, 'Nombre d''echec : ' , PWBTestResult failingTests size asString
				, String crlf ].
	^ message
]

{ #category : #accessing }
PWBTestRepport >> message: aString [ 
	message := aString
]

{ #category : #accessing }
PWBTestRepport >> nonExecuted: aNumber [
	nonExecuted := aNumber
]

{ #category : #running }
PWBTestRepport >> run [
	PWBPublisher new
		text: self message;
		subject: 'Rapport de test PBUnit';
		run
]
