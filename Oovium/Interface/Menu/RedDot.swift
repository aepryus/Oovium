//
//  RedDot.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumKit
import UIKit

class RedDot: Hover, UIGestureRecognizerDelegate {
	lazy var rootMenu: RootMenu = { RootMenu(redDot: self) }()
	lazy var aetherMenu: AetherMenu = { AetherMenu(redDot: self) }()
    lazy var skinMenu: SkinMenu = { SkinMenu(redDot: self) }()
	lazy var helpMenu: HelpMenu = { HelpMenu(redDot: self) }()
	lazy var linksMenu: LinksMenu = { LinksMenu(redDot: self) }()

    static let fixed: UIOffset = .zero

	init(aetherView: AetherView) {
		super.init(aetherView: aetherView, anchor: .bottomLeft, size: CGSize(width: 46, height: 46), offset: .zero, fixed: RedDot.fixed)

		var gesture: UIGestureRecognizer = TouchGesture(target: self, action: #selector(onTouch))
		gesture.delegate = self
		addGestureRecognizer(gesture)
		
		gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
		gesture.delegate = self
		addGestureRecognizer(gesture)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func fade() {
		alpha = 1
		UIView.animate(withDuration: 0.5, delay: 2, options: [.allowUserInteraction], animations: {
			self.alpha = 0.5
		}, completion: nil)
	}

	func toggleRootMenu() { rootMenu.toggle() }
	func dismissRootMenu() { rootMenu.dismiss() }

	func toggleAetherMenu() { aetherMenu.toggle() }
	func dismissAetherMenu() { aetherMenu.dismiss() }

    func toggleSkinMenu() { skinMenu.toggle() }
    func dismissSkinMenu() { skinMenu.dismiss() }

	func toggleHelpMenu() { helpMenu.toggle() }
	func dismissHelpMenu() { helpMenu.dismiss() }

	func toggleLinksMenu() { linksMenu.toggle() }
	func dismissLinksMenu() { linksMenu.dismiss() }

// Hover ===========================================================================================
	@objc func onTouch() {
		fade()
	}
	@objc func onTap() {
		toggleRootMenu()
		superview?.bringSubviewToFront(self)
	}
	override func onFadeIn() {
		fade()
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let rect = CGRect(x: (13-6)*Oo.s, y: (13+6)*Oo.s, width: 20*Oo.s, height: 20*Oo.s)
		let path = CGPath(roundedRect: rect, cornerWidth: 10*Oo.s, cornerHeight: 10*Oo.s, transform: nil)
		let c = UIGraphicsGetCurrentContext()!
		
		c.setStrokeColor(UIColor.red.withAlphaComponent(0.3).cgColor)
		c.setLineWidth(6)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setStrokeColor(UIColor.red.withAlphaComponent(0.6).cgColor)
		c.setLineWidth(4)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setFillColor(UIColor.red.cgColor)
		c.setLineWidth(2)
		c.addPath(path)
		c.drawPath(using: .fill)
		
		c.setStrokeColor(UIColor.white.withAlphaComponent(0.07).cgColor)
		c.addPath(path)
		c.drawPath(using: .stroke)
	}
	
// UIGestureRecognizerDelegate =====================================================================
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
