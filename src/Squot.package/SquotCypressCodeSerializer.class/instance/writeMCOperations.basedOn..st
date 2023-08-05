Squot serialization
writeMCOperations: operationsCollection basedOn: originalDefinitionsCollection
	| newDefinitions classDefinitions missingClasses removedMethods removedClasses removedOthers allMethods allClasses extensions |
	removedMethods := Dictionary new.
	removedClasses := Dictionary new.
	removedOthers := Dictionary new.
	newDefinitions := OrderedCollection new: operationsCollection size.
	operationsCollection do:
		[:each |
		each isRemoval
			ifTrue: [each definition isMethodDefinition ifTrue: [removedMethods at: each definition description put: each definition].
					each definition isClassDefinition ifTrue: [removedClasses at: each definition description put: each definition].
					(each definition isMethodDefinition not and: [each definition isClassDefinition not])
						ifTrue: [removedOthers at: each definition description put: each definition]].
		each isAddition ifTrue: [newDefinitions add: each definition].
		each isModification ifTrue: [newDefinitions add: each modification]].
	"Add missing class definitions or the cypress writer will treat methods as extensions."
	classDefinitions := (newDefinitions select: [:each | each isClassDefinition]) collect: [:each | each className -> each] as: Dictionary.
	allClasses := classDefinitions copy.
	originalDefinitionsCollection do:
		[:each | (each isClassDefinition and: [(removedClasses includesKey: each description) not]) ifTrue: [allClasses at: each className ifAbsentPut: [each]]].
	missingClasses := ((((newDefinitions select: [:each | each isMethodDefinition and: [(classDefinitions includesKey: each className) not]]),
			(removedMethods values select: [:each | (classDefinitions includesKey: each className) not]))
		collect: [:each | each className] as: Set) asArray
		collect: [:each | allClasses at: each ifAbsent: []])
		reject: [:each | each isNil].
	cypressWriter writeDefinitions: newDefinitions, missingClasses.
	"Fix up methodProperties.json files (they now only include the methods that were newly written)."
	allMethods := (newDefinitions select: [:each | each isMethodDefinition]) collect: [:each | each description -> each] as: Dictionary.
	originalDefinitionsCollection do:
		[:each | (each isMethodDefinition and: [(removedMethods includesKey: each description) not]) ifTrue: [allMethods at: each description ifAbsentPut: [each]]].
	allMethods := allMethods groupBy: [:each | each className].
	classDefinitions asArray, missingClasses do:
		[:each |
		cypressWriter writeInDirectoryName: each className, (each isTraitDefinition ifTrue: ['.trait'] ifFalse: ['.class']), cypressWriter fileUtils pathNameDelimiter
			fileName: 'methodProperties'
			extension: cypressWriter propertyFileExtension
			visit: [cypressWriter writeMethodProperties: (allMethods at: each className ifAbsent: [#()])]].
	"Fix up methodProperties.json for class extensions"
	extensions := allMethods keys reject: [:each | allClasses includesKey: each].
	extensions do:
		[:each |
		cypressWriter writeInDirectoryName: each, '.extension', cypressWriter fileUtils pathNameDelimiter asString
			fileName: 'methodProperties'
			extension: cypressWriter propertyFileExtension
			visit: [cypressWriter writeMethodProperties: (allMethods at: each)]].
	"Delete removed items"
	definitions := allMethods values concatenation, allClasses values.
	removedOthers, removedMethods, removedClasses do: [:each | self delete: each].
	"Delete empty extensions"
	((((removedMethods groupBy: [:each | each className]) keys
		copyWithoutAll: allMethods keys) "to preserve still existing extensions"
		copyWithoutAll: allClasses keys) "to preserve classes (not extensions) without methods"
		copyWithoutAll: (removedClasses collect: [:each | each className] as: Array)) "these are not extensions"
		do: [:each | self deleteExtension: each].