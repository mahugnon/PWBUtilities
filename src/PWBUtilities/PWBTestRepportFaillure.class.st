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
	| faillures |
	faillures := PWBTestResult failingTests size.
	^ 'Nombre d''echec : ' , faillures asString , String space
		, (self singularizePluralize: 'test' quantity: faillures)
		, String crlf
]
