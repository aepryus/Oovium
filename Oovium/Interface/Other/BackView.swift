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
        guard !Screen.mac else { return UIImage(named: "BurnMac")! }
        
        let name: String
        switch Screen.dimensions {
            case .dim320x480:   fatalError()
            case .dim320x568:   name = "Burn568"
//            case .dim360x780:   name = ""
            case .dim375x667:   name = "Burn667"
            case .dim375x812:   name = "Burn812"
            case .dim390x844:   name = "Burn844"
            case .dim414x736:   name = "Burn736"
//            case .dim414x896:   name = ""
//            case .dim428x926:   name = ""
            case .dim1024x768:  name = "Burn1024"
//            case .dim1080x810:  name = ""
            case .dim1112x834:  name = "Burn1112"
//            case .dim1133x744:  name = ""
//            case .dim1180x820:  name = ""
            case .dim1194x834:  name = "Burn1194"
            case .dim1366x1024: name = "Burn1366"
//            case .dimOther:     name = ""
            default:            name = "Burn667"
        }
        
        return UIImage(named: name)!
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
