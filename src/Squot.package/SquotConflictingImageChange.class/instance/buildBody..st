toolbuilder
buildBody: builder
	^ builder pluggablePanelSpec new
		children: ({
			(LayoutFrame fractions: (0 @ 0 corner: 0.5 @ 0.5))
				-> (self buildVersion: self base label: 'Base:'
						resolveAction: #resolveToBase with: builder).
			(LayoutFrame fractions: (0.5 @ 0 corner: 1 @ 0.5))
				-> (self buildVersion: self left label: 'Current:'
						resolveAction: #resolveToLeft with: builder).
			(LayoutFrame fractions: (0 @ 0.5 corner: 0.5 @ 1))
				-> (self buildVersion: self right label: 'Incoming:'
						resolveAction: #resolveToRight with: builder).
			(LayoutFrame fractions: (0.5 @ 0.5 corner: 1 @ 1))
				-> (self buildResolutionPanel: builder).
		} collect: [:each |
			builder pluggablePanelSpec new
				children: {each value};
				frame: each key;
				yourself]);
		yourself