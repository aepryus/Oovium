//
//  PathView.swift
//  Oovium
//
//  Created by Joe Charlier on 12/29/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumKit
import UIKit

class PathView: UIView {
	var path: CGPath? = nil {
		didSet {
			guard let path = path else { return }
			let box = path.boundingBox.insetBy(dx: -2, dy: -2)
			var transform = CGAffineTransform(translationX: -box.origin.x, y: -box.origin.y)
			self.path = path.copy(using: &transform)!
			frame = box
			contentView?.center(width: width-4*Oo.s, height: height-4*Oo.s)
		}
	}
	let uiColor: UIColor
	var contentView: UIView? = nil {
		didSet {
			if let contentView = contentView {
				addSubview(contentView)
				setNeedsLayout()
			} else {
				oldValue?.removeFromSuperview()
			}
		}
	}
	
	init(uiColor: UIColor) {
		self.uiColor = uiColor
		super.init(frame: .zero)
		backgroundColor = UIColor.clear
	}
	required init?(coder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		guard let path = path else { return }

		let w: CGFloat = 4/3
		let c = UIGraphicsGetCurrentContext()!
		
		c.setFillColor(uiColor.shade(0.9).alpha(0.8).cgColor)
		c.addPath(path)
		c.drawPath(using: .fill)
		
		c.setStrokeColor(uiColor.alpha(0.4).cgColor)
		c.setLineWidth(3*w)
		c.addPath(path)
		c.drawPath(using: .stroke)

		c.setStrokeColor(uiColor.alpha(0.6).cgColor)
		c.setLineWidth(2*w)
		c.addPath(path)
		c.drawPath(using: .stroke)

		c.setStrokeColor(uiColor.tint(0.75).cgColor)
		c.setLineWidth(w)
		c.addPath(path)
		c.drawPath(using: .stroke)
	}
}
