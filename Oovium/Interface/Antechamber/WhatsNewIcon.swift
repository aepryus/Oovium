//
//  WhatsNewIcon.swift
//  Oovium
//
//  Created by Joe Charlier on 1/13/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Foundation

class WhatsNewIcon: StickyIcon {
	init() {
		super.init(frame: .zero)
		
		text = "What's New".localized
	}
	required init?(coder: NSCoder) { fatalError() }
}
