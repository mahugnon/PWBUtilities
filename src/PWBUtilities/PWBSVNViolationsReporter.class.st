"
I compute difference betwen two sets of violations
"
Class {
	#name : #PWBSVNViolationsReporter,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'head',
		'prev',
		'stream',
		'repoName',
		'headAuthor',
		'prevAuthor'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #'as yet unclassified' }
PWBSVNViolationsReporter class >> prev: aPrevViolations head: aHeadViolations [
	^ self new prev: aPrevViolations head: aHeadViolations
]

{ #category : #running }
PWBSVNViolationsReporter >> diffBetween: aCollection1 and: aCollection2 [
	^ aCollection1
		select: [ :violation | 
			aCollection2
				allSatisfy:
					[ :each | (violation isSameAs: each) not or: [ violation isReportCrossCommitViolation ] ] ]
]

{ #category : #running }
PWBSVNViolationsReporter >> existViolations: diffHeadPrev [
	^ diffHeadPrev isNotEmpty
]

{ #category : #accessing }
PWBSVNViolationsReporter >> head [
	^ head
]

{ #category : #accessing }
PWBSVNViolationsReporter >> head: anObject [
	head := anObject
]

{ #category : #accessing }
PWBSVNViolationsReporter >> headAuthor: aString [ 
	headAuthor := aString
]

{ #category : #initialization }
PWBSVNViolationsReporter >> initialize [
	super initialize.
	stream := WriteStream on: String new
]

{ #category : #running }
PWBSVNViolationsReporter >> isAuthorFixViolations: diffPrevHead [
	^ diffPrevHead isNotEmpty and: [ prevAuthor = headAuthor ]
]

{ #category : #running }
PWBSVNViolationsReporter >> prepareEncouragmentReport: aCollection with: anInteger [
	stream
		<<
			'<h1>Bravo !! :) </h1><br/>
		Vous avez corrigé ';
		<< anInteger asString;
		<< ' violations dans la version ';
		<< repoName;
		<< '. <br/>'.
	aCollection
		ifNotEmpty: [ stream << 'Neamoins il reste d''autres violations.<br/>'.
			aCollection do: [ :violation | violation reportOn: stream ].
			stream << '</ul>' ]
]

{ #category : #running }
PWBSVNViolationsReporter >> prepareReport: aCollection [
	stream
		<< '<p>';
		<< self violationContext.
	aCollection do: [ :violation | violation reportOn: stream ].
	stream << '</ul></p>'
]

{ #category : #running }
PWBSVNViolationsReporter >> prepareViolationReport: aCollection [
	stream
		<< '<p>';
		<< self violationContext.
	aCollection do: [ :violation | violation reportOn: stream ].
	stream << '</ul></p>'
]

{ #category : #accessing }
PWBSVNViolationsReporter >> prev [
	^ prev
]

{ #category : #accessing }
PWBSVNViolationsReporter >> prev: anObject [
	prev := anObject
]

{ #category : #running }
PWBSVNViolationsReporter >> prev: aPrevViolations head: aHeadViolations [
	prev := aPrevViolations.
	head := aHeadViolations
]

{ #category : #accessing }
PWBSVNViolationsReporter >> prevAuthor: aString [
	prevAuthor := aString
]

{ #category : #running }
PWBSVNViolationsReporter >> recipientList [
	| recipientList authorMail |
	authorMail := headAuthor , '@sa-cim.fr'.
	recipientList := {'Jerome.Sudich@sa-cim.fr'.
	'fatiha.Djareddir@sa-cim.fr'.
	'MahugnonHonore.Houekpetodji@sa-cim.fr'.
	authorMail}.
	^ recipientList
]

{ #category : #accessing }
PWBSVNViolationsReporter >> repoName [
	^ repoName
]

{ #category : #accessing }
PWBSVNViolationsReporter >> repoName: aString [
	repoName := aString
]

{ #category : #running }
PWBSVNViolationsReporter >> reportViolation: violations [
	self prepareReport: violations.
	LibC
		resultOfCommand:
			'powershell -file "sendMail.ps1" "' , self stream , '" "' , headAuthor
				, '@sa-cim.fr"'
]

{ #category : #running }
PWBSVNViolationsReporter >> reportViolation: diffHeadPrev withFixed: diffPrevHead [
	(self existViolations: diffHeadPrev)
		ifTrue: [ (self isAuthorFixViolations: diffPrevHead)
				ifTrue:
					[ self prepareEncouragmentReport: diffHeadPrev with: diffPrevHead size ]
				ifFalse: [ self prepareViolationReport: diffHeadPrev ] ]
		ifFalse: [ (self isAuthorFixViolations: diffPrevHead)
				ifTrue: [ stream
						<<
							'<h1>Falicitation <span font-size: 100px;>&#128079;&#127997;</span><span>&#128076;&#127998;</span> </h1>';
						<< '<br/>';
						<< '<p>Vous avez fixé toutes les violations</p>' ] ].
	self stream ifNotEmpty: [ self sendMailMessageToCommitAuthor ]
]

{ #category : #running }
PWBSVNViolationsReporter >> run [
	| diffHeadPrev diffPrevHead |
	diffHeadPrev := self diffBetween: self head and: self prev.
	diffPrevHead := self diffBetween: self prev and: self head.
	self reportViolation: diffHeadPrev withFixed: diffPrevHead
]

{ #category : #running }
PWBSVNViolationsReporter >> sendMailMessageToCommitAuthor [
	PWBPublisher new
		recipientList: self recipientList;
		text: stream contents;
		subject:
			'Rapport sur les violations de code du serveur'
				, (LibC resultOfCommand: 'hostname');
		author: headAuthor;
		run
]

{ #category : #accessing }
PWBSVNViolationsReporter >> stream [
	^ stream contents
]

{ #category : #running }
PWBSVNViolationsReporter >> violationContext [
	^ 'Dans le but d''améliorer le code Protect, on a décider de supprimer progressivement les 9999 sur find ou rowscopy ainsi que tout ce qui ne respecte pas les normes de developpement instaurées dans l''équipe. Dans cette optique, je vous rapporte les violations suivantes sur la version '
		, repoName , ':'
]
