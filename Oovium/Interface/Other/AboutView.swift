//
//  AboutView.swift
//  Oovium
//
//  Created by Joe Charlier on 9/22/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumKit
import UIKit

class AboutView: UIView {
	var tagline: String = ""

	init() {
		super.init(frame: UIScreen.main.bounds)
		backgroundColor = UIColor.clear
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}

	func draw320x480() {draw375x667()}
	func draw320x568() {draw375x667()}
	func draw375x667() {
		Skin.about(text: "Version \(Oovium.version)", x: 163*s, y: (97+41+36)*s, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 23*s)!)
		Skin.about(text: tagline, x: 40*s, y: 254*s, uiColor: UIColor.green, font: UIFont(name: "Palatino-Italic", size: 20*s)!)
		Skin.about(text: "\u{00A9} 2022", x: (15+10)*s, y: (285+51+2)*s, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 19*s)!)
		Skin.about(text: "Aepryus", x: 15*s, y: (321+55-21)*s, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 21*s)!)
		Skin.about(text: "Software", x: (15+11)*s, y: (321+55)*s, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 21*s)!)

		UIGraphicsBeginImageContext(CGSize(width: 70*s, height: 70*s))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		image?.draw(in: CGRect(x: 84*s, y: (104+41)*s, width: 70*s, height: 70*s))
	}
	func draw414x736() {draw375x667()}
	func draw375x812() {
		Skin.about(text: "Version \(Oovium.version)", x: 190*s, y: 170*s, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 23*s)!)
		Skin.about(text: tagline, x: 40*s, y: 294*s, uiColor: UIColor.green, font: UIFont(name: "Palatino-Italic", size: 20*s)!)
		Skin.about(text: "\u{00A9} 2022", x: (5+10)*s, y: (285+51+2+157)*s, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 19*s)!)
		Skin.about(text: "Aepryus", x: 5*s, y: (321+55-21+157)*s, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 21*s)!)
		Skin.about(text: "Software", x: 8*s, y: (321+55+157)*s, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 21*s)!)
	}
	func draw414x896() {draw375x812()}
	func draw768x1024() {
		var text = "Version \(Oovium.version)"

		var pen = Pen(font: UIFont(name: "Palatino", size: 23*s)!)
		var size = (text as NSString).size(withAttributes: pen.attributes)
		var box = CGRect(x: 208*s, y: (173+42)*s, width: size.width, height: size.height)
		Skin.about(text: text, x: box.origin.x, y: box.origin.y, uiColor: UIColor.green, font: pen.font)

		text = tagline
		pen = Pen(font: UIFont(name: "Palatino-Italic", size: 24*s)!)
		size = (text as NSString).size(withAttributes: pen.attributes)
		box = CGRect(x: 200*s-size.width/2, y: 342*s, width: size.width, height: size.height)
		Skin.about(text: text, x: box.origin.x, y: box.origin.y, uiColor: UIColor.green, font: pen.font)

		let p1: CGPoint = CGPoint(x: 686*s, y: 971*s)
		let p2: CGPoint = CGPoint(x: 558*s, y: 991*s)

		Skin.about(text: "\u{00A9} 2022", x: p1.x, y: p1.y, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 18*s)!)
		Skin.about(text: "Aepryus Software", x: p2.x, y: p2.y, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 23*s)!)
	}
	func draw834x1112() {draw768x1024()}
	func draw834x1194() {
		var text = "Version \(Oovium.version)"

		var pen = Pen(font: UIFont(name: "Palatino", size: 23*s)!)
		var size = (text as NSString).size(withAttributes: pen.attributes)
		var box = CGRect(x: 218*s, y: 213*s, width: size.width, height: size.height)
		Skin.about(text: text, x: box.origin.x, y: box.origin.y, uiColor: UIColor.green, font: pen.font)

		text = tagline
		pen = Pen(font: UIFont(name: "Palatino-Italic", size: 24*s)!)
		size = (text as NSString).size(withAttributes: pen.attributes)
		box = CGRect(x: 200*s-size.width/2, y: 372*s, width: size.width, height: size.height)
		Skin.about(text: text, x: box.origin.x, y: box.origin.y, uiColor: UIColor.green, font: pen.font)

		let p1: CGPoint = CGPoint(x: 686*s, y: 1021*s)
		let p2: CGPoint = CGPoint(x: 558*s, y: 1041*s)

		Skin.about(text: "\u{00A9} 2022", x: p1.x, y: p1.y, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 18*s)!)
		Skin.about(text: "Aepryus Software", x: p2.x, y: p2.y, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 23*s)!)
	}
	func draw1024x1366() {draw768x1024()}
	func drawOther() {draw375x667()}
	func drawMac() {
		let s: CGFloat = 1
		var text: String = "Version \(Oovium.version)"

		var pen: Pen = Pen(font: UIFont(name: "Palatino", size: 23*s)!)
		var size: CGSize = (text as NSString).size(withAttributes: pen.attributes)
		var box: CGRect = CGRect(x: 268*s, y: 173*s, width: size.width, height: size.height)
		Skin.about(text: text, x: box.origin.x, y: box.origin.y, uiColor: UIColor.green, font: pen.font)

		text = tagline
		pen = Pen(font: UIFont(name: "Palatino-Italic", size: 24*s)!)
		size = (text as NSString).size(withAttributes: pen.attributes)
		box = CGRect(x: 200*s-size.width/2, y: 342*s, width: size.width, height: size.height)
		Skin.about(text: text, x: box.origin.x, y: box.origin.y, uiColor: UIColor.green, font: pen.font)

		let p1: CGPoint = CGPoint(x: 686*s, y: 996*s)
		let p2: CGPoint = CGPoint(x: 572*s, y: 1016*s)

		Skin.about(text: "\u{00A9} 2022", x: p1.x, y: p1.y, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 18*s)!)
		Skin.about(text: "Aepryus Software", x: p2.x, y: p2.y, uiColor: UIColor.green, font: UIFont(name: "Palatino", size: 23*s)!)
	}

// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let height = Screen.height
		if !Screen.iPhone { drawMac() }
		else if height == 480 { draw320x480() }
		else if height == 568 { draw320x568() }
		else if height == 667 { draw375x667() }
		else if height == 736 { draw414x736() }
		else if height == 812 { draw375x812() }
		else if height == 896 { draw414x896() }
		else if height == 1024 { draw768x1024() }
		else if height == 1112 { draw834x1112() }
		else if height == 1194 { draw834x1194() }
		else if height == 1366 { draw1024x1366() }
		else { drawOther() }
	}
}
