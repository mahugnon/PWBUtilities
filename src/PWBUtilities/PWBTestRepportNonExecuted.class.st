Class {
	#name : #PWBTestRepportNonExecuted,
	#superclass : #PWBTestRepport,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepportNonExecuted class >> accept: aNumber [
	^ aNumber > 0 and: [ PWBTestResult failingTests size asString = 0 ]
]

{ #category : #running }
PWBTestRepportNonExecuted >> message [
	message
		ifEmpty: [ message := 'Nombre de test non executes : ' , nonExecuted asString
				, String crlf ].
	^ message
]
