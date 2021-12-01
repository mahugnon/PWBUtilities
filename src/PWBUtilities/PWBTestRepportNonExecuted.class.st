Class {
	#name : #PWBTestRepportNonExecuted,
	#superclass : #PWBTestRepporter,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepportNonExecuted class >> accept: aNumber [
	^ aNumber > 0 and: [ PWBTestResult failingTests size asString = 0 ]
]

{ #category : #running }
PWBTestRepportNonExecuted >> message [
	^ 'Nombre de test non executes : ' , nonExecuted asString
		, String crlf
]
