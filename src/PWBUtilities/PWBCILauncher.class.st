Class {
	#name : #PWBCILauncher,
	#superclass : #SpPresenter,
	#instVars : [
		'violationRunner',
		'testRunner',
		'model',
		'testRunnerTitle',
		'violationRunnerTitle'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #specs }
PWBCILauncher class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add: #violationRunner;
				add: #violationRunnerTitle;
				yourself)
			withConstraints: [ :constraints | 
				constraints
					beNotResizable;
					beNotShrinkable ];
		add:
			(SpBoxLayout newVertical
				add: #testRunner;
				add: #testRunnerTitle;
				yourself)
			withConstraints: [ :constraints | 
				constraints
					beNotResizable;
					beNotShrinkable ];
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
		help: 'Tâches Protects';
		label: 'Utilitaire d''Izy Protect';
		icon: PWBIconLibrary mutcimIcon ; 
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
		icon: PWBIconLibrary violationIcon;
		action: [ model runViolations ].
	violationRunnerTitle := self newLabel.
	violationRunnerTitle
	color: Color blue ;
		label: 'Linter';
		emphasis: #bold.
	testRunner := self newButton.
	testRunnerTitle := self newLabel.
	testRunnerTitle
	color: Color blue ;
		label: 'Tests unitaires';
		emphasis: #bold.
	testRunner
		icon: PWBIconLibrary testIcon;
		action: [ model runTests ]
]

{ #category : #initialization }
PWBCILauncher >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Utilitaire d''Izy Protect';
		isResizeable: false;
		initialExtent: 320 @ 180;
		iconNamed: #ciIcon
]
