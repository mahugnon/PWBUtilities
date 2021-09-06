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
