//
//  Antechamber.swift
//  Oovium
//
//  Created by Joe Charlier on 12/26/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class Antechamber: Modal {
	let mint: UIColor = UIColor(rgb: 0xACDFC9)
	let creamsicle: UIColor = UIColor(rgb: 0xDFC9AC)
	
	let titlePathView: PathView = PathView(uiColor: UIColor(rgb: 0xACDFC9))
	let subscriptionPathView: PathView = PathView(uiColor: UIColor(rgb: 0xDFC9AC))
	let stickyPathView: PathView = PathView(uiColor: UIColor(rgb: 0xACDFC9))
	let articlesPathView: PathView = PathView(uiColor: UIColor(rgb: 0xACDFC9))
	let aetherPathView: PathView = PathView(uiColor: UIColor(rgb: 0xACDFC9))
	let backButton: PathButton = PathButton(uiColor: UIColor(rgb: 0xDFC9AC), key: "back")
	let closeButton: PathButton = PathButton(uiColor: UIColor(rgb: 0xACDFC9), key: "close")
	let whatsNewIcon: WhatsNewIcon = WhatsNewIcon()
	let todoIcon: ToDoIcon = ToDoIcon()
	
	var articlesView: ArticlesView!
	let articleView: AetherView
	
	var selected: Article?  {
		didSet {
			todoIcon.active = false
			articlesView.selected = selected
			articlesView.reloadData()
			if Oo.iPhone {
				UIView.animate(withDuration: 0.2, animations: {
					self.stickyPathView.alpha = 0
					self.articlesPathView.alpha = 0
				}) { (finished: Bool) in
					self.stickyPathView.removeFromSuperview()
					self.articlesPathView.removeFromSuperview()
					self.aetherPathView.alpha = 0
					self.backButton.alpha = 0
					self.addSubview(self.aetherPathView)
					self.addSubview(self.backButton)
					UIView.animate(withDuration: 0.2) {
						self.aetherPathView.alpha = 1
						self.backButton.alpha = 1
					}
				}
			}
		}
	}
	
	init() {
		articleView = AetherView(aether: Aether(), toolsOn: false, burn: false)
		if Screen.mac { articleView.makePannable() }

		super.init(aetherView: Oovium.aetherView, anchor: .center, orientations: Screen.iPhone ? .portrait : .landscape)

		forcedOrientation = Screen.iPhone ? .portrait : .landscape

		titlePathView.contentView = OOLabel(text: "Oovium Antechamber", pen: Pen(font: UIFont.verdana(size: 20), color: .green, alignment: .center))
		addSubview(titlePathView)
		
		addSubview(subscriptionPathView)
		
		whatsNewIcon.pen = Pen(font: UIFont(name: "AmericanTypewriter", size: 16*s)!, alignment: .center)
		stickyPathView.addSubview(whatsNewIcon)
		
		todoIcon.pen = Pen(font: UIFont(name: "GillSans-Bold", size: 15*s)!, alignment: .center)
		stickyPathView.addSubview(todoIcon)
		addSubview(stickyPathView)
		todoIcon.addAction {
			self.selected = nil
			self.todoIcon.active = true
			self.articleView.lockVerticalScrolling = false
			self.articleView.swapToAether(aether: Aether(json:Local.aetherJSONFromBundle(name: "RoadMap")))
		}

		articlesView = ArticlesView(antechamber: self)
		articlesPathView.contentView = articlesView
		addSubview(articlesPathView)

		articleView.lockVerticalScrolling = true
		aetherPathView.contentView = articleView
		if !Oo.iPhone { addSubview(aetherPathView) }
		
		backButton.pen = Pen(font: UIFont(name: "Verdana", size: 24)!, color: creamsicle, alignment: .center, style: .default)
		backButton.addAction { [unowned self] in
			UIView.animate(withDuration: 0.2, animations: {
				self.aetherPathView.alpha = 0
				self.backButton.alpha = 0
			}) { (finished: Bool) in
				self.aetherPathView.removeFromSuperview()
				self.backButton.removeFromSuperview()
				self.stickyPathView.alpha = 0
				self.articlesPathView.alpha = 0
				self.addSubview(self.stickyPathView)
				self.addSubview(self.articlesPathView)
				UIView.animate(withDuration: 0.2) {
					self.stickyPathView.alpha = 1
					self.articlesPathView.alpha = 1
				}
			}
		}

		closeButton.pen = Pen(font: UIFont(name: "Verdana", size: 24)!, color: .green, alignment: .center, style: .default)
		addSubview(closeButton)
		closeButton.addAction { [unowned self] in
//			self.aetherView.markPositions()
//			print(self.aetherView.aether.unload().toJSON())
			self.dismiss()
		}
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func reset() {
		guard Oo.iPhone else { return }
		aetherPathView.removeFromSuperview()
		backButton.removeFromSuperview()
		stickyPathView.alpha = 1
		articlesPathView.alpha = 1
		addSubview(self.stickyPathView)
		addSubview(self.articlesPathView)
	}
	
	func renderPaths375x667() {
	
		size = CGSize(width: (Screen.width-30), height: (Screen.height-100))

		let m: CGFloat = 5*1.5
		let tw: CGFloat = 240*Oo.s
		let qw: CGFloat = 20*Oo.s
		let cw: CGFloat = 160*Oo.s
		let th: CGFloat = 36*1.2
		let sh: CGFloat = 54*1.3
		let ch: CGFloat = 36*1.2
		
		let x1 = m
		let x2 = x1 + tw
		let x3 = x2 + m
		let x4 = width - m
		let x7 = x1 + qw
		let x9 = x3 + qw
		let x10 = x4 - qw
		
		let y1 = m
		let y2 = y1 + th
		let y3 = y2 + m
		let y4 = y3 + sh
		let y5 = y4 + m
		let y8 = height - m
		let y7 = y8 - ch
		let y6 = y7 - m
		
		let a1 = CGPoint(x: x7, y: y1)
		let a2 = CGPoint(x: x4-qw, y: y1)
		let a3 = CGPoint(x: x4, y: y2)
		let a4 = CGPoint(x: x1, y: y2)
		
		var path: CGMutablePath = CGMutablePath()
		path.move(to: (a1+a4)/2)
		path.addArc(tangent1End: a1, tangent2End: (a1+a2)/2, radius: 15)
		path.addArc(tangent1End: a2, tangent2End: (a2+a3)/2, radius: 15)
		path.addArc(tangent1End: a3, tangent2End: (a3+a4)/2, radius: 5)
		path.addArc(tangent1End: a4, tangent2End: (a1+a4)/2, radius: 5)
		path.closeSubpath()
		titlePathView.path = path
		
		let b1 = CGPoint(x: x9, y: y1)
		let b2 = CGPoint(x: x10, y: y1)
		let b3 = CGPoint(x: x4, y: y2)
		let b4 = CGPoint(x: x3, y: y2)
		
		path = CGMutablePath()
		path.move(to: (b1+b4)/2)
		path.addArc(tangent1End: b1, tangent2End: (b1+b2)/2, radius: 15)
		path.addArc(tangent1End: b2, tangent2End: (b2+b3)/2, radius: 15)
		path.addArc(tangent1End: b3, tangent2End: (b3+b4)/2, radius: 5)
		path.addArc(tangent1End: b4, tangent2End: (b1+b4)/2, radius: 5)
		path.closeSubpath()
		subscriptionPathView.path = path
		
		stickyPathView.path = CGPath(roundedRect: CGRect(x: x1, y: y3, width: x4-x1, height: y4-y3), cornerWidth: 8, cornerHeight: 8, transform: nil)
		articlesPathView.path = CGPath(roundedRect: CGRect(x: x1, y: y5, width: x4-x1, height: y6-y5), cornerWidth: 8, cornerHeight: 8, transform: nil)
		aetherPathView.path = CGPath(roundedRect: CGRect(x: x1, y: y3, width: x4-x1, height: y6-y3), cornerWidth: 8, cornerHeight: 8, transform: nil)
		
		let e1 = CGPoint(x: x1, y: y7)
		let e2 = CGPoint(x: x4-cw-m, y: y7)
		let e3 = CGPoint(x: x4-cw-qw-m, y: y8)
		let e4 = CGPoint(x: x7, y: y8)
		
		path = CGMutablePath()
		path.move(to: (e1+e4)/2)
		path.addArc(tangent1End: e1, tangent2End: (e1+e2)/2, radius: 5)
		path.addArc(tangent1End: e2, tangent2End: (e2+e3)/2, radius: 5)
		path.addArc(tangent1End: e3, tangent2End: (e3+e4)/2, radius: 15)
		path.addArc(tangent1End: e4, tangent2End: (e1+e4)/2, radius: 15)
		path.closeSubpath()
		backButton.path = path

		
		let f1 = CGPoint(x: x4-cw, y: y7)
		let f2 = CGPoint(x: x4, y: y7)
		let f3 = CGPoint(x: x4-qw, y: y8)
		let f4 = CGPoint(x: x4-cw-qw, y: y8)
		
		path = CGMutablePath()
		path.move(to: (f1+f4)/2)
		path.addArc(tangent1End: f1, tangent2End: (f1+f2)/2, radius: 15)
		path.addArc(tangent1End: f2, tangent2End: (f2+f3)/2, radius: 5)
		path.addArc(tangent1End: f3, tangent2End: (f3+f4)/2, radius: 15)
		path.addArc(tangent1End: f4, tangent2End: (f1+f4)/2, radius: 5)
		path.closeSubpath()
		closeButton.path = path
		
		articlesView.rowHeight = 72*s
	}
	func renderPaths1024x768() {
	
		size = CGSize(width: (Screen.width-300)/1.5, height: (Screen.height-100)/1.5)

		let m: CGFloat = 5*Oo.s
		let tw: CGFloat = 240*Oo.s
		let sw: CGFloat = 180*Oo.s
		let qw: CGFloat = 20*Oo.s
		let cw: CGFloat = 160*Oo.s
		let th: CGFloat = 36*Oo.s
		let sh: CGFloat = 54*Oo.s
		let ch: CGFloat = 36*Oo.s
		
		let x1 = m
		let x2 = x1 + tw
		let x3 = x2 + m
		let x4 = width - m
		let x5 = x1 + sw
		let x6 = x5 + m
		let x7 = x1 + qw
		let x8 = x2 + qw
		let x9 = x3 + qw
		let x10 = x4 - qw
		
		let y1 = m
		let y2 = y1 + th
		let y3 = y2 + m
		let y4 = y3 + sh
		let y5 = y4 + m
		let y8 = height - m
		let y7 = y8 - ch
		let y6 = y7 - m
		
		let a1 = CGPoint(x: x7, y: y1)
		let a2 = CGPoint(x: x8, y: y1)
		let a3 = CGPoint(x: x2, y: y2)
		let a4 = CGPoint(x: x1, y: y2)
		
		var path: CGMutablePath = CGMutablePath()
		path.move(to: (a1+a4)/2)
		path.addArc(tangent1End: a1, tangent2End: (a1+a2)/2, radius: 15)
		path.addArc(tangent1End: a2, tangent2End: (a2+a3)/2, radius: 5)
		path.addArc(tangent1End: a3, tangent2End: (a3+a4)/2, radius: 15)
		path.addArc(tangent1End: a4, tangent2End: (a1+a4)/2, radius: 5)
		path.closeSubpath()
		titlePathView.path = path
		
		let b1 = CGPoint(x: x9, y: y1)
		let b2 = CGPoint(x: x10, y: y1)
		let b3 = CGPoint(x: x4, y: y2)
		let b4 = CGPoint(x: x3, y: y2)
		
		path = CGMutablePath()
		path.move(to: (b1+b4)/2)
		path.addArc(tangent1End: b1, tangent2End: (b1+b2)/2, radius: 15)
		path.addArc(tangent1End: b2, tangent2End: (b2+b3)/2, radius: 15)
		path.addArc(tangent1End: b3, tangent2End: (b3+b4)/2, radius: 5)
		path.addArc(tangent1End: b4, tangent2End: (b1+b4)/2, radius: 5)
		path.closeSubpath()
		subscriptionPathView.path = path
		
		stickyPathView.path = CGPath(roundedRect: CGRect(x: x1, y: y3, width: x5-x1, height: y4-y3), cornerWidth: 8, cornerHeight: 8, transform: nil)
		articlesPathView.path = CGPath(roundedRect: CGRect(x: x1, y: y5, width: x5-x1, height: y6-y5), cornerWidth: 8, cornerHeight: 8, transform: nil)
		aetherPathView.path = CGPath(roundedRect: CGRect(x: x6, y: y3, width: x4-x6, height: y6-y3), cornerWidth: 8, cornerHeight: 8, transform: nil)
		
		let f1 = CGPoint(x: x4-cw, y: y7)
		let f2 = CGPoint(x: x4, y: y7)
		let f3 = CGPoint(x: x4-qw, y: y8)
		let f4 = CGPoint(x: x4-cw-qw, y: y8)
		
		path = CGMutablePath()
		path.move(to: (f1+f4)/2)
		path.addArc(tangent1End: f1, tangent2End: (f1+f2)/2, radius: 15)
		path.addArc(tangent1End: f2, tangent2End: (f2+f3)/2, radius: 5)
		path.addArc(tangent1End: f3, tangent2End: (f3+f4)/2, radius: 15)
		path.addArc(tangent1End: f4, tangent2End: (f1+f4)/2, radius: 5)
		path.closeSubpath()
		closeButton.path = path
		
		articlesView.rowHeight = 72*s
	}
	
	func layout320x480() { layout375x667() }
	func layout320x568() { layout375x667() }
	func layout375x667() {
		subscriptionPathView.removeFromSuperview()
	
		renderPaths375x667()
		articleView.reload()

		let w: CGFloat = 68*s
		let h: CGFloat = 52*s
		let o: CGFloat = 48*s
		
		whatsNewIcon.center(dx: -o, width: w, height: h)
		todoIcon.center(dx: o, width: w, height: h)
	}
	func layout414x736() { layout375x667() }
	func layout360x780() { layout375x812() }
	func layout375x812() { layout375x667() }
	func layout390x844() { layout375x812() }
	func layout414x896() { layout375x812() }
	func layout428x926() { layout375x812() }
	func layout1024x768() {
		renderPaths1024x768()
		articleView.reload()
		
		let w: CGFloat = 68*s
		let h: CGFloat = 52*s
		let o: CGFloat = 48*s
		
		whatsNewIcon.center(dx: -o, width: w, height: h)
		todoIcon.center(dx: o, width: w, height: h)
	}
	func layout1080x810() { layout1024x768() }
	func layout1112x834() { layout1024x768() }
	func layout1366x1024() { layout1024x768() }
	func layout1194x834() { layout1024x768() }
	func layout1180x820() { layout1024x768() }
	func layout1133x744() { layout1024x768() }

	func layout() {
		if Screen.mac { layout1194x834() }
		else {
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
				case .dim1080x810:	layout1080x810()
				case .dim1112x834:	layout1112x834()
				case .dim1366x1024:	layout1366x1024()
				case .dim1180x820:	layout1180x820()
				case .dim1194x834:	layout1194x834()
				case .dim1133x744:	layout1133x744()
				case .dimOther:		layout375x667()
			}
		}
	}
	
// Hover ===========================================================================================
//	override func onInvoke() {}
//	override func onDismissed() {
//		reset()
//	}
	
// UIView ==========================================================================================
	override func layoutSubviews() {
		layout()
	}
}
