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
		'targetNameTextInput'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #specs }
PWBCIUI class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #repoUrlTextInput;
		add: #targetNameTextInput;
		add: #okButton
			withConstraints: [ :constraints | 
			constraints
				height: self toolbarHeight;
				width: self buttonWidth  ];
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
PWBCIUI >> initializePresenters [
	repoUrlTextInput := self instantiate: SpLabelledTextInput.
	repoUrlTextInput label: 'SVN repository URL*:';
	placeholder: 'https://svn.example.com/repos/MyRepo/MyProject/trunk'.
	targetNameTextInput := self instantiate: SpLabelledTextInput.
	targetNameTextInput
		label: 'Target name*:';
		placeholder: 'abc.pbt'.
	okButton := self newButton.
	okButton label: 'OK'.
	okButton
		action: [ model repoUrl: repoUrlTextInput text.
			model targetName: targetNameTextInput text.
			self isFieldsValid
				ifTrue: [ self window close.
					model run ] ]
]

{ #category : #initialization }
PWBCIUI >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'PWB Violation Manager';
		initialExtent: 500@150
]

{ #category : #initialization }
PWBCIUI >> isFieldsValid [
	| valid |
	valid := true.
	model isValidRepoUrl
		ifFalse: [ repoUrlTextInput subwidget color: Color red.
			valid := false ].
	model isValidTargetName
		ifFalse: [ targetNameTextInput subwidget color: Color red.
			valid := false ].
	^ valid
]
