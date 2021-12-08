"
I responsable for sending report mail to the author
"
Class {
	#name : #PWBPublisher,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'text',
		'attachment',
		'recipientList',
		'subject'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #accessing }
PWBPublisher >> attachment [
	^ attachment
]

{ #category : #accessing }
PWBPublisher >> attachment: anObject [
	attachment := anObject
]

{ #category : #tests }
PWBPublisher >> defaultRecipientList [
	^ {'MahugnonHonore.Houekpetodji@sa-cim.fr'".
	'Jerome.Sudich@sa-cim.fr' . 'Jean-Baptiste.Monville@sa-cim.fr'.'leonard.lamarque@sa-cim.fr'.'cedric.montuelle@sa-cim.fr'"}
]

{ #category : #running }
PWBPublisher >> hasAttachment [
	^ attachment isNotNil
]

{ #category : #initialization }
PWBPublisher >> initialize [
	super initialize.
	recipientList := self defaultRecipientList
]

{ #category : #running }
PWBPublisher >> message [
	| mailMessage |
	mailMessage := MailMessage empty
		from: 'pwbcritics@gmail.com';
		date: DateAndTime now asEmailString;
		subject: self subject;
		to: self recipientList;
		addAlternativePart: text contentType: 'text/html'.
	self hasAttachment
		ifTrue: [ mailMessage
				addAttachmentFrom: attachment readStream
				withName: attachment basename ].
	^ mailMessage
]

{ #category : #running }
PWBPublisher >> recipientList [
	^ recipientList
]

{ #category : #running }
PWBPublisher >> recipientList: aColllection [
	recipientList := aColllection
]

{ #category : #running }
PWBPublisher >> run [
	self sendMailMessageToCommitAuthor
]

{ #category : #running }
PWBPublisher >> sendMailMessageToCommitAuthor [
	| mailMessage |
	mailMessage := self message.
	ZdcSecureSMTPClient
		sendPWBCriticsUsingGMailAccountPassword: '8v$oPDA0cA'
		to: self recipientList
		message: mailMessage
]

{ #category : #running }
PWBPublisher >> subject [
	^ subject
]

{ #category : #running }
PWBPublisher >> subject: aString [
	subject := aString
]

{ #category : #accessing }
PWBPublisher >> text [
	^ text
]

{ #category : #accessing }
PWBPublisher >> text: anObject [
	text := anObject
]
