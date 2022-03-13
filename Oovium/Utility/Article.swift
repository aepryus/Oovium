//
//  Article.swift
//  Oovium
//
//  Created by Joe Charlier on 1/5/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import OoviumEngine

class Article: Domain {
	@objc dynamic var date: Date = Date()
	@objc dynamic var title: String = ""
	@objc dynamic var desc: String = ""
	@objc dynamic var aether: Aether!

// Domain ==========================================================================================
	override var properties: [String] {
		return super.properties + ["date", "title", "desc", "aether"]
	}
}
