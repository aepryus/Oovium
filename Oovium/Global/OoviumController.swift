//
//  OoviumController.swift
//  Oovium
//
//  Created by Joe Charlier on 2/23/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumKit
import UIKit

class OoviumController: UIViewController {

    func stretch() {
		Oovium.aetherView.stretch()
		Oovium.aetherView.needsStretch = false
	}

//// External Keyboard ===============================================================================
//	private let secretResponder: UITextField = UITextField()
//	func checkForExternalKeyboard() {
//		Oovium.hasExternalKeyboard = true
//		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//		view.addSubview(secretResponder)
//		secretResponder.becomeFirstResponder()
//	}
//	@objc func onKeyboardWillShow(_ notification: Notification) {
////		Oovium.hasExternalKeyboard = false
//		NotificationCenter.default.removeObserver(self)
//		secretResponder.resignFirstResponder()
//		secretResponder.removeFromSuperview()
//	}
	
// UIViewController ================================================================================
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return Skin.statusBarStyle
	}
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .fade
	}
	override var prefersHomeIndicatorAutoHidden: Bool {
		return true
	}
//	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//		return Hovers.forcedOrientation
//	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
        
        if Screen.mac {
            Oovium.aetherView.frame = CGRect(x: Oovium.aetherView.left, y: Oovium.aetherView.top, width: size.width, height: size.height-Oovium.aetherView.top)
            OoviumState.behindView.frame = CGRect(origin: OoviumState.behindView.frame.origin, size: CGSize(width: OoviumState.behindView.width, height: size.height-OoviumState.behindView.top))
        } else {
            // [ Hack ] This assumes that safeTop == safeLeft in order to anticipate safeLeft before the animation occurs.  Can't use the coordinator because the Hovers get messed up. jjc 10/10/22
            let safeLeft: CGFloat = size.width == Screen.width ? 0 : max(Screen.safeTop, Screen.safeLeft)
            let x: CGFloat = Oovium.aetherView.left == 0 ? 0 : Screen.iPhone ? Screen.width - 20*Screen.s + safeLeft : 355*Screen.s
            Oovium.aetherView.frame = CGRect(x: x, y: Oovium.aetherView.top, width: size.width, height: size.height-Oovium.aetherView.top)
            OoviumState.behindView.frame = CGRect(origin: OoviumState.behindView.frame.origin, size: CGSize(width: OoviumState.behindView.width, height: size.height-OoviumState.behindView.top))
        }
        coordinator.animate { (context: UIViewControllerTransitionCoordinatorContext) in
            Modal.shieldView.render()
        }
	}
}
