"
I responsable for creating a report for last test result
"
Class {
	#name : #PWBTestRepporter,
	#superclass : #Object,
	#instVars : [
		'numberOfFailures',
		'nonExecuted'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepporter class >> accept: aNumber [
	^ self subclassResponsibility
]

{ #category : #visiting }
PWBTestRepporter class >> nonExecuted: aNumber [
	self subclasses
		detect: [ :sub | sub accept: aNumber ]
		ifFound: [ :founded | 
			founded new
				nonExecuted: aNumber;
				run ]
		ifNone: [ Exception signal: 'case not found' ]
]

{ #category : #running }
PWBTestRepporter >> message [
	^ self subclassResponsibility
]

{ #category : #accessing }
PWBTestRepporter >> nonExecuted: aNumber [
	nonExecuted := aNumber
]

{ #category : #running }
PWBTestRepporter >> run [
	PWBPublisher new
		text: self styledMessage;
		subject:
			'Rapport de tests unitaires du ' , Date today ddmmyyyy
				, ' du serveur ' , (LibC resultOfCommand: 'hostname');
		run
]

{ #category : #'as yet unclassified' }
PWBTestRepporter >> singularizePluralize: aString quantity: aNumber [
	^ aNumber > 1
		ifTrue: [ aString , 's' ]
		ifFalse: [ aString ]
]

{ #category : #running }
PWBTestRepporter >> styledMessage [
	^ String
		streamContents: [ :stream | 
			stream
				<<
					'<style  type="text/css">
	h3{
font-weight: 500 }

	</style>';
				cr;
				<< self message ]
]
