toolbuilder
buildWindow: builder
	^ builder pluggableWindowSpec new
		model: self;
		children: (SquotGUIUtilities windowChild: (self buildLayout: builder));
		label: 'Asset Browser';
		yourself