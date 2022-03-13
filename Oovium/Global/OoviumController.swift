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
	let backView: UIView = UIView()
	let shieldView: UIView = UIView()
	let canopyView: UIView = UIView()
	
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
			Oovium.aetherView.frame = CGRect(x: 0, y: Oovium.window.safeAreaInsets.top, width: size.width, height: size.height-Oovium.window.safeAreaInsets.top)
		} else {
			Oovium.aetherView.frame = CGRect(origin: .zero, size: size)
		}
		Oovium.aetherView.stretch()
	}
}
