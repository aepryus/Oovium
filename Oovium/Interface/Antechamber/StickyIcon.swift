//
//  StickyIcon.swift
//  Oovium
//
//  Created by Joe Charlier on 1/13/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class StickyIcon: UIControl {
	let mint: UIColor = UIColor(rgb: 0xACDFC9)
	let creamsicle: UIColor = UIColor(rgb: 0xDFC9AC)

	var text: String = ""
	var active: Bool = false {
		didSet { setNeedsDisplay() }
	}
	
	var textColor: UIColor {
		return active ? creamsicle : mint
	}
	var pen: Pen = Pen(font: UIFont(name: "Avenir-Oblique", size: 16*Screen.s)!, alignment: .center)
	var borderColor: UIColor {
		return active ? creamsicle : mint
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let path: CGPath = CGPath(roundedRect: rect.insetBy(dx: 2*s, dy: 2*s), cornerWidth: 12*s, cornerHeight: 5*s, transform: nil)
		if active { Skin.gridCalc(path: path, uiColor: creamsicle.shade(0.5)) }
		Skin.bubble(path: path, uiColor: borderColor, width: 1*s)
		Skin.bubble(text: text, rect: rect, uiColor: textColor, pen: pen)
	}
}
