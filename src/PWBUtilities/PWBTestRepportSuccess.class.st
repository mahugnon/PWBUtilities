Class {
	#name : #PWBTestRepportSuccess,
	#superclass : #PWBTestRepporter,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepportSuccess class >> accept: aNumber [
	^ aNumber = 0 and: [ PWBTestResult failingTests isEmpty ]
]

{ #category : #running }
PWBTestRepportSuccess >> message [
	^ String
		streamContents: [ :stream | 
			stream
				<< '<h3>Fellicitation :) tous les';
				space;
				<< PWBTestResult loadAll size asString;
				space;
				<< ' tests passent.</h3>';
				cr ]
]
