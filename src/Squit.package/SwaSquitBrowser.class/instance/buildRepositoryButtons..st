toolbuilder
buildRepositoryButtons: aBuilder

	^ aBuilder pluggablePanelSpec new
		layout: #horizontal;
		children: {
			aBuilder pluggableButtonSpec new
				model: self;
				label: 'Pull (Fetch & Merge)';
				action: #actionPull.
			aBuilder pluggableButtonSpec new
				model: self;
				label: 'Commit & Push';
				action: #actionCommitAndPush };
		frame: (LayoutFrame new
			leftFraction: 0 offset: 0;
			topFraction: 1 offset: self buttonHeight negated;
			rightFraction: 1 offset: 0;
			bottomFraction: 1 offset: 0)