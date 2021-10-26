Class {
	#name : #PWBCILauncher,
	#superclass : #SpPresenter,
	#instVars : [
		'violationRunner',
		'testRunner',
		'model'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #specs }
PWBCILauncher class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #violationRunner;
		add: #testRunner;
		yourself
]

{ #category : #running }
PWBCILauncher class >> run [
	<example>
	^ self new openWithSpec
]

{ #category : #running }
PWBCILauncher class >> run: aSVNRepoURL [
	self new
		repoUrl: aSVNRepoURL;
		run
]

{ #category : #running }
PWBCILauncher class >> updateData: aBuilder [
	<worldMenu>
	(aBuilder item: #PWBCILauncher)
		parent: #PWBTools;
		help: 'Launch powerbuilder ci';
		label: #PWBCILauncher;
		action: [ self run ]
]

{ #category : #initialization }
PWBCILauncher >> initialize [
	super initialize
]

{ #category : #initialization }
PWBCILauncher >> initializePresenters [
	super initializePresenters.
	model := PWBCIModel new.
	violationRunner := self newButton.
	violationRunner
		label: 'Run violations';
		action: [ model runViolations ].
	testRunner := self newButton.
	testRunner
		label: 'Run Protect Tests';
		action: [ model runTests ]
]

{ #category : #initialization }
PWBCILauncher >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'PWB CI Launcher';
		initialExtent: 400 @ 200;
		iconNamed: #ciIcon
]
