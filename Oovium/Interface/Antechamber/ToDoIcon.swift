//
//  ToDoIcon.swift
//  Oovium
//
//  Created by Joe Charlier on 1/13/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Foundation

class ToDoIcon: StickyIcon {
	init() {
		super.init(frame: .zero)

		text = "To Do".localized
	}
	required init?(coder: NSCoder) {fatalError()}
}
