Class {
	#name : #PWBTestRepportNonExecuted,
	#superclass : #PWBTestRepporter,
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #visiting }
PWBTestRepportNonExecuted class >> accept: aNumber [
	^ aNumber > 0 and: [ PWBTestResult failingTests isEmpty ]
]

{ #category : #running }
PWBTestRepportNonExecuted >> message [
	^ String
		streamContents: [ :stream | 
			stream
				<< '<h3>Nombre de test non executes : </h3>';
				<< nonExecuted asString;
				space;
				<< (self singularizePluralize: 'test' quantity: nonExecuted);
				cr ]
]
