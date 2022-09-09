toolbuilder
buildCommitList: aBuilder

	^ aBuilder pluggableMultiColumnListSpec new
		model: self;
		list: #commitColumns;
		getIndex: #commitListIndex;
		hScrollBarPolicy: #whenNeeded;
		setIndex: #commitListIndex:;
		columnResizings: #(#shrinkWrap #shrinkWrap #shrinkWrap #spaceFill);
		itemAlignments: #(#right #left #left #left);
		itemPaddings: {5 @ 0. 5 @ 0. 5 @ 0. 5 @ 0};
		menu: #commitListMenu:;
		frame: (LayoutFrame new
			leftFraction: 0 offset: 0;
			topFraction: 0 offset: self buttonHeight;
			rightFraction: 1 offset: 0;
			bottomFraction: 1 offset: self buttonHeight negated)