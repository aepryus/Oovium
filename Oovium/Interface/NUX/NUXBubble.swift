//
//  NUXBubble.swift
//  Oovium
//
//  Created by Joe Charlier on 6/27/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class NUXBubble: UIView {
	let oval: CAShapeLayer = CAShapeLayer()
//	let pointer: CAShapeLayer = CAShapeLayer()
	let label: UILabel = UILabel()
	let pen: Pen
	let ds: CGFloat
	
	init(ds: CGFloat = 1, blurb: NUXBlurb) {
		self.ds = ds
		let s: CGFloat = Screen.mac ? Screen.height/768*ds : Screen.s*ds
		self.pen = Pen(font: UIFont(name: "MarkerFelt-Thin", size: 16*s*ds)!, alignment: .center)
		
		super.init(frame: .zero)
		
		let textSize: CGSize = calcSize(for: blurb.text)
		let ovalSize: CGSize = CGSize(width: textSize.width+50*s, height: textSize.height+20*s)
		var left: CGFloat = blurb.center.x-ovalSize.width/2
		var top: CGFloat = blurb.center.y-ovalSize.height/2
		var right: CGFloat = blurb.center.x+ovalSize.width/2
		var bottom: CGFloat = blurb.center.y+ovalSize.height/2
		blurb.point.forEach {
			left = min(left, $0.x)
			top = min(top, $0.y)
			right = max(right, $0.x)
			bottom = max(bottom, $0.y)
		}
		frame = CGRect(x: left, y: top, width: right-left, height: bottom-top)
		
		let origin = CGPoint(x: left, y: top)
		let center = blurb.center - origin
		
		blurb.point.forEach {
			let point = $0 - origin
			
			let pointer: CAShapeLayer = CAShapeLayer()

			let path: CGMutablePath = CGMutablePath()
			if Screen.iPhone {
				let perpendicular: CGPoint = (point-center).perpendicular().unit()
				let head = center + perpendicular*10*s
				let feet = center - perpendicular*10*s
				path.move(to: point)
				path.addCurve(to: feet, control1: point+((center+feet+point)/3-point).unit()*120*s, control2: feet)
				path.addLine(to: head)
				path.addCurve(to: point, control1: head, control2: point+((center+head+point)/3-point).unit()*120*s)
			} else {
				let head = center + CGPoint(x: 0, y: -10*s)
				let feet = center + CGPoint(x: 0, y: 10*s)
				path.move(to: point)
				path.addCurve(to: feet, control1: (feet+point)/2+CGPoint(x: 0*s, y: 20*s), control2: (feet+point)/2+CGPoint(x: -0*s, y: -20*s))
				path.addLine(to: head)
				path.addCurve(to: point, control1: (head+point)/2+CGPoint(x: -0*s, y: -20*s), control2: (head+point)/2+CGPoint(x: 0*s, y: 20*s))
			}
			
			pointer.path = path
			pointer.fillColor = UIColor.white.cgColor
			layer.addSublayer(pointer)
		}

		oval.path = CGPath(ellipseIn: CGRect(x: blurb.center.x-ovalSize.width/2-left, y: blurb.center.y-ovalSize.height/2-top, width: ovalSize.width, height: ovalSize.height), transform: nil)
		oval.fillColor = UIColor.white.cgColor
		layer.addSublayer(oval)

		label.text = blurb.text
		label.numberOfLines = 0
		label.pen = pen
		addSubview(label)
		label.frame = CGRect(x: blurb.center.x-textSize.width/2-left, y: blurb.center.y-textSize.height/2-top, width: textSize.width, height: textSize.height)
	}
	required init?(coder: NSCoder) { fatalError() }
	
	func calcSize(for text: String) -> CGSize {
		var size: CGSize = (text as NSString).size(withAttributes: pen.attributes)
		if text.components(separatedBy: " ").count > 1 {
			while size.width > size.height*4 {
				size = (text as NSString).boundingRect(with: CGSize(width: size.width*0.9, height: 2000), options: [.usesLineFragmentOrigin], attributes: pen.attributes, context: nil).size
			}
		}
		return size
	}
}
