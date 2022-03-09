//
//  Launch.swift
//  Oovium
//
//  Created by Joe Charlier on 4/12/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import AuthenticationServices
import Foundation
import OoviumKit

class LaunchWindow: UIWindow {
	override init(frame: CGRect) {
		super.init(frame: frame)
		clipsToBounds = true
	}
	required init?(coder: NSCoder) { fatalError() }
}
class LaunchViewController: UIViewController {
// UIViewController ================================================================================
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .darkContent
	}
	override var prefersHomeIndicatorAutoHidden: Bool {
		return true
	}
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return Screen.iPhone ? .portrait : .landscape
	}
	override func viewDidLoad() {
		view.backgroundColor = .clear
	}
//	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//		super.viewWillTransition(to: size, with: coordinator)
//		print("LaunchWindow transitioning")
//	}
}

class LaunchState: NSObject {
	func onActivate() {}
	func onDeactivate(_ complete: @escaping ()->()) {}
}

class Launch {
	static var currentState: LaunchState? = nil
	
	static func shiftTo(_ state: LaunchState) {
		guard state !== currentState else {return}
		Log.print("Switching to [\(String(describing: type(of: state)))]")
		let oldState: LaunchState? = currentState
		currentState = state
		DispatchQueue.main.async {
			if let oldState = oldState { oldState.onDeactivate { state.onActivate() } }
			else { state.onActivate() }
		}
	}
	
	static let blank: BlankState = BlankState()
	static let offline: OfflineState = OfflineState()
	static let oovium: OoviumState = OoviumState()
	static let signUp: SignUpState = SignUpState()
	static let subscribe: SubscribeState = SubscribeState()
	
	static func shiftToBlank() { shiftTo(blank) }
	static func shiftToOffline() { shiftTo(offline) }
	static func shiftToOovium() { shiftTo(oovium) }
	static func shiftToSignUp() { shiftTo(signUp) }
	static func shiftToSubscribe() { shiftTo(subscribe) }
}
