//
//  HelpMenu.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumKit
import UIKit

class HelpMenu: KeyPad {
	init(redDot: RedDot) {
		let schematic = Schematic(rows: 2, cols: 1)
		super.init(redDot: redDot, anchor: .bottomLeft, size: CGSize(width: 114, height: 214), offset: UIOffset(horizontal: 78+6, vertical: -6), fixed: RedDot.fixed, uiColor: .orange, schematic: schematic)

		let apricot = UIColor(red: 1, green: 0.4, blue: 0.2, alpha: 1)

		schematic.add(row: 0, col: 0, key: Key(text: "about".localized, uiColor: apricot, {
			self.redDot.dismissRootMenu()
			if let backView = Oovium.aetherView.backView as? AboutView { backView.fade(aboutOn: true) }
		}))

        schematic.add(row: 1, col: 0, key: Key(text: "links", uiColor: apricot, {
			self.redDot.toggleLinksMenu()
		}))

		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// Events ==========================================================================================
	override func onInvoke() {
		self.redDot.dismissAetherMenu()
        self.redDot.dismissSkinMenu()
		(self.redDot.rootMenu.schematic.keySlots[2].key as! Key).active = true
	}
	override func onDismiss() {
		self.redDot.dismissLinksMenu()
		(self.redDot.rootMenu.schematic.keySlots[2].key as! Key).active = false
		(self.redDot.helpMenu.schematic.keySlots[1].key as! Key).active = false
	}
}
