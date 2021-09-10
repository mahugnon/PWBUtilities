Class {
	#name : #BaselineOfPWBUtilities,
	#superclass : #BaselineOf,
	#category : #BaselineOfPWBUtilities
}

{ #category : #baselines }
BaselineOfPWBUtilities >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ self baselineOfXMLParser: spec.
			self baselineOfPowerbuilderParser: spec.
			self
				baselineOfP3: spec;
				baselineOfGlorp: spec.
			spec
				package: 'PWBUtilities'
				with: [ spec requires: #('PowerBuilderParser') ] ]
]

{ #category : #baselines }
BaselineOfPWBUtilities >> baselineOfGlorp: spec [
	spec
		baseline: 'Glorp'
		with: [ spec repository: 'github://mahugnon/glorp:master' ]
]

{ #category : #baselines }
BaselineOfPWBUtilities >> baselineOfP3: spec [
	spec
		baseline: 'P3'
		with: [ spec
				loads: #('glorp');
				repository: 'github://mahugnon/P3:master' ].
	"PharoDatabaseAccessor DefaultDriver: P3DatabaseDriver"
]

{ #category : #baselines }
BaselineOfPWBUtilities >> baselineOfPowerbuilderParser: spec [
	spec
		baseline: 'PowerBuilderParser'
		with: [ spec
				repository: 'github://mahugnon/PowerBuilderParser:changesFromSvn' ]
]

{ #category : #baselines }
BaselineOfPWBUtilities >> baselineOfXMLParser: spec [
	spec
		baseline: 'XMLParser'
		with: [ spec
				repository: 'github://pharo-contributions/XML-XMLParser:master/src' ]
]
