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
	faillures := PWBTestResult failingTests.
	^ String
		streamContents: [ :stream | 
			stream
				<< '<h3>Nombre de test non executes : </h3>';
				<< nonExecuted asString;
				space;
				<< (self singularizePluralize: 'test' quantity: nonExecuted);
				cr;
				<< '<h3>Nombre d''echec : </h3>';
				<< faillures size asString;
				space;
				<< (self singularizePluralize: 'test' quantity: faillures size);
				cr;
				<< '<ul>'.
			faillures
				do:
					[ :fail | 
					stream
						<< '<li>';
						space;
						<< '<h4>';
						<< fail caseName;
						space;
						<< ':</h4> <span>';
						<< fail failureMessage;
						<< '</span> </li>';
						cr ] stream << '</ul>' ]
]
