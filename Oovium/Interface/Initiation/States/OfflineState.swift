//
//  OfflineState.swift
//  Oovium
//
//  Created by Joe Charlier on 4/29/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class OfflineState: LaunchState {
	let view: UIView = UIView()
	let label: UILabel = UILabel()

// LaunchState =======================================================================================
	override func onActivate() {
		Oovium.window.makeKeyAndVisible()
		
		view.layer.backgroundColor = UIColor.white.cgColor
		view.layer.cornerRadius = 8
		Oovium.window.addSubview(view)
		
		label.numberOfLines = 4
		let sb: NSMutableAttributedString = NSMutableAttributedString()
		sb.append("Oovium is unable to connect to the Aepryus server at this time.  Please check your internet connection or try again later.".localized, pen: Pen(font: UIFont.systemFont(ofSize: 20.5, weight: .medium), color: .black, alignment: .center, kern: -0.2))
		label.attributedText = sb
		view.addSubview(label)
		
		let s = Screen.s
		view.center(width: 360*s, height: 140*s)
		label.center(width: view.width-20*s, height: view.height-20*s)
	}
	override func onDeactivate(_ complete: @escaping ()->()) {
		UIView.animate(withDuration: 0.2, animations: {
			self.label.alpha = 0
		}) { (completed: Bool) in
			self.label.removeFromSuperview()
			self.label.alpha = 1
			complete()
		}
	}
}
