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
	faillures := PWBTestResult failingTests.
	^ String
		streamContents: [ :stream | 
			stream
				<< 'Nombre d''echec : ';
				<< faillures size asString;
				space;
				<< (self singularizePluralize: 'test' quantity: faillures size);
				cr;
				<< '<ul>'.
			faillures
				do: [ :fail | 
					stream
						<< '<li>';
						space;
						<< '<h3>';
						<< fail caseName;
						space;
						<< ':</h3> <span>';
						<< fail failureMessage;
						<< '</span> </li>';
						cr ].
			stream << '</ul>' ]
]
