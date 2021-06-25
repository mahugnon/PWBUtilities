Class {
	#name : #PWBTestRepport,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase',
		'author',
		'numberOfFailures'
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
PWBTestRepport >> recipientList [

	| recipientList authorMail |
	"authorMail := author  , '@sa-cim.fr'."
	recipientList := { 'MahugnonHonore.Houekpetodji@sa-cim.fr'.
	                 'homahugnon@gmail.com' }. "'Jerome.Sudich@sa-cim.fr'.
	                 'fatiha.Djareddir@sa-cim.fr'."
	^ recipientList
]

{ #category : #running }
PWBTestRepport >> run [

	| xmlResult |
	[ 
	(Duration minutes: 1) asDelay wait.
	xmlResult := XMLDOMParser parse:
		             self transformReportToJunitFormat asFileReference
			             contents.
	numberOfFailures := (xmlResult nodes anyOne attributeNodeAt:
		                     'failures') value asInteger.
	numberOfFailures > 0 ifTrue: [ self sendNotification ] ] forkNamed:
		'TestReport'
]

{ #category : #running }
PWBTestRepport >> sendMailMessageToCommitAuthor [
	| mailMessage |
	mailMessage := MailMessage empty
		from: 'pwbcritics@gmail.com';
		date: DateAndTime now asEmailString;
		subject: 'Rapport de test PBUnit';
		to: self recipientList;
		addAlternativePart: self message contentType: 'text/html';
		addAttachmentFrom: self pathToJunitXMLStyle asFileReference  withName: 'junit-report' .
	ZdcSecureSMTPClient
		sendPWBCriticsUsingGMailAccountPassword: '8v$oPDA0cA'
		to: self recipientList
		message: mailMessage
]

{ #category : #running }
PWBTestRepport >> transformReportToJunitFormat [

	| command junitReport |
	junitReport := self pathToPBUnitReportFile pathString
		               copyReplaceAll:
		               self pathToPBUnitReportFile basenameWithoutExtension
		               with: 'junit-report'.
	command := 'java -jar ' , self pathToSaxonTransformer , ' -s:'
	           , self pathToPBUnitReportFile pathString
	           , self pathToJunitXMLStyle , ' -o:' , junitReport.
	LibC runCommand: command.
	^ junitReport
]
