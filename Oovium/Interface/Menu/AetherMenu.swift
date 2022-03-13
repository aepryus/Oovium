//
//  AetherMenu.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumKit
import UIKit

class AetherMenu: KeyPad {
	init(redDot: RedDot) {
		let schematic = Schematic(rows: 3, cols: 1)
		super.init(redDot: redDot, anchor: .bottomLeft, size: CGSize(width: 94, height: 214), offset: UIOffset(horizontal: 78+6, vertical: -6), fixed: RedDot.fixed, schematic: schematic)
		
		let apricot = UIColor(red: 1, green: 0.4, blue: 0.2, alpha: 1)

		schematic.add(row: 0, col: 0, key: Key(text: "clear", uiColor: apricot, {
			self.redDot.dismissRootMenu()
			self.aetherView.invokeConfirmHover("clearConfirm".localized, {
				self.aetherView.clearAether()
			})
		}))
		schematic.add(row: 1, col: 0, key: Key(text: "tron", uiColor: apricot, {
			self.redDot.dismissRootMenu()
			Skin.skin = TronSkin()
			Oovium.reRender()
		}))
		schematic.add(row: 2, col: 0, key: Key(text: "ivory", uiColor: apricot, {
			self.redDot.dismissRootMenu()
			Skin.skin = IvorySkin()
			Oovium.reRender()
		}))
//		schematic.add(row: 1, col: 0, key: Key(text: "album", uiColor: apricot, {}))
//		schematic.add(row: 2, col: 0, key: Key(text: "dropbox", uiColor: apricot, {}))
//		schematic.add(row: 3, col: 0, key: Key(text: "logoff", uiColor: apricot, {}))
		
		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}

// Events ==========================================================================================
	override func onInvoke() {
		self.redDot.dismissLinksMenu()
		self.redDot.dismissHelpMenu()
		(self.redDot.rootMenu.schematic.keySlots[0].key as! Key).active = true
	}
	override func onDismiss() {
		(self.redDot.rootMenu.schematic.keySlots[0].key as! Key).active = false
	}
}
