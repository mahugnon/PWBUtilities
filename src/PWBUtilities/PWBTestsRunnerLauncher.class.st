"
I am the user interface  of IzyProtect continious integration tool
"
Class {
	#name : #PWBTestsRunnerLauncher,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'okButton',
		'targetNameTextInput',
		'projectBuildPathButton',
		'projectBuildPath'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #specs }
PWBTestsRunnerLauncher class >> defaultSpec [
	^ SpBoxLayout newVertical
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
		add: #targetNameTextInput;
		add:
			(SpBoxLayout newHorizontal
				add: #okButton width: 50;
				yourself);
		yourself
]

{ #category : #running }
PWBTestsRunnerLauncher class >> run [
	<example>
	^ self new openWithSpec
]

{ #category : #running }
PWBTestsRunnerLauncher class >> run: aSVNRepoURL [
	self new
		repoUrl: aSVNRepoURL;
		run
]

{ #category : #running }
PWBTestsRunnerLauncher class >> updateData: aBuilder [
	<worldMenu>
	(aBuilder item: #PWBCILauncher)
		parent: #PWBTools;
		help: 'Launch powerbuilder ci';
		label: #PWBCILauncher;
		action: [ self run ]
]

{ #category : #initialization }
PWBTestsRunnerLauncher >> initialize [
	super initialize
]

{ #category : #initialization }
PWBTestsRunnerLauncher >> initializeLocalDirectoryTextInput [
	projectBuildPath := self
		instantiate:
			(SpLabelledPresenter
				label: 'Local directory :'
				input: self newTextInput).
	model localDirectory
		ifNil: [ projectBuildPath input
				placeholder: 'C:\Users\CIMColaborator\Documents\EspaceDeTravail\Local_repository' ]
		ifNotNil:
			[ projectBuildPath input text: model localDirectory pathString ].
	projectBuildPathButton := self newButton
		label: '...';
		action: [ model
				localDirectory: (UITheme builder chooseDirectory: 'Select a directory').
			projectBuildPath input
				acceptText: model localDirectory pathString.
			self update ]
]

{ #category : #initialization }
PWBTestsRunnerLauncher >> initializePresenters [
	super initializePresenters.
	model := PWBTestRunnerLauncherModel new.
	self initializeTargetNameTextInput.
	self initializeLocalDirectoryTextInput.
	okButton := self newButton.
	okButton
		label: 'OK';
		iconName: #smallOk.
	okButton
		action: [ model targetName: targetNameTextInput input text.
			self isFieldsValid
				ifTrue: [ self window close.
					model run ] ]
]

{ #category : #initialization }
PWBTestsRunnerLauncher >> initializeTargetNameTextInput [
	targetNameTextInput := self
		instantiate:
			(SpLabelledPresenter label: 'Target name*:' input: self newTextInput).
	targetNameTextInput input placeholder: 'abc.pbt'
]

{ #category : #initialization }
PWBTestsRunnerLauncher >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Test Runner Launcher';
		initialExtent: 600 @ 180;
		iconNamed: #ciIcon
]

{ #category : #initialization }
PWBTestsRunnerLauncher >> isFieldsValid [
	| valid |
	valid := true.
	valid := self isValidTargetName.
	self update.
	^ valid
]

{ #category : #initialization }
PWBTestsRunnerLauncher >> isValidLocalDirectory [
	| valid |
	valid := true.
	model isValidLocalDirectory
		ifTrue:
			[ projectBuildPath descriptionPresenter: self newNullPresenter ]
		ifFalse: [ projectBuildPath
				description: 'The local repository should be set'.
			projectBuildPath descriptionPresenter color: Color red.
			valid := false ].
	^ valid
]

{ #category : #initialization }
PWBTestsRunnerLauncher >> isValidTargetName [
	| valid |
	valid := true.
	model isValidTargetName
		ifFalse: [ targetNameTextInput
				description: 'The target name is empty or not valid'.
			targetNameTextInput descriptionPresenter color: Color red.
			valid := false ].
	^ valid
]
