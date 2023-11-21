actions
actionMove
	| newPath |
	self selectedMapper ifNil: [^ self inform: 'Please select an asset first.'].
	newPath := (self activeWorkingCopy
					requestUnmappedPathWithTitle:
						('New path for asset ''{1}'':' format: {self selectedMapper printStringWithoutPath})
					initialAnswer: (SquotPathUtilities asString: self selectedMapper path))
						ifNil: [^ self].
	self selectedMapper moveTo: newPath in: self activeWorkingCopy.
	self changed: #selectedAsset. "path changed"