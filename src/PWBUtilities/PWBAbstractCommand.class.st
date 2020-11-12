Class {
	#name : #PWBAbstractCommand,
	#superclass : #Object,
	#instVars : [
		'pathToTarget',
		'runner'
	],
	#category : #'PWBUtilities-PBLRegenerator'
}

{ #category : #running }
PWBAbstractCommand class >> runOn: aPathToPowerbuilderProjectTargetString [
	^ self new
		pathToTarget: aPathToPowerbuilderProjectTargetString;
		run
]

{ #category : #accessing }
PWBAbstractCommand >> errorsLogFilePath [
self subclassResponsibility 
]

{ #category : #accessing }
PWBAbstractCommand >> pathToTarget [
	^ pathToTarget
]

{ #category : #accessing }
PWBAbstractCommand >> pathToTarget: anObject [
	pathToTarget := anObject asFileReference
]

{ #category : #'private-accessing' }
PWBAbstractCommand >> powerbuilderProjetDirectory [
	^ pathToTarget parent
]

{ #category : #running }
PWBAbstractCommand >> run [ 
self subclassResponsibility 
]

{ #category : #'private-accessing' }
PWBAbstractCommand >> runner [
	^ runner
]

{ #category : #accessing }
PWBAbstractCommand >> runner: anObject [
	runner := anObject
]
