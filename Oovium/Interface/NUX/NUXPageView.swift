//
//  NUXPage.swift
//  Oovium
//
//  Created by Joe Charlier on 6/27/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

struct NUXBlurb {
	let text: String
	let center: CGPoint
	let point: [CGPoint]
}

struct NUXPage {
	let color: UIColor
	let screenShot: String
	let title: String
	let pitch: String
	let parting: String
}

class NUXPageView: UIView {
	let imageView: UIImageView = UIImageView()
	let titleLabel: UILabel = UILabel()
	let pitchLabel: UILabel = UILabel()
	let partingLabel: UILabel = UILabel()
	var blurbs: [UIView] = []
	var bubbles: [UIView] = []
	
	var blurbNo: Int = 0
	
	let timer: AETimer = AETimer()
	
	init(page: NUXPage) {
		super.init(frame: .zero)

		backgroundColor = page.color

		let s: CGFloat = Screen.mac ? Screen.height/768 : Screen.s

		imageView.image = UIImage(named: page.screenShot)
		imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
		imageView.layer.shadowColor = UIColor.black.cgColor
		imageView.layer.shadowOpacity = 1
		imageView.layer.shadowRadius = 5*s
		addSubview(imageView)
		
		titleLabel.text = page.title
		titleLabel.textColor = .black
		titleLabel.textAlignment = .center
		titleLabel.numberOfLines = 0
		addSubview(titleLabel)
//		titleLabel.backgroundColor = UIColor.red.tint(0.3)

		pitchLabel.text = page.pitch
		pitchLabel.textAlignment = .center
		pitchLabel.textColor = page.color
		pitchLabel.numberOfLines = 0
//		pitchLabel.backgroundColor = UIColor.red.tint(0.3)
		
		partingLabel.text = page.parting
		partingLabel.textAlignment = .center
		partingLabel.textColor = .black
		partingLabel.numberOfLines = 0
//		partingLabel.backgroundColor = UIColor.red.tint(0.3)
		
		timer.configure(interval: 3) {
			DispatchQueue.main.async {
				guard self.blurbNo < self.blurbs.count else {
					self.timer.stop()
					return
				}
				let bubble: UIView = self.blurbs[self.blurbNo]
				self.blurbNo += 1
				bubble.alpha = 0
				self.addSubview(bubble)
				self.bubbles.append(bubble)
				UIView.animate(withDuration: 0.2) {
					bubble.alpha = 1
				}
			}
		}
	}
	required init?(coder: NSCoder) { fatalError() }
	
	func start() {
		timer.reschedule()
		timer.start()
	}
	func stop() {
		timer.stop()
		blurbNo = 0
		UIView.animate(withDuration: 0.2, animations: {
			self.bubbles.forEach {$0.alpha = 0}
		}) { (completed: Bool) in
			self.bubbles.forEach {$0.removeFromSuperview()}
			self.bubbles = []
		}
	}
	
	// 0.67
	func layout320x480() {
		layout375x667()
	}
	
	// 0.56
	func layout320x568() {
		layout375x667()
	}
	func layout375x667() {
		let dy: CGFloat = 20*s
		let ds: CGFloat = 0.82
		let s: CGFloat = Screen.s * ds
		titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 24*s)
		pitchLabel.font = UIFont(name: "MarkerFelt-Wide", size: 16*s)
		partingLabel.font = UIFont(name: "MarkerFelt-Wide", size: 16*s)
		titleLabel.top(dy: 24*s-dy, width: 300*s, height: 100*s)
		imageView.top(dy: 116*s-dy, width: width*0.7*ds, height: width*0.7*2248/1125*ds)
		partingLabel.top(dy: 558*s-dy, width: 200*s, height: 240*s)
	}
	func layout414x736() {
		layout375x667()
	}
	
	// 0.46
	func layout360x780() {
		layout375x812()
	}
	func layout375x812() {
		titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 24*s)
		pitchLabel.font = UIFont(name: "MarkerFelt-Wide", size: 16*s)
		partingLabel.font = UIFont(name: "MarkerFelt-Wide", size: 16*s)
		titleLabel.top(dy: 24*s, width: 300*s, height: 100*s)
		imageView.top(dy: 116*s, width: width*0.7, height: width*0.7*2248/1125*s/Screen.s)
		partingLabel.top(dy: 558*s, width: 200*s, height: 240*s)
	}
	func layout390x844() {
		layout375x812()
	}
	func layout414x896() {
		layout375x812()
	}
	func layout428x926() {
		layout375x812()
	}
	
	// 1.33
	func layout1024x768() {
		let s: CGFloat = Screen.mac ? height/768 : Screen.s
		let ds: CGFloat = Screen.mac ? Screen.safeTop : 0

		titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 36*s)
		pitchLabel.font = UIFont(name: "MarkerFelt-Wide", size: 24*s)
		partingLabel.font = UIFont(name: "MarkerFelt-Wide", size: 24*s)
		imageView.topLeft(dx: 24*s, dy: 60*s+ds, width: width*0.72, height: width*0.72*1668/2388)
		titleLabel.topRight(dx: -30*s, dy: 20*s+ds, width: 220*s, height: 200*s)
		partingLabel.bottomRight(dx: -30*s, dy: -108*s+ds, width: 220*s, height: 240*s)
	}
	func layout1180x810() {
		layout1024x768()
	}
	func layout1112x834() {
		layout1024x768()
	}
	func layout1366x1024() {
		layout1024x768()
	}
	
	// 1.43
	func layout1180x820() {
		layout1024x768()
	}
	func layout1194x834() {
		layout1024x768()
	}

	// 1.52
	func layout1133x744() {
		layout1024x768()
	}

	
// UIView ==========================================================================================
	override func layoutSubviews() {
		if !Screen.mac {
			switch Screen.dimensions {
				case .dim320x480:	layout320x480()
				case .dim320x568:	layout320x568()
				case .dim375x667:	layout375x667()
				case .dim414x736:	layout414x736()
				case .dim360x780:	layout360x780()
				case .dim375x812:	layout375x812()
				case .dim390x844:	layout390x844()
				case .dim414x896:	layout414x896()
				case .dim428x926:	layout428x926()
				case .dim1024x768:	layout1024x768()
				case .dim1080x810:	layout1180x810()
				case .dim1112x834:	layout1112x834()
				case .dim1366x1024:	layout1366x1024()
				case .dim1180x820:	layout1180x820()
				case .dim1194x834:	layout1194x834()
				case .dim1133x744:	layout1133x744()
				case .dimOther:		layout375x667()
			}
		} else {
			layout1194x834()
		}
	}
}
