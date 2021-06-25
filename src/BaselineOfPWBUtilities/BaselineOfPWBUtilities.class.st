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
			spec package: 'PWBUtilities' ]
]

{ #category : #baselines }
BaselineOfPWBUtilities >> baselineOfXMLParser: spec [
	spec
		baseline: 'XMLParser'
		with: [ spec
				repository: 'github://pharo-contributions/XML-XMLParser:master/src' ]
]
