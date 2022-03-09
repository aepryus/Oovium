//
//  BlankState.swift
//  Oovium
//
//  Created by Joe Charlier on 5/5/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import UIKit

class BlankState: LaunchState {
// LaunchState =======================================================================================
	override func onActivate() {
		if !Oovium.window.isHidden {
			UIView.animate(withDuration: 0.2, animations: {
				Oovium.window.rootViewController?.view.subviews.forEach {$0.alpha = 0}
			}) { (finsihed: Bool) in
				Oovium.window.rootViewController?.view.subviews.forEach {$0.removeFromSuperview()}
			}
		} else {
			Oovium.window.rootViewController?.view.subviews.forEach {$0.removeFromSuperview()}
			Oovium.window.makeKeyAndVisible()
		}
	}
	override func onDeactivate(_ complete: @escaping ()->()) { complete() }
}
