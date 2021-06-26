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
		'model'
	],
	#category : #'PWBUtilities-Core'
}

{ #category : #specs }
PWBCIUI class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #repoUrlTextInput;
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
	repoUrlTextInput acceptOnCR: true.
	repoUrlTextInput
		label: 'SVN repository URL:';
		whenTextIsAccepted: [ model repoUrl: repoUrlTextInput text.
			model isValidRepoUrl
				ifTrue: [ self window close.
					model run ]
				ifFalse: [ repoUrlTextInput subwidget color: Color red ] ]
]

{ #category : #initialization }
PWBCIUI >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'PWB Violation Manager';
		initialExtent: 500@100
]
