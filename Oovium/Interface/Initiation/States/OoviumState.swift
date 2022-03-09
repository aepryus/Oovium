//
//  OoviumState.swift
//  Oovium
//
//  Created by Joe Charlier on 4/30/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class OoviumState: LaunchState {
	static let behindView: BehindView = BehindView()

// LaunchState =======================================================================================
	override func onActivate() {
		Math.start()
		Space.loadSpaces {}

		if Oovium.aetherController == nil {
			Oovium.aetherView = AetherView()
			Oovium.aetherView.aetherViewDelegate = Oovium.aetherViewDelegate

			Oovium.aetherController = OoviumController()

			Oovium.aetherController.view.addSubview(OoviumState.behindView)
			OoviumState.behindView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height)

			Oovium.aetherController.view.addSubview(Oovium.aetherView)
			Oovium.window.rootViewController = Oovium.aetherController
			Oovium.aetherView.frame = CGRect(x: 0, y: Screen.mac ? Screen.safeTop : 0, width: Oovium.aetherController.view.width, height: Oovium.aetherController.view.height - (Screen.mac ? Screen.safeTop : 0))

			Oovium.window.backgroundColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)

			if	let aetherPath: String = Local.get(key: "aetherPath") {
				Space.digest(aetherPath: aetherPath) { (spaceAether: (Space, Aether)?) in
					guard let spaceAether = spaceAether else { return }
					Oovium.space = spaceAether.0
					Oovium.aetherView.swapToAether(space: spaceAether.0, aether: spaceAether.1)
				}
			} else {
				Local.set(key: "aetherPath", value: Space.local.aetherPath(aether: Oovium.aetherView.aether))
				Space.local.storeAether(Oovium.aetherView.aether) { (success: Bool) in }
			}
		}
	}
	override func onDeactivate(_ complete: @escaping ()->()) {
		UIView.animate(withDuration: 0.2, animations: {
			Oovium.window.alpha = 0
		}) { (finished: Bool) in
			Oovium.window.isHidden = true
			complete()
		}
	}
}
