Class {
	#name : #PWBTestResult,
	#superclass : #Object,
	#instVars : [
		'suiteName',
		'caseName',
		'executed',
		'success',
		'caseTime',
		'asserts',
		'failureMessage',
		'stackTrace',
		'targetName'
	],
	#classInstVars : [
		'login'
	],
	#category : #'PWBUtilities-GlopModel'
}

{ #category : #'as yet unclassified' }
PWBTestResult class >> emptyResultTable [
	| session testResults |
	testResults := self loadAll.
	session := self session.
	session deleteAll: testResults
]

{ #category : #'as yet unclassified' }
PWBTestResult class >> failingTests [
	^ self loadAll select: [ :each | each success asLowercase = 'false' ]
]

{ #category : #'as yet unclassified' }
PWBTestResult class >> loadAll [
	| result session |
	session := self session.
	result := session read: self.
	session logout.
	^ result
]

{ #category : #'as yet unclassified' }
PWBTestResult class >> login [
	login := Login new
		database: PostgreSQLPlatform new;
		username: 'tosca';
		password: 'nkgqK8DHxzbT';
		host: 'cldb01tsc999p.sa-cim.local';
		port: '5432';
		databaseName: 'tosca'.
	login secure: false.
	(DatabaseAccessor forLogin: login) login.
	^ login
]

{ #category : #'as yet unclassified' }
PWBTestResult class >> session [
	| session |
	self setDriver.
	session := PWBTestResultDescriptionSystem sessionForLogin: self login.
	session login.
	^ session
]

{ #category : #'as yet unclassified' }
PWBTestResult class >> setDriver [
	Smalltalk
		at: #NativePostgresDriver
		ifAbsent: [ PharoDatabaseAccessor DefaultDriver: P3DatabaseDriver ]
]

{ #category : #'as yet unclassified' }
PWBTestResult class >> successfulTests [
	^ self loadAll select: [ :each | each success asLowercase = 'true' ]
]

{ #category : #accessing }
PWBTestResult >> asserts [
	^ asserts
]

{ #category : #accessing }
PWBTestResult >> asserts: anObject [
	asserts := anObject
]

{ #category : #accessing }
PWBTestResult >> caseName [
	^ caseName
]

{ #category : #accessing }
PWBTestResult >> caseName: anObject [
	caseName := anObject
]

{ #category : #accessing }
PWBTestResult >> caseTime [
	^ caseTime
]

{ #category : #accessing }
PWBTestResult >> caseTime: anObject [
	caseTime := anObject
]

{ #category : #accessing }
PWBTestResult >> executed [
	^ executed
]

{ #category : #accessing }
PWBTestResult >> executed: anObject [
	executed := anObject
]

{ #category : #accessing }
PWBTestResult >> failureMessage [
	^ failureMessage
]

{ #category : #accessing }
PWBTestResult >> failureMessage: anObject [
	failureMessage := anObject
]

{ #category : #accessing }
PWBTestResult >> stackTrace [
	^ stackTrace
]

{ #category : #accessing }
PWBTestResult >> stackTrace: anObject [
	stackTrace := anObject
]

{ #category : #accessing }
PWBTestResult >> success [
	^ success
]

{ #category : #accessing }
PWBTestResult >> success: anObject [
	success := anObject
]

{ #category : #accessing }
PWBTestResult >> suiteName [
	^ suiteName
]

{ #category : #accessing }
PWBTestResult >> suiteName: anObject [
	suiteName := anObject
]

{ #category : #accessing }
PWBTestResult >> targetName [
	^ targetName
]

{ #category : #accessing }
PWBTestResult >> targetName: anObject [
	targetName := anObject
]
