Class {
	#name : #TestMethodsExtractor,
	#superclass : #PWBASTAbstractVisitor,
	#instVars : [
		'numberOfTest',
		'parser',
		'testFiles',
		'tests'
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

{ #category : #visiting }
TestMethodsExtractor >> isTest: aString [
	^ aString trim ~= 'setup' and: [ aString trim ~= 'teardown' ]
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
	(self
		isTest: (self visit: aPWBASTEventDeclaration eventReferenceName))
		ifFalse: [ ^ self ].
	numberOfTest := numberOfTest + 1
]

{ #category : #visiting }
TestMethodsExtractor >> visitPWBASTEventReferenceName: aPWBASTEventReferenceName [
	^ self visit: aPWBASTEventReferenceName eventName
]
