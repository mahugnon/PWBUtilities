Class {
	#name : #PWBTestRepportFaillureAndNonExecuted,
	#superclass : #PWBTestRepporter,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepportFaillureAndNonExecuted class >> accept: aNumber [
	^ aNumber > 0 and: [ PWBTestResult failingTests isNotEmpty ]
]

{ #category : #running }
PWBTestRepportFaillureAndNonExecuted >> message [
	| faillures |
	faillures := PWBTestResult failingTests size.
	^ 'Nombre de test non executes : ' , nonExecuted asString
		, String space
		, (self singularizePluralize: 'test' quantity: nonExecuted)
		, String crlf , 'Nombre d''echec : ' , faillures asString
		, String space
		, (self singularizePluralize: 'test' quantity: faillures)
		, String crlf
]
