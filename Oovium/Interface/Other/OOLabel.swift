//
//  OOLabel.swift
//  Oovium
//
//  Created by Joe Charlier on 12/30/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumKit
import UIKit

class OOLabel: UIView {
	var text: String
	var pen: Pen
	
	init(text: String = "", pen: Pen = Pen(font: UIFont.oovium(size: 16), alignment: .center)) {
		self.text = text
		self.pen = pen
		super.init(frame: .zero)
		backgroundColor = .clear
	}
	required init?(coder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		Skin.bubble(text: text, rect: rect, pen: pen)
	}
}
