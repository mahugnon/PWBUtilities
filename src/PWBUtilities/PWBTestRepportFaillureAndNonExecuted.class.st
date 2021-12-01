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
	^ 'Nombre de test non executes : ' , nonExecuted asString
		, String crlf , 'Nombre d''echec : '
		, PWBTestResult failingTests size asString , String crlf
]
