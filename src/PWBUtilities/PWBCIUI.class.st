Class {
	#name : #PWBCIUI,
	#superclass : #SpPresenter,
	#instVars : [
		'repoUrl',
		'svnHead',
		'svnHeadAuthor',
		'svnPrevAuthor',
		'repoUrlTextInput',
		'svnPrev',
		'model',
		'okButton',
		'targetNameTextInput',
		'localDirectoryTextInput',
		'selectDirectoryButton'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #specs }
PWBCIUI class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #repoUrlTextInput;
		add: #targetNameTextInput;
		add:
			(SpBoxLayout newHorizontal
				add: #localDirectoryTextInput;
				add:
					(SpBoxLayout newVertical
						add: #selectDirectoryButton
							withConstraints: [ :constraint | constraint height: 25 ];
						yourself)
					width: 30;
				yourself);
		add:
			(SpBoxLayout newHorizontal
				add: #okButton width: 50;
				yourself);
		yourself
]

{ #category : #running }
PWBCIUI class >> run [
	<example>
	^ self new openWithSpec
]

{ #category : #running }
PWBCIUI class >> run: aSVNRepoURL [
	self new
		repoUrl: aSVNRepoURL;
		run
]

{ #category : #running }
PWBCIUI class >> updateData: aBuilder [
	<worldMenu>
	(aBuilder item: #RunPWBViolations)
		parent: #PWBTools;
		help: 'Launch process to alert on new violations on last commit';
		label: 'RunPWBViolations';
		action: [ self run ]
]

{ #category : #initialization }
PWBCIUI >> initialize [
	super initialize.
	model := PWBCIModel new
]

{ #category : #initialization }
PWBCIUI >> initializeLocalDirectoryTextInput [
	localDirectoryTextInput := self instantiate: SpLabelledTextInput.
	localDirectoryTextInput label: 'Local directory :'.
	selectDirectoryButton := self newButton
		label: '...';
		action: [ PWBCIModel
				repoLocal: (UITheme builder chooseDirectory: 'Select a directory') ]
]

{ #category : #initialization }
PWBCIUI >> initializePresenters [
	self initializeRepoUrlTextInput.
	self initializeTargetNameTextInput.
	self initializeLocalDirectoryTextInput.
	okButton := self newButton.
	okButton label: 'OK';
	iconName: #smallOk .
	okButton
		action: [ model repoUrl: repoUrlTextInput input text.
			model targetName: targetNameTextInput input text.
			self isFieldsValid
				ifTrue: [ self window close.
					model run ] ]
]

{ #category : #initialization }
PWBCIUI >> initializeRepoUrlTextInput [
	repoUrlTextInput := self
		instantiate: (SpLabelledPresenter label: 'SVN URL*:' input: self newTextInput).
	repoUrlTextInput input
		placeholder: 'https://svn.example.com/repos/MyRepo/MyProject/trunk'
]

{ #category : #initialization }
PWBCIUI >> initializeTargetNameTextInput [
	targetNameTextInput := self
		instantiate:
			(SpLabelledPresenter label: 'Target name*:' input: self newTextInput).
	targetNameTextInput input placeholder: 'abc.pbt'
]

{ #category : #initialization }
PWBCIUI >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'PWB CI Launcher';
		initialExtent: 500 @ 200
]

{ #category : #initialization }
PWBCIUI >> isFieldsValid [
	| valid |
	valid := true.
	valid := self isValidRepoUrl.
	valid := self isValidTargetName.
	self update.
	^ valid
]

{ #category : #initialization }
PWBCIUI >> isValidRepoUrl [
	| valid |
	valid := true.
	model isValidRepoUrl
		ifTrue: [ repoUrlTextInput descriptionPresenter: self newNullPresenter ]
		ifFalse: [ repoUrlTextInput description: 'The repo url is empty or not valid'.
			repoUrlTextInput descriptionPresenter color: Color red.
			valid := false ].
	^ valid
]

{ #category : #initialization }
PWBCIUI >> isValidTargetName [
	| valid |
	valid := true.
	model isValidTargetName
		ifTrue: [ repoUrlTextInput descriptionPresenter: self newNullPresenter ]
		ifFalse: [ targetNameTextInput
				description: 'The target name is empty or not valid'.
			targetNameTextInput descriptionPresenter color: Color red.
			valid := false ].
	^ valid
]
