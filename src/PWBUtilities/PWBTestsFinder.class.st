Class {
	#name : #PWBTestsFinder,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testLibraries'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #running }
PWBTestsFinder class >> runOn: aCollectionOfFileReference [
	^ self new
		testLibraries: aCollectionOfFileReference;
		run
]

{ #category : #running }
PWBTestsFinder >> run [
^ (TestMethodsExtractor testFiles: self testClasses) run
	
]

{ #category : #running }
PWBTestsFinder >> testClasses [
	^ (testLibraries flatCollect: #children)
		select: [ :file | 
			(file basenameWithoutExtension beginsWith: 'test_')
				or: [ file basenameWithoutExtension endsWith: 'test' ] ]
]

{ #category : #accessing }
PWBTestsFinder >> testLibraries: aCollectionOfFileReference [
	testLibraries := aCollectionOfFileReference
]
