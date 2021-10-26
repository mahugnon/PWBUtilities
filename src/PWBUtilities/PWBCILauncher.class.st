Class {
	#name : #PWBCILauncher,
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
PWBCILauncher class >> defaultSpec [
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
PWBCILauncher >> initializeLocalDirectoryTextInput [
	localDirectoryTextInput := self
		instantiate:
			(SpLabelledPresenter
				label: 'Local directory :'
				input: self newTextInput).
	model localDirectory
		ifNil: [ localDirectoryTextInput input
				placeholder: 'C:\Users\CIMColaborator\Documents\EspaceDeTravail\Local_repository' ]
		ifNotNil:
			[ localDirectoryTextInput input text: model localDirectory pathString ].
	selectDirectoryButton := self newButton
		label: '...';
		action: [ model
				localDirectory: (UITheme builder chooseDirectory: 'Select a directory').
			localDirectoryTextInput input
				acceptText: model localDirectory pathString.
			self update ]
]

{ #category : #initialization }
PWBCILauncher >> initializePresenters [
	super initializePresenters.
	model := PWBCIModel new.
	self initializeRepoUrlTextInput.
	self initializeTargetNameTextInput.
	self initializeLocalDirectoryTextInput.
	okButton := self newButton.
	okButton
		label: 'OK';
		iconName: #smallOk.
	okButton
		action: [ model repoUrl: repoUrlTextInput input text.
			model targetName: targetNameTextInput input text.
			self isFieldsValid
				ifTrue: [ self window close.
					model run ] ]
]

{ #category : #initialization }
PWBCILauncher >> initializeRepoUrlTextInput [
	repoUrlTextInput := self
		instantiate: (SpLabelledPresenter label: 'SVN URL*:' input: self newTextInput).
	repoUrlTextInput input
		placeholder: 'https://svn.example.com/repos/MyRepo/MyProject/trunk'
]

{ #category : #initialization }
PWBCILauncher >> initializeTargetNameTextInput [
	targetNameTextInput := self
		instantiate:
			(SpLabelledPresenter label: 'Target name*:' input: self newTextInput).
	targetNameTextInput input placeholder: 'abc.pbt'
]

{ #category : #initialization }
PWBCILauncher >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'PWB CI Launcher';
		initialExtent: 600 @ 230;
		iconNamed: #ciIcon
]

{ #category : #initialization }
PWBCILauncher >> isFieldsValid [
	| valid |
	valid := true.
	valid := self isValidRepoUrl.
	valid := self isValidTargetName.
	self update.
	^ valid
]

{ #category : #initialization }
PWBCILauncher >> isValidLocalDirectory [
	| valid |
	valid := true.
	model isValidLocalDirectory
		ifTrue:
			[ localDirectoryTextInput descriptionPresenter: self newNullPresenter ]
		ifFalse: [ localDirectoryTextInput
				description: 'The local repository should be set'.
			localDirectoryTextInput descriptionPresenter color: Color red.
			valid := false ].
	^ valid
]

{ #category : #initialization }
PWBCILauncher >> isValidRepoUrl [
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
PWBCILauncher >> isValidTargetName [
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
