Class {
	#name : #BaselineOfPWBUtilities,
	#superclass : #BaselineOf,
	#category : #BaselineOfPWBUtilities
}

{ #category : #baselines }
BaselineOfPWBUtilities >> baseline: spec [
	<baseline>
	
	spec for: #common do: [
		spec
			package: 'PWBUtilities' 
		].

]
