Class {
	#name : #PWBCriticsRunner,
	#superclass : #Object,
	#instVars : [
		'repoUrl',
		'diff',
		'lines'
	],
	#category : #PWBCriticsRunner
}

{ #category : #'as yet unclassified' }
PWBCriticsRunner >> computeDiff [
	| head prev |
	head := self getSvnHEADNumber.
	prev := head - 1.
	diff := LibC
		resultOfCommand:
			'svn diff -r ' , prev asString , ':' , head asString , String space
				, repoUrl , ' --summarize'.
	lines := diff lines asOrderedCollection
		collect: [ :e | e copyFrom: 9 to: e size ].
	^ lines
]

{ #category : #'as yet unclassified' }
PWBCriticsRunner >> getSvnHEADNumber [
	| info |
	info := LibC resultOfCommand: 'svn info ' , repoUrl , ' --xml'.
	^ (((XMLDOMParser parse: info) document
		descendantElementsDetect: [ :xmlElt | xmlElt name = 'commit' ])
		attributeNodeAt: 'revision') value asInteger
]

{ #category : #initialization }
PWBCriticsRunner >> initialize [
	super initialize.
	repoUrl := 'https://CIM-SVN.SA-CIM.local/svn/IzyProtect_Production/'
]
