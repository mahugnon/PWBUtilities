Class {
	#name : #PWBTestRepportFaillure,
	#superclass : #PWBTestRepporter,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepportFaillure class >> accept: aNumber [
	^ aNumber = 0 and: [ PWBTestResult failingTests isNotEmpty ]
]

{ #category : #running }
PWBTestRepportFaillure >> message [
	^ 'Nombre d''echec : ' , PWBTestResult failingTests size asString
		, String crlf
]
