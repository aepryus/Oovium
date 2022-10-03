//
//  OoviumState.swift
//  Oovium
//
//  Created by Joe Charlier on 4/30/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import OoviumKit
import UIKit

class OoviumState: LaunchState {
	static let behindView: BehindView = BehindView(aetherView: Oovium.aetherView)

// LaunchState =======================================================================================
	override func onActivate() {
		Math.start()

		if Oovium.aetherController == nil {
			Oovium.aetherView = AetherView()
            Oovium.aetherView.backgroundColor = .white.shade(0.04)
			Oovium.aetherView.backView = AboutView()
            Oovium.aetherView.aetherViewDelegate = UIApplication.shared.delegate as! OoviumDelegate
            Oovium.redDot = RedDot(aetherView: Oovium.aetherView)

            Oovium.aetherController = OoviumController()

			Oovium.aetherController.view.addSubview(OoviumState.behindView)
			OoviumState.behindView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height)
            OoviumState.behindView.controller.viewController = Oovium.aetherController

			Oovium.aetherController.view.addSubview(Oovium.aetherView)
			Oovium.window.rootViewController = Oovium.aetherController
			Oovium.aetherView.frame = CGRect(x: 0, y: Screen.mac ? Screen.safeTop : 0, width: Oovium.aetherController.view.width, height: Oovium.aetherController.view.height - (Screen.mac ? Screen.safeTop : 0))
            if !Screen.mac { Oovium.redDot.invoke() }

			Oovium.window.backgroundColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)
            
            DispatchQueue.main.async { (Oovium.aetherView.backView as! AboutView).fade(aboutOn: false) }
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
