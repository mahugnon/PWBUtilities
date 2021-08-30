Class {
	#name : #PWBBehaviorToTest,
	#superclass : #PWBAbstractCommand,
	#instVars : [
		'objectName'
	],
	#category : #'PWBUtilities-PWBCommands'
}

{ #category : #running }
PWBBehaviorToTest >> run [
	| model |
	model := MooseModel root first.
	^ (model allMethods
		select: [ :method | 
			method name ~= 'constructor'
				and: [ method sourceText
						includesSubstring: 'dataobject = '
						caseSensitive: false ] ]) groupedBy: #parentType
]
