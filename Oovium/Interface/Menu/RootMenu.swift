//
//  RootMenu.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RootMenu: Hover {
	let schematic: Schematic
	var path: CGPath
	unowned let redDot: RedDot
	
	init(redDot: RedDot) {
		self.redDot = redDot
		self.schematic = Schematic(rows: 3, cols: 1)
		
		path = RootMenu.renderPath()

		super.init(aetherView: redDot.aetherView, anchor: .bottomLeft, size: CGSize(width: 78, height: 214), offset: UIOffset(horizontal: 6, vertical: -6), fixed: RedDot.fixed)

		let apricot = UIColor(red: 1, green: 0.4, blue: 0.2, alpha: 1)
		
		schematic.add(row: 0, col: 0, key: Key(text: "aether", uiColor: apricot, { self.redDot.toggleAetherMenu() }))
		schematic.add(row: 1, col: 0, key: Key(text: "lobby", uiColor: apricot, {
			self.dismiss()
			Oovium.aetherView.invokeAntechamper()
//			Hovers.invokeAntechamber()
		}))
		schematic.add(row: 2, col: 0, key: Key(text: "help", uiColor: apricot, { self.redDot.toggleHelpMenu() }))
		
		schematic.render(rect: CGRect(x: 0, y: 0, width: 78*Oo.s, height: 177*Oo.s))
		
		for keySlot in schematic.keySlots {
			addSubview(keySlot.key)
		}
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	static func renderPath() -> CGPath {
		
		let r = 10*Oo.s
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: 45*Oo.s, y: 3))
		path.addArc(tangent1End: CGPoint(x: 3*Oo.s, y: 3), tangent2End: CGPoint(x: 3*Oo.s, y: 81*Oo.s), radius: r)
		path.addArc(tangent1End: CGPoint(x: 3*Oo.s, y: 176*Oo.s), tangent2End: CGPoint(x: 29, y: 176*Oo.s), radius: r)
		path.addArc(tangent1End: CGPoint(x: 38*Oo.s, y: 176*Oo.s), tangent2End: CGPoint(x: 38*Oo.s, y: 191*Oo.s), radius: r)
		path.addArc(tangent1End: CGPoint(x: 38*Oo.s, y: 211*Oo.s), tangent2End: CGPoint(x: 65*Oo.s, y: 211*Oo.s), radius: r)
		path.addArc(tangent1End: CGPoint(x: 75*Oo.s, y: 211*Oo.s), tangent2End: CGPoint(x: 75*Oo.s, y: 107*Oo.s), radius: r)
		path.addArc(tangent1End: CGPoint(x: 75*Oo.s, y: 3), tangent2End: CGPoint(x: 45*Oo.s, y: 3), radius: r)
		path.closeSubpath()
		
		return path
	}

// Events ==========================================================================================
	override func onDismiss() {
		self.redDot.dismissAetherMenu()
		self.redDot.dismissLinksMenu()
		self.redDot.dismissHelpMenu()
		(schematic.keySlots[0].key as! Key).active = false
		(schematic.keySlots[2].key as! Key).active = false
	}
	
// Hover ===========================================================================================
	override func rescale() {
		super.rescale()
		schematic.render(rect: CGRect(x: 0, y: 0, width: 78*Oo.s, height: 174*Oo.s))
		path = RootMenu.renderPath()
	}
	override func retract() {
		dismiss()
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		Skin.panel(path: path, uiColor: UIColor.orange)
	}
}
