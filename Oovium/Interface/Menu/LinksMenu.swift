//
//  LinksMenu.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumKit
import UIKit

class LinksMenu: KeyPad {
	init(redDot: RedDot) {
		let schematic = Schematic(rows: 4, cols: 1)
		super.init(redDot: redDot, anchor: .bottomLeft, size: CGSize(width: 104, height: 214), offset: UIOffset(horizontal: 78+6+114+1, vertical: -6), fixed: RedDot.fixed, schematic: schematic)
		
		let apricot = UIColor(red: 1, green: 0.4, blue: 0.2, alpha: 1)

		schematic.add(row: 0, col: 0, key: Key(text: NSLocalizedString("oovium", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: apricot, {
			self.redDot.dismissRootMenu()
			UIApplication.shared.open(URL(string: "http://aepryus.com/Principia?view=article&articleID=3")!, options: [:], completionHandler: nil)
		}))
		
		schematic.add(row: 1, col: 0, key: Key(text: NSLocalizedString("reddit", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: apricot, {
			self.redDot.dismissRootMenu()
			UIApplication.shared.open(URL(string: "https://www.reddit.com/r/Oovium/")!, options: [:], completionHandler: nil)
		}))
		
		schematic.add(row: 2, col: 0, key: Key(text: NSLocalizedString("vimeo", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: apricot, {
			self.redDot.dismissRootMenu()
			UIApplication.shared.open(URL(string: "https://vimeo.com/aepryus")!, options: [:], completionHandler: nil)
		}))
		
		schematic.add(row: 3, col: 0, key: Key(text: NSLocalizedString("review", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: apricot, {
			self.redDot.dismissRootMenu()
			UIApplication.shared.open(URL(string: "http://itunes.apple.com/app/oovium/id336573328?mt=8")!, options: [:], completionHandler: nil)
		}))

		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

// Events ==========================================================================================
	override func onInvoke() {
		(self.redDot.helpMenu.schematic.keySlots[4].key as! Key).active = true
	}
	override func onDismiss() {
		(self.redDot.helpMenu.schematic.keySlots[4].key as! Key).active = false
	}
}
