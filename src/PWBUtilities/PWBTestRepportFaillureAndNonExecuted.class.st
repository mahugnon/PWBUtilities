Class {
	#name : #PWBTestRepportFaillureAndNonExecuted,
	#superclass : #PWBTestRepport,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepportFaillureAndNonExecuted class >> accept: aNumber [
	^ aNumber > 0 and: [ PWBTestResult failingTests size asString > 0 ]
]

{ #category : #running }
PWBTestRepportFaillureAndNonExecuted >> message [
	message
		ifEmpty: [ message := 'Nombre de test non executes : ' , nonExecuted asString
				, String crlf , 'Nombre d''echec : '
				, PWBTestResult failingTests size asString , String crlf ].
	^ message
]
