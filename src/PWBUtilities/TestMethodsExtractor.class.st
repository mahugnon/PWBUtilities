Class {
	#name : #TestMethodsExtractor,
	#superclass : #PWBASTAbstractVisitor,
	#instVars : [
		'numberOfTest',
		'parser',
		'testFiles'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #tests }
TestMethodsExtractor class >> testFiles: aCollection [
	^ self new testFiles: aCollection
]

{ #category : #initialization }
TestMethodsExtractor >> initialize [
	numberOfTest := 0.
	parser := PWBCommonParser
]

{ #category : #running }
TestMethodsExtractor >> run [
	testFiles
		do: [ :file | 
			self
				visit: (PWBCommonParser parse: (PWBPreprocessor parse: file contents)) ].
	^ numberOfTest
]

{ #category : #accessing }
TestMethodsExtractor >> testFiles: aCollection [
	testFiles := aCollection
]

{ #category : #visiting }
TestMethodsExtractor >> visitPWBASTEventDeclaration: aPWBASTEventDeclaration [
	numberOfTest := numberOfTest + 1
]
