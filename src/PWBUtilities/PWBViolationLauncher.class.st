Class {
	#name : #PWBViolationLauncher,
	#superclass : #SpPresenter,
	#instVars : [
		'repoUrlTextInput',
		'model'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #specs }
PWBViolationLauncher class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #repoUrlTextInput;
		yourself
]

{ #category : #running }
PWBViolationLauncher class >> run [
	<example>
	^ self new openWithSpec
]

{ #category : #running }
PWBViolationLauncher class >> run: aSVNRepoURL [
	self new
		repoUrl: aSVNRepoURL;
		run
]

{ #category : #running }
PWBViolationLauncher class >> updateData: aBuilder [
	<worldMenu>
	(aBuilder item: #PWBCILauncher)
		parent: #PWBTools;
		help: 'Launch powerbuilder ci';
		label: #PWBCILauncher;
		action: [ self run ]
]

{ #category : #initialization }
PWBViolationLauncher >> initialize [
	super initialize
]

{ #category : #initialization }
PWBViolationLauncher >> initializePresenters [
	super initializePresenters.
	model := PWBViolationLauncherModel new.
	self initializeRepoUrlTextInput.
	repoUrlTextInput input
		whenTextIsAcceptedDo: [ model repoUrl: repoUrlTextInput input text.
			self isValidRepoUrl
				ifTrue: [ self window close.
					model run ].
			self update ]
]

{ #category : #initialization }
PWBViolationLauncher >> initializeRepoUrlTextInput [
	repoUrlTextInput := self
		instantiate: (SpLabelledPresenter label: 'SVN URL*:' input: self newTextInput).
	repoUrlTextInput input
		placeholder: 'https://svn.example.com/repos/MyRepo/MyProject/trunk'
]

{ #category : #initialization }
PWBViolationLauncher >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'PWB CI Launcher';
		initialExtent: 500 @ 50;
		iconNamed: #ciIcon
]

{ #category : #initialization }
PWBViolationLauncher >> isValidRepoUrl [
	| valid |
	valid := true.
	model isValidRepoUrl
		ifTrue: [ repoUrlTextInput descriptionPresenter: self newNullPresenter ]
		ifFalse: [ repoUrlTextInput description: 'The repo url is empty or not valid'.
			repoUrlTextInput descriptionPresenter color: Color red.
			valid := false ].
	^ valid
]

{ #category : #accessing }
PWBViolationLauncher >> repoUrl: aString [
	model repoUrl: aString
]

{ #category : #running }
PWBViolationLauncher >> run [
	model run
]
