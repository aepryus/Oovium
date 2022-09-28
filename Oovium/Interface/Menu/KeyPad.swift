//
//  KeyPad.swift
//  Oovium
//
//  Created by Joe Charlier on 4/10/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumKit
import UIKit

public class KeyPad: Hover {
	let uiColor: UIColor
	var schematic: Schematic {
		didSet { renderSchematic() }
	}
	unowned let redDot: RedDot

	init(redDot: RedDot, anchor: Position, size: CGSize, offset: UIOffset, fixed: UIOffset, uiColor: UIColor = UIColor.orange, schematic: Schematic = Schematic(rows: 1, cols: 1)) {
		self.redDot = redDot
		self.uiColor = uiColor
		self.schematic = schematic
		super.init(aetherView: redDot.aetherView, anchor: anchor, size: size, offset: offset, fixed: fixed)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

	private func renderSchematic() {
		for view in subviews {
			view.removeFromSuperview()
		}
		
		schematic.render(rect: bounds)
		
		for keySlot in schematic.keySlots {
			addSubview(keySlot.key)
		}
	}

// Hover ===========================================================================================
//	override func rescale() {
//		super.rescale()
//		renderSchematic()
//	}
//	override func reRender() {
//		schematic.keySlots.forEach { $0.key.setNeedsDisplay() }
//	}

// UIView ==========================================================================================
	override public func draw(_ rect: CGRect) {
		let path = CGMutablePath()
		path.addRoundedRect(in: rect.insetBy(dx: 2*Oo.s, dy: 2*Oo.s), cornerWidth: 10*Oo.s, cornerHeight: 10*Oo.s)
		Skin.panel(path: path, uiColor: uiColor)
	}
}
