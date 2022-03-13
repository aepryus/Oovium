//
//  BackView.swift
//  Oovium
//
//  Created by Joe Charlier on 2/23/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import OoviumKit
import UIKit

class BackView: UIView {
	var image: UIImage? = nil
	var rect: CGRect? = nil
	var fade: UIImageView? = nil
	var tagline: String = ""
	var lastAboutOn: Bool = false
	var lastStart: Date? = nil
	var pauseAboutOn: Bool = false
	var pausePercent: Double = 0
	var tally: IntMap = IntMap()
	var timeToFade: Double = 8
	var screenBurn: Bool = true

	override init(frame: CGRect) {
		super.init(frame: frame)
		reload()
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}

	private func rerender(view: UIView) {
		view.setNeedsDisplay()
		for v in view.subviews {
			self.rerender(view: v)
		}
	}
	private func fadeStop() {
		fade?.removeFromSuperview()
		lastStart = nil
		fade = nil
	}
	@objc private func tryFadeStop() {
		if tally.decrement(key: "fades") == 0 {
			fadeStop()
		}
	}
	private func grabImage() -> UIImage {
		if !Screen.iPhone { return UIImage(named: "BurnMac")! }
		let height = max(Screen.height, Screen.width)
		if height == 568 { return UIImage(named: "Burn568")! }
		else if height == 667 { return UIImage(named: "Burn667")! }
		else if height == 736 { return UIImage(named: "Burn736")! }
		else if height == 812 { return UIImage(named: "Burn812")! }
		else if height == 1024 { return UIImage(named: "Burn1024")! }
		else if height == 1112 { return UIImage(named: "Burn1112")! }
		else if height == 1194 { return UIImage(named: "Burn1194")! }
		else if height == 1366 { return UIImage(named: "Burn1366")! }
		else { return UIImage(named: "Burn667")! }
	}

	func reload() {
		if Oovium.screenBurn {
			backgroundColor = Skin.backColor
			image = grabImage()
		} else {
			backgroundColor = UIColor.clear
		}
		rerender(view: self)
	}
	private func fade(aboutOn: Bool, percent: Double) {
		fadeStop()
		if percent == 1 { tagline = !Screen.iPhone ? Oovium.tagline() : "a bicycle for the mind" }
		lastAboutOn = aboutOn
		lastStart = Date().addingTimeInterval(-timeToFade*(1-percent))
		_ = tally.increment(key: "fades")
		let image = grabImage()
		let rect = frame
		fade = UIImageView(frame: rect)

		UIGraphicsBeginImageContext(rect.size)
		if Screen.iPhone { image.draw(in: rect) }
		else { image.draw(at: CGPoint.zero) }
		if aboutOn {
			let aboutView = AboutView()
			aboutView.tagline = tagline
			aboutView.draw(rect)
		}
		fade!.image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		addSubview(fade!)
		sendSubviewToBack(fade!)
		fade!.alpha = CGFloat(percent)

		UIView.animate(withDuration: timeToFade*percent, animations: {
			self.fade!.alpha = 0
		}) { (complete: Bool) in
			self.tryFadeStop()
		}
	}
	func fade(aboutOn: Bool) {
		fade(aboutOn: aboutOn, percent: 1)
	}
	func fadePause() {
		if let lastStart = lastStart {
			pauseAboutOn = lastAboutOn
			let interval = -lastStart.timeIntervalSinceNow
			pausePercent = (timeToFade-interval)/timeToFade
		} else {
			pausePercent = 0
		}
	}
	func fadeRestart() {
		guard pausePercent > 0 else {return}
		fade(aboutOn: pauseAboutOn, percent: pausePercent)
	}
	func fadeToBack() {
		guard let fade = fade else {return}
		sendSubviewToBack(fade)
	}

// UIView ==========================================================================================
	override var frame: CGRect {
		didSet { setNeedsDisplay() }
	}
	override func draw(_ rect: CGRect) {
		if Oovium.screenBurn, let image = image {
			if Screen.iPhone {
				image.draw(in: rect, blendMode: .normal, alpha: Skin.fadePercent)
			} else {
				image.draw(at: CGPoint.zero, blendMode: .normal, alpha: Skin.fadePercent)

				var aboutOn: Bool = false
				var percent: Double = 0
				if let lastStart = lastStart {
					aboutOn = lastAboutOn
					let interval = -lastStart.timeIntervalSinceNow
					percent = (timeToFade-interval)/timeToFade
				} else {
					percent = 0
				}
				fade(aboutOn: aboutOn, percent: percent)
			}
		}
	}
}
