Class {
	#name : #PBLUnitTestsRunner,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'testDatabase'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #accessing }
PBLUnitTestsRunner >> errorsLogFilePath [

]

{ #category : #running }
PBLUnitTestsRunner >> pathToJunitXMLStyle [

	^ ' -xsl:C:\ci-utilities\junit.xsl'
]

{ #category : #running }
PBLUnitTestsRunner >> pathToPBUnitReportFile [

	^ (self pathToTarget parent / 'pbunit-results.xml') pathString
]

{ #category : #running }
PBLUnitTestsRunner >> pathToSaxonTransformer [

	^ 'c:\saxon\saxon.jar '
]

{ #category : #running }
PBLUnitTestsRunner >> run [

	| exe command |
	exe := self pathToTarget pathString
		       copyReplaceAll: self pathToTarget extension
		       with: 'exe'.
	command := 'start ' , exe , ' NOM_BAS=' , self testDatabase
	           , ';TYP_TRT=PB_UNIT;EMP_INI=c:\WinNT\;target='
	           , self pathToTarget pathString , ';'.
	command , String cr , self transformReportToJunitFormat.
	LibC runCommand: command
	"self transformReportToJunitFormat"
]

{ #category : #running }
PBLUnitTestsRunner >> testDatabase [

	^ testDatabase
]

{ #category : #running }
PBLUnitTestsRunner >> testDatabase: aString [

	testDatabase := aString
]

{ #category : #running }
PBLUnitTestsRunner >> transformReportToJunitFormat [

	| command |
	command := 'java -jar ' , self pathToSaxonTransformer , ' -s:'
	           , self pathToPBUnitReportFile , self pathToJunitXMLStyle
	           , ' -o:' , (self pathToPBUnitReportFile
		            copyReplaceAll:
		            self pathToPBUnitReportFile asFileReference
			            basenameWithoutExtension
		            with: 'junit-report').
	^ command
]
