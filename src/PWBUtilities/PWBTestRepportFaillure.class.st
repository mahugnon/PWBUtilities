Class {
	#name : #PWBTestRepportFaillure,
	#superclass : #PWBTestRepport,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepportFaillure class >> accept: aNumber [
	^ aNumber = 0 and: [ PWBTestResult failingTests size asString > 0 ]
]

{ #category : #running }
PWBTestRepportFaillure >> message [
	message
		ifEmpty: [ message := 'Nombre d''echec : '
				, PWBTestResult failingTests size asString , String crlf ].
	^ message
]
