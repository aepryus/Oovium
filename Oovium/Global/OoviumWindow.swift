//
//  OoviumWindow.swift
//  Oovium
//
//  Created by Joe Charlier on 2/23/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

class OoviumWindow: UIWindow {
	var delayGesture: UIGestureRecognizer?

	override init(frame: CGRect) {
		super.init(frame: frame)
		delayGesture = gestureRecognizers?.first(where: { $0.delaysTouchesBegan == true })
	}
	required init?(coder: NSCoder) { fatalError() }

	func turnOffDelay() { delayGesture?.delaysTouchesBegan = false }
	func turnOnDelay() { delayGesture?.delaysTouchesBegan = true }
}
