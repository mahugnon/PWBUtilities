"
I'm a Maryline tests generation runner
Basically Insert logs and put protect in the right place to allow running with Tosca
"
Class {
	#name : #MrlLoggerUtility,
	#superclass : #PWBAbstractCommand,
	#classVars : [
		'uniqueInstance'
	],
	#category : #'PWBUtilities-PBLRegenerator'
}

{ #category : #running }
MrlLoggerUtility class >> reset [
uniqueInstance := nil
]

{ #category : #running }
MrlLoggerUtility class >> runOn: aPathToPowerbuilderProjectTargetString [
	^ self uniqueInstance
		pathToTarget: aPathToPowerbuilderProjectTargetString;
		run
]

{ #category : #running }
MrlLoggerUtility class >> uniqueInstance [
	uniqueInstance ifNil: [ uniqueInstance := self new ].
	^ uniqueInstance
]

{ #category : #running }
MrlLoggerUtility >> createModules [
	| moduleCreator |
	self pathToModules exists
		ifTrue: [ self pathToModules deleteAll ].
	moduleCreator := CIMIzyFilesNavigatorModel new.
	moduleCreator izyProtectRootFolder: self izySourceCode.
	moduleCreator moduleFolder: self pathToModules
]

{ #category : #accessing }
MrlLoggerUtility >> errorsLogFilePath [
^ self powerbuilderProjetDirectory / 'MrlLogErrors.log'
]

{ #category : #running }
MrlLoggerUtility >> inserLogForPrestation [
	| famixModel |
	MooseModel resetRoot.
	famixModel := (PWBFamixImporter
		importFromFolder: self pathToModules / 'Prestation')
		name: 'Prestation';
		install.
	(MrlObjectsLogsCreator loggerWithoutAccessForModel: famixModel)
		addConstraint:
			(MrlLogsCreatorSkipBigFunctionConstraint new
				name: 'uo_traitement_liq_cal';
				constraint: {'uf_calcul_plafond' . 'uf_calcul_exp_limite_suite'};
				yourself);
		addConstraint:
			(MrlLogsCreatorMaxNumberOfLogsConstraint new
				name: 'uo_traitement_liq_cal';
				constraint: 207;
				yourself);
		addConstraint:
			(MrlLogsCreatorSkipBigFunctionConstraint new
				name: 'uo_traitement_ech_maj';
				constraint: {'uf_rech_prem_ech'};
				yourself);
		save.
	^ famixModel
]

{ #category : #running }
MrlLoggerUtility >> inserMrlLogsScriptsInPowerbuilderProject [
	| command famixModel |
	famixModel := self inserLogForPrestation.
	command := 'xcopy' , String space , famixModel rootFolder pathString
		, self powerbuilderProjetDirectory , String space , '/E/H/Y' , '2>'
		, String space , self errorsLogFilePath pathString.
	LibC runCommand: command.
	^ self errorsLogFilePath contents lines
]

{ #category : #running }
MrlLoggerUtility >> izySourceCode [
	^ self powerbuilderProjetDirectory / 'ws_objects'
]

{ #category : #'as yet unclassified' }
MrlLoggerUtility >> pathToModules [
	^ 'modules' asFileReference
]

{ #category : #accessing }
MrlLoggerUtility >> pathToTarget: anObject [
	pathToTarget = anObject asFileReference
		ifTrue: [ ^ self ].
	pathToTarget := anObject asFileReference.
	self createModules
]

{ #category : #running }
MrlLoggerUtility >> run [
	self inserMrlLogsScriptsInPowerbuilderProject.
	PBLRegenerator runOn: self powerbuilderProjetDirectory.
	PWBBuilder runOn: self powerbuilderProjetDirectory
]
