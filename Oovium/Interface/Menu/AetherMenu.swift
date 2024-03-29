//
//  AetherMenu.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import OoviumKit
import UIKit

class AetherMenu: KeyPad {
	init(redDot: RedDot) {
		let schematic = Schematic(rows: 4, cols: 1)
		super.init(redDot: redDot, anchor: .bottomLeft, size: CGSize(width: 124, height: 214), offset: UIOffset(horizontal: 78, vertical: 0), fixed: RedDot.fixed, schematic: schematic)
		
		let apricot = UIColor(red: 1, green: 0.4, blue: 0.2, alpha: 1)

		schematic.add(row: 0, col: 0, key: Key(text: "clear", uiColor: apricot, {
			self.redDot.dismissRootMenu()
			self.aetherView.invokeConfirmModal("clearConfirm".localized, {
				self.aetherView.clearAether()
			})
		}))

        schematic.add(row: 1, col: 0, key: Key(text: "cheat sheet", uiColor: apricot, {
            self.redDot.dismissRootMenu()
            Oovium.openStaticAether(name: "CheatSheet")
        }))

        schematic.add(row: 2, col: 0, key: Key(text: "what's new", uiColor: apricot, {
            self.redDot.dismissRootMenu()
            Oovium.openStaticAether(name: "WhatsNew")
        }))

        schematic.add(row: 3, col: 0, key: Key(text: "horizon", uiColor: apricot, {
            self.redDot.dismissRootMenu()
            Oovium.openStaticAether(name: "Horizon")
        }))

		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

// Events ==========================================================================================
	override func onInvoke() {
        self.redDot.dismissSkinMenu()
		self.redDot.dismissHelpMenu()
		(self.redDot.rootMenu.schematic.keySlots[0].key as! Key).active = true
	}
	override func onDismiss() {
		(self.redDot.rootMenu.schematic.keySlots[0].key as! Key).active = false
	}
}
