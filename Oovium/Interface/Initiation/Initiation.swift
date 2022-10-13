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
	override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
	override var prefersHomeIndicatorAutoHidden: Bool { true }
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { Screen.iPhone ? .portrait : .landscape }
	override func viewDidLoad() {
        view.backgroundColor = .clear
	}
}

class LaunchState: NSObject {
	func onActivate() {}
	func onDeactivate(_ complete: @escaping ()->()) {}
}

class Launch {
	static var currentState: LaunchState? = nil
	
	static func shiftTo(_ state: LaunchState) {
		guard state !== currentState else { return }
		Log.print("Switching to [\(String(describing: type(of: state)))]")
		let oldState: LaunchState? = currentState
		currentState = state
		DispatchQueue.main.async {
			if let oldState = oldState { oldState.onDeactivate { state.onActivate() } }
			else { state.onActivate() }
		}
	}
	
	static let oovium: OoviumState = OoviumState()
	
	static func shiftToOovium() { shiftTo(oovium) }
}
