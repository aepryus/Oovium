//
//  NUXView.swift
//  Oovium
//
//  Created by Joe Charlier on 6/27/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class NUXView: UIView, UIScrollViewDelegate {
	let scrollView: UIScrollView = UIScrollView()
	let pageControl: UIPageControl = UIPageControl()
	let shield: UIView = UIView()
	let pages: [NUXPageView] = [
		NUXPageView(page: NUXPage(color: UIColor(rgb: 0xF0FFEB), screenShot: Screen.iPhone ? "NUXSS1s" : "NUXSS1", title: Screen.iPhone ? "Oovium is a\nCalculator" : "Oovium\nis a\nCalculator", pitch: "Oovium fundamentally shifts how its users think about and perform calculations", parting: "Will you be able to return to your pocket calculator?")),

		NUXPageView(page: NUXPage(color: UIColor(rgb: 0xC6D5FF), screenShot: Screen.iPhone ? "NUXSS2s" : "NUXSS2", title: Screen.iPhone ? "Oovium is a\nSpreadsheet" : "Oovium\nis a\nSpreadsheet", pitch: "Oovium asks, how should spreadsheets really work?", parting: "Why weren't spreadsheets designed this way from the beginning?")),
		NUXPageView(page: NUXPage(color: UIColor(rgb: 0xE2D9FF), screenShot: Screen.iPhone ? "NUXSS3s" : "NUXSS3", title: Screen.iPhone ? "Oovium is a\nProgramming Language" : "Oovium\nis a\nProgramming\nLanguage", pitch: "Oovium enables its users to write their own functions", parting: "Writing a custom function in Oovium is just as easy as doing a simple calculation.")),
		NUXPageView(page: NUXPage(color: UIColor.orange.tint(0.9), screenShot: Screen.iPhone ? "NUXSS4s" : "NUXSS4", title: Screen.iPhone ? "Oovium is the\nFuture" : "Oovium\nis the\nFuture", pitch: "The Future\nof Oovium", parting: "Help decide Oovium's future direction.  Join us as we bring it fully to life!"))
	]

	init() {
		super.init(frame: .zero)
		
		scrollView.isPagingEnabled = true
		scrollView.delegate = self
		scrollView.showsHorizontalScrollIndicator = false
		addSubview(scrollView)
		if Screen.mac {
			let gesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
			scrollView.addGestureRecognizer(gesture)
		}
		
		shield.backgroundColor = UIColor.black.alpha(0.3)
		addSubview(shield)
		
		pageControl.numberOfPages = 4
		pageControl.addAction { [unowned self] in
			self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.pageControl.currentPage)*self.scrollView.width, y: 0), animated: true)
		}
		addSubview(pageControl)
		
		layout()
	}
	required init?(coder: NSCoder) { fatalError() }
	
	func layout() {
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
	
	// 0.67
	func layout320x480() {
		layout375x667()
	}
	
	// 0.56
	func layout320x568() {
		layout375x667()
	}
	func layout375x667() {
		let dx: CGFloat = 32*s
		let dy: CGFloat = 20*s
		let ds: CGFloat = 0.82
		let s: CGFloat = Screen.s * ds

		pages[0].pitchLabel.top(dy: 146*s-dy, width: 250*s, height: 66*s)
		pages[0].blurbs.append(pages[0].pitchLabel)
		pages[0].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "create bubbles with the values you need", center: CGPoint(x: 68*s+dx, y: 226*s-dy), point: [CGPoint(x: 96*s+dx, y: 290*s-dy), CGPoint(x: 76*s+dx, y: 340*s-dy)])))
		pages[0].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "optionally label any of the bubbles", center: CGPoint(x: 68*s+dx, y: 606*s-dy), point: [CGPoint(x: 94*s+dx, y: 536*s-dy)])))
		pages[0].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "visually verify the inputs", center: CGPoint(x: 250*s+dx, y: 286*s-dy), point: [CGPoint(x: 120*s+dx, y: 313*s-dy)])))
		pages[0].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "define intermediate calculations", center: CGPoint(x: 290*s+dx, y: 526*s-dy), point: [CGPoint(x: 250*s+dx, y: 476*s-dy)])))
		pages[0].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "modify the inputs to see how they affect the answer", center: CGPoint(x: 94*s+dx, y: 416*s-dy), point: [CGPoint(x: 234*s+dx, y: 400*s-dy)])))
		pages[0].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "annotate your calculations with TextBubs", center: CGPoint(x: 290*s+dx, y: 166*s-dy), point: [CGPoint(x: 244*s+dx, y: 220*s-dy)])))
		pages[0].blurbs.append(pages[0].partingLabel)
		scrollView.addSubview(pages[0])
		
		pages[1].pitchLabel.topLeft(dx: 58*s+dx, dy: 134*s-dy, width: 180*s, height: 70*s)
		pages[1].blurbs.append(pages[1].pitchLabel)
		pages[1].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "define columns not cells", center: CGPoint(x: 290*s+dx, y: 120*s-dy), point: [CGPoint(x: 284*s+dx, y: 170*s-dy)])))
		pages[1].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "no more b1*c1\nand no more\ncopy and paste\nof formulas", center: CGPoint(x: 300*s+dx, y: 250*s-dy), point: [CGPoint(x: 284*s+dx, y: 184*s-dy)])))
		pages[1].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "place multiple tables\nfreely on the aether; not\ntied to a single grid", center: CGPoint(x: 100*s+dx, y: 360*s-dy), point: [CGPoint(x: 149*s+dx, y: 430*s-dy), CGPoint(x: 84*s+dx, y: 450*s-dy)])))
		pages[1].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "easily define footers as SUM, AVERAGE, COUNT or others", center: CGPoint(x: 120*s+dx, y: 510*s-dy), point: [CGPoint(x: 90*s+dx, y: 630*s-dy)])))
		pages[1].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "reference tables from other bubbles and other bubbles from tables", center: CGPoint(x: 270*s+dx, y: 570*s-dy), point: [CGPoint(x: 170*s+dx, y: 620*s-dy)])))
		pages[1].blurbs.append(pages[1].partingLabel)
		scrollView.addSubview(pages[1])
		
		pages[2].pitchLabel.topLeft(dx: 58*s+dx, dy: 164*s-dy, width: 180*s, height: 70*s)
		pages[2].blurbs.append(pages[2].pitchLabel)
		pages[2].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "define simple functions", center: CGPoint(x: 330*s+dx, y: 110*s-dy), point: [CGPoint(x: 294*s+dx, y: 168*s-dy)])))
		pages[2].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "or sophisticated recursive functions", center: CGPoint(x: 304*s+dx, y: 360*s-dy), point: [CGPoint(x: 285*s+dx, y: 426*s-dy)])))
		pages[2].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "make use of visual if-then-else statements", center: CGPoint(x: 300*s+dx, y: 510*s-dy), point: [CGPoint(x: 194*s+dx, y: 574*s-dy)])))
		pages[2].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "define tail optimized recursive functions", center: CGPoint(x: 70*s+dx, y: 240*s-dy), point: [CGPoint(x: 110*s+dx, y: 290*s-dy)])))
		pages[2].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "set up timers and iterate through numerous values", center: CGPoint(x: 60*s+dx, y: 430*s-dy), point: [CGPoint(x: 87*s+dx, y: 494*s-dy)])))
		pages[2].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "import other aethers and their functions", center: CGPoint(x: 180*s+dx, y: 160*s-dy), point: [CGPoint(x: 230*s+dx, y: 250*s-dy)])))
		pages[2].blurbs.append(pages[2].partingLabel)
		scrollView.addSubview(pages[2])
		
		pages[3].pitchLabel.topLeft(dx: 58*s+dx, dy: 144*s-dy, width: 180*s, height: 70*s)
		pages[3].blurbs.append(pages[3].pitchLabel)
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "Oovium is currently a shadow of what it is intended to be", center: CGPoint(x: 300*s+dx, y: 140*s-dy), point: [])))
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "planned additions include: custom objects,", center: CGPoint(x: 70*s+dx, y: 230*s-dy), point: [CGPoint(x: 150*s+dx, y: 264*s-dy)])))
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "arrays, dictionaries and other data types", center: CGPoint(x: 70*s+dx, y: 320*s-dy), point: [CGPoint(x: 80*s+dx, y: 379*s-dy)])))
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "the MiruBub will allow users to", center: CGPoint(x: 100*s-42*s+dx, y: 440*s+120*s-dy), point: [CGPoint(x: 140*s-42*s+dx, y: 400*s+120*s-dy)])))
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "...slice and dice their data ala Improv", center: CGPoint(x: 196*s-42*s+dx, y: 496*s+120*s-dy), point: [CGPoint(x: 100*s-42*s+dx, y: 454*s+120*s-dy)])))
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "Oovium Online will allow users to", center: CGPoint(x: 164*s+dx, y: 470*s-dy), point: [])))
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "...upload and download aethers, publish and subscribe to feeds, as well as many other features", center: CGPoint(x: 274*s+dx, y: 540*s-dy), point: [CGPoint(x: 174*s+dx, y: 480*s-dy)])))
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "further down the line, will Oovium become the visual R client you've always wanted?", center: CGPoint(x: 277*s+dx, y: 270*s-dy), point: [CGPoint(x: 304*s+dx, y: 480*s-dy)])))
		pages[3].blurbs.append(NUXBubble(ds: ds, blurb: NUXBlurb(text: "or the visual query builder for your relational database?", center: CGPoint(x: 284*s+dx, y: 340*s-dy), point: [])))
		pages[3].blurbs.append(pages[3].partingLabel)
		scrollView.addSubview(pages[3])
	}
	func layout414x736() {
		layout375x667()
	}
	
	// 0.46
	func layout360x780() {
		layout375x812()
	}
	func layout375x812() {
		pages[0].pitchLabel.top(dy: 146*s, width: 250*s, height: 66*s)
		pages[0].blurbs.append(pages[0].pitchLabel)
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "create bubbles with the values you need", center: CGPoint(x: 68*s, y: 226*s), point: [CGPoint(x: 96*s, y: 290*s), CGPoint(x: 76*s, y: 340*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "optionally label any of the bubbles", center: CGPoint(x: 68*s, y: 606*s), point: [CGPoint(x: 94*s, y: 536*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "visually verify the inputs", center: CGPoint(x: 250*s, y: 286*s), point: [CGPoint(x: 120*s, y: 313*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define intermediate calculations", center: CGPoint(x: 290*s, y: 526*s), point: [CGPoint(x: 250*s, y: 476*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "modify the inputs to see how they affect the answer", center: CGPoint(x: 94*s, y: 416*s), point: [CGPoint(x: 234*s, y: 400*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "annotate your calculations with TextBubs", center: CGPoint(x: 290*s, y: 166*s), point: [CGPoint(x: 244*s, y: 220*s)])))
		pages[0].blurbs.append(pages[0].partingLabel)
		scrollView.addSubview(pages[0])
		
		pages[1].pitchLabel.topLeft(dx: 58*s, dy: 134*s, width: 180*s, height: 70*s)
		pages[1].blurbs.append(pages[1].pitchLabel)
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define columns not cells", center: CGPoint(x: 290*s, y: 120*s), point: [CGPoint(x: 284*s, y: 170*s)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "no more b1*c1\nand no more\ncopy and paste\nof formulas", center: CGPoint(x: 300*s, y: 250*s), point: [CGPoint(x: 284*s, y: 184*s)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "place multiple tables\nfreely on the aether; not\ntied to a single grid", center: CGPoint(x: 100*s, y: 360*s), point: [CGPoint(x: 149*s, y: 430*s), CGPoint(x: 84*s, y: 450*s)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "easily define footers as SUM, AVERAGE, COUNT or others", center: CGPoint(x: 120*s, y: 510*s), point: [CGPoint(x: 90*s, y: 630*s)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "reference tables from other bubbles and other bubbles from tables", center: CGPoint(x: 270*s, y: 570*s), point: [CGPoint(x: 170*s, y: 620*s)])))
		pages[1].blurbs.append(pages[1].partingLabel)
		scrollView.addSubview(pages[1])
		
		pages[2].pitchLabel.topLeft(dx: 58*s, dy: 164*s, width: 180*s, height: 70*s)
		pages[2].blurbs.append(pages[2].pitchLabel)
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define simple functions", center: CGPoint(x: 330*s, y: 110*s), point: [CGPoint(x: 294*s, y: 168*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "or sophisticated recursive functions", center: CGPoint(x: 304*s, y: 360*s), point: [CGPoint(x: 285*s, y: 426*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "make use of visual if-then-else statements", center: CGPoint(x: 300*s, y: 510*s), point: [CGPoint(x: 194*s, y: 574*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define tail optimized recursive functions", center: CGPoint(x: 70*s, y: 240*s), point: [CGPoint(x: 110*s, y: 290*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "set up timers and iterate through numerous values", center: CGPoint(x: 60*s, y: 430*s), point: [CGPoint(x: 87*s, y: 494*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "import other aethers and their functions", center: CGPoint(x: 180*s, y: 160*s), point: [CGPoint(x: 230*s, y: 250*s)])))
		pages[2].blurbs.append(pages[2].partingLabel)
		scrollView.addSubview(pages[2])
		
		pages[3].pitchLabel.topLeft(dx: 58*s, dy: 144*s, width: 180*s, height: 70*s)
		pages[3].blurbs.append(pages[3].pitchLabel)
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "Oovium is currently a shadow of what it is intended to be", center: CGPoint(x: 300*s, y: 140*s), point: [])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "planned additions include: custom objects,", center: CGPoint(x: 70*s, y: 230*s), point: [CGPoint(x: 150*s, y: 264*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "arrays, dictionaries and other data types", center: CGPoint(x: 70*s, y: 320*s), point: [CGPoint(x: 80*s, y: 379*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "the MiruBub will allow users to", center: CGPoint(x: 100*s-42*s, y: 440*s+120*s), point: [CGPoint(x: 140*s-42*s, y: 400*s+120*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "...slice and dice their data ala Improv", center: CGPoint(x: 196*s-42*s, y: 496*s+120*s), point: [CGPoint(x: 100*s-42*s, y: 454*s+120*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "Oovium Online will allow users to", center: CGPoint(x: 164*s, y: 470*s), point: [])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "...upload and download aethers, publish and subscribe to feeds, as well as many other features", center: CGPoint(x: 274*s, y: 540*s), point: [CGPoint(x: 174*s, y: 480*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "further down the line, will Oovium become the visual R client you've always wanted?", center: CGPoint(x: 277*s, y: 270*s), point: [CGPoint(x: 304*s, y: 480*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "or the visual query builder for your relational database?", center: CGPoint(x: 284*s, y: 340*s), point: [])))
		pages[3].blurbs.append(pages[3].partingLabel)
		scrollView.addSubview(pages[3])
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
		let s: CGFloat = Screen.s * 0.94
		
		pages[0].pitchLabel.topLeft(dx: 224*s, dy: 64*s, width: 500*s, height: 70*s)
		pages[0].blurbs.append(pages[0].pitchLabel)
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "create bubbles with the values you need", center: CGPoint(x: 120*s, y: 306*s), point: [CGPoint(x: 224*s, y: 284*s), CGPoint(x: 234*s, y: 350*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "optionally label any of the bubbles", center: CGPoint(x: 124*s, y: 500*s), point: [CGPoint(x: 224*s, y: 470*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "visually verify the inputs", center: CGPoint(x: 420*s, y: 200*s), point: [CGPoint(x: 290*s, y: 284*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define intermediate calculations", center: CGPoint(x: 480*s, y: 490*s), point: [CGPoint(x: 401*s, y: 450*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "modify the inputs to see how they affect the answer", center: CGPoint(x: 690*s, y: 410*s), point: [CGPoint(x: 554*s, y: 364*s)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "annotate your calculations with TextBubs", center: CGPoint(x: 720*s, y: 250*s), point: [CGPoint(x: 624*s, y: 204*s)])))
		pages[0].blurbs.append(pages[0].partingLabel)
		scrollView.addSubview(pages[0])
		
		pages[1].pitchLabel.topLeft(dx: 28*s, dy: 108*s, width: 360*s, height: 70*s)
		pages[1].blurbs.append(pages[1].pitchLabel)
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define columns not cells", center: CGPoint(x: 530*s, y: 120*s), point: [CGPoint(x: 639*s, y: 100*s)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "no more b1*c1\nand no more\ncopy and paste\nof formulas", center: CGPoint(x: 740*s, y: 180*s), point: [CGPoint(x: 694*s, y: 104*s)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "place multiple tables\nfreely on the aether; not\ntied to a single grid", center: CGPoint(x: 540*s, y: 390*s), point: [CGPoint(x: 449*s, y: 339*s), CGPoint(x: 384*s, y: 439*s)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "easily define footers as SUM, AVERAGE, COUNT or others", center: CGPoint(x: 220*s, y: 600*s), point: [CGPoint(x: 334*s, y: 544*s)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "reference tables from other bubbles and other bubbles from tables", center: CGPoint(x: 610*s, y: 600*s), point: [CGPoint(x: 510*s, y: 552*s)])))
		pages[1].blurbs.append(pages[1].partingLabel)
		scrollView.addSubview(pages[1])
		
		pages[2].pitchLabel.topLeft(dx: 240*s, dy: 60*s, width: 320*s, height: 70*s)
		pages[2].blurbs.append(pages[2].pitchLabel)
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define simple functions", center: CGPoint(x: 410*s, y: 170*s), point: [CGPoint(x: 478*s, y: 214*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "or sophisticated recursive functions", center: CGPoint(x: 330*s, y: 297*s), point: [CGPoint(x: 430*s, y: 340*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "make use of visual if-then-else statements", center: CGPoint(x: 800*s, y: 370*s), point: [CGPoint(x: 674*s, y: 434*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define tail optimized recursive functions", center: CGPoint(x: 120*s, y: 486*s), point: [CGPoint(x: 194*s, y: 444*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "set up timers and iterate through numerous values", center: CGPoint(x: 160*s, y: 130*s), point: [CGPoint(x: 254*s, y: 170*s)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "import other aethers and their functions", center: CGPoint(x: 800*s, y: 220*s), point: [CGPoint(x: 690*s, y: 178*s)])))
		pages[2].blurbs.append(pages[2].partingLabel)
		scrollView.addSubview(pages[2])
		
		pages[3].pitchLabel.topLeft(dx: 400*s, dy: 64*s, width: 480*s, height: 70*s)
		pages[3].blurbs.append(pages[3].pitchLabel)
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "Oovium is currently a shadow of what it is intended to be", center: CGPoint(x: 600*s, y: 190*s), point: [])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "planned additions include: custom objects,", center: CGPoint(x: 170*s, y: 120*s), point: [CGPoint(x: 250*s, y: 164*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "arrays, dictionaries and other data types", center: CGPoint(x: 260*s, y: 250*s), point: [CGPoint(x: 140*s, y: 240*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "the MiruBub will allow users to", center: CGPoint(x: 100*s, y: 440*s), point: [CGPoint(x: 160*s, y: 400*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "...slice and dice their data ala Improv", center: CGPoint(x: 196*s, y: 496*s), point: [CGPoint(x: 100*s, y: 454*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "Oovium Online will allow users to", center: CGPoint(x: 490*s, y: 380*s), point: [CGPoint(x: 340*s, y: 424*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "...upload and download aethers, publish and subscribe to feeds, as well as many other features", center: CGPoint(x: 440*s, y: 470*s), point: [CGPoint(x: 510*s, y: 380*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "further down the line, will Oovium become the visual R client you've always wanted?", center: CGPoint(x: 650*s, y: 550*s), point: [CGPoint(x: 730*s, y: 480*s)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "or the visual query builder for your relational database?", center: CGPoint(x: 790*s, y: 340*s), point: [CGPoint(x: 732*s, y: 412*s)])))
		pages[3].blurbs.append(pages[3].partingLabel)
		scrollView.addSubview(pages[3])
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
		layout1194x834()
	}
	func layout1194x834() {
		let s: CGFloat = Screen.mac ? Screen.height/768 : Screen.s
		let dy: CGFloat = Screen.mac ? Screen.safeTop : 0

		pages[0].pitchLabel.topLeft(dx: 224*s, dy: 60*s+dy, width: 480*s, height: 70*s)
		pages[0].blurbs.append(pages[0].pitchLabel)
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "create bubbles with the values you need", center: CGPoint(x: 120*s, y: 306*s), point: [CGPoint(x: 224*s, y: 284*s+dy), CGPoint(x: 234*s, y: 350*s+dy)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "optionally label any of the bubbles", center: CGPoint(x: 124*s, y: 500*s+dy), point: [CGPoint(x: 224*s, y: 470*s+dy)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "visually verify the inputs", center: CGPoint(x: 420*s, y: 200*s+dy), point: [CGPoint(x: 290*s, y: 284*s+dy)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define intermediate calculations", center: CGPoint(x: 480*s, y: 490*s+dy), point: [CGPoint(x: 401*s, y: 450*s+dy)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "modify the inputs to see how they affect the answer", center: CGPoint(x: 690*s, y: 410*s+dy), point: [CGPoint(x: 554*s, y: 364*s+dy)])))
		pages[0].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "annotate your calculations with TextBubs", center: CGPoint(x: 720*s, y: 250*s+dy), point: [CGPoint(x: 624*s, y: 204*s+dy)])))
		pages[0].blurbs.append(pages[0].partingLabel)
		scrollView.addSubview(pages[0])
		
		pages[1].pitchLabel.topLeft(dx: 28*s, dy: 108*s+dy, width: 360*s, height: 70*s)
		pages[1].blurbs.append(pages[1].pitchLabel)
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define columns not cells", center: CGPoint(x: 530*s, y: 120*s+dy), point: [CGPoint(x: 639*s, y: 100*s+dy)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "no more b1*c1\nand no more\ncopy and paste\nof formulas", center: CGPoint(x: 740*s, y: 180*s+dy), point: [CGPoint(x: 694*s, y: 104*s+dy)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "place multiple tables\nfreely on the aether; not\ntied to a single grid", center: CGPoint(x: 540*s, y: 390*s+dy), point: [CGPoint(x: 449*s, y: 339*s+dy), CGPoint(x: 384*s, y: 439*s+dy)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "easily define footers as SUM, AVERAGE, COUNT or others", center: CGPoint(x: 220*s, y: 600*s+dy), point: [CGPoint(x: 334*s, y: 544*s+dy)])))
		pages[1].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "reference tables from other bubbles and other bubbles from tables", center: CGPoint(x: 610*s, y: 600*s+dy), point: [CGPoint(x: 510*s, y: 552*s+dy)])))
		pages[1].blurbs.append(pages[1].partingLabel)
		scrollView.addSubview(pages[1])
		
		pages[2].pitchLabel.topLeft(dx: 240*s, dy: 60*s+dy, width: 320*s, height: 70*s)
		pages[2].blurbs.append(pages[2].pitchLabel)
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define simple functions", center: CGPoint(x: 410*s, y: 170*s+dy), point: [CGPoint(x: 478*s, y: 214*s+dy)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "or sophisticated recursive functions", center: CGPoint(x: 330*s, y: 297*s+dy), point: [CGPoint(x: 430*s, y: 340*s+dy)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "make use of visual if-then-else statements", center: CGPoint(x: 800*s, y: 370*s+dy), point: [CGPoint(x: 674*s, y: 434*s+dy)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "define tail optimized recursive functions", center: CGPoint(x: 120*s, y: 486*s+dy), point: [CGPoint(x: 194*s, y: 444*s+dy)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "set up timers and iterate through numerous values", center: CGPoint(x: 160*s, y: 130*s+dy), point: [CGPoint(x: 254*s, y: 170*s+dy)])))
		pages[2].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "import other aethers and their functions", center: CGPoint(x: 800*s, y: 220*s+dy), point: [CGPoint(x: 690*s, y: 178*s+dy)])))
		pages[2].blurbs.append(pages[2].partingLabel)
		scrollView.addSubview(pages[2])
		
		pages[3].pitchLabel.topLeft(dx: 400*s, dy: 64*s+dy, width: 480*s, height: 70*s)
		pages[3].blurbs.append(pages[3].pitchLabel)
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "Oovium is currently a shadow of what it is intended to be", center: CGPoint(x: 600*s, y: 190*s+dy), point: [])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "planned additions include: custom objects,", center: CGPoint(x: 170*s, y: 120*s+dy), point: [CGPoint(x: 250*s, y: 164*s+dy)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "arrays, dictionaries and other data types", center: CGPoint(x: 260*s, y: 250*s+dy), point: [CGPoint(x: 140*s, y: 240*s+dy)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "the MiruBub will allow users to", center: CGPoint(x: 100*s, y: 440*s+dy), point: [CGPoint(x: 160*s, y: 400*s+dy)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "...slice and dice their data ala Improv", center: CGPoint(x: 196*s, y: 496*s+dy), point: [CGPoint(x: 100*s, y: 454*s+dy)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "Oovium Online will allow users to", center: CGPoint(x: 490*s, y: 380*s+dy), point: [CGPoint(x: 340*s, y: 424*s+dy)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "...upload and download aethers, publish and subscribe to feeds, as well as many other features", center: CGPoint(x: 440*s, y: 470*s+dy), point: [CGPoint(x: 510*s, y: 380*s+dy)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "further down the line, will Oovium become the visual R client you've always wanted?", center: CGPoint(x: 650*s, y: 550*s+dy), point: [CGPoint(x: 730*s, y: 480*s+dy)])))
		pages[3].blurbs.append(NUXBubble(blurb: NUXBlurb(text: "or the visual query builder for your relational database?", center: CGPoint(x: 790*s, y: 340*s+dy), point: [CGPoint(x: 732*s, y: 412*s+dy)])))
		pages[3].blurbs.append(pages[3].partingLabel)
		scrollView.addSubview(pages[3])
	}

	// 1.52
	func layout1133x744() {
		layout1194x834()
	}

// Events ==========================================================================================
	private var x0: CGFloat = 0
	@objc func onPan(_ gesture: UIPanGestureRecognizer) {
		let dx: CGFloat = gesture.translation(in: scrollView).x
		let vx: CGFloat = gesture.velocity(in: scrollView).x
		let sw: CGFloat = scrollView.width
		switch gesture.state {
			case .began:
				x0 = scrollView.contentOffset.x
				pages[pageControl.currentPage].stop()
			case .changed:
				scrollView.contentOffset = CGPoint(x: (x0-dx).clamped(to: 0...(scrollView.width*3)), y: 0)
			case .ended:
				let x: CGFloat
				if abs(vx) > 1500 { x = x0-sw*abs(vx)/vx }
				else { x = sw*round((x0-dx)/sw) }
				scrollView.setContentOffset(CGPoint(x: x.clamped(to: 0...(scrollView.width*3)), y: 0), animated: true)
			default: break
		}
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		let s: CGFloat = Screen.mac ? Screen.height/768 : Screen.s

		scrollView.frame = bounds
		scrollView.contentSize = CGSize(width: width*4, height: height)
		shield.bottom(width: width, height: 96*s)
		pageControl.bottom(dy: -76*s, width: 200*s, height: 20*s)
		pages.enumerated().forEach { (index: Int, page: NUXPageView) in
			page.topLeft(dx: CGFloat(index)*width, width: width, height: height)
		}
	}
	
// UIScrollViewDelegate ============================================================================
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		pageControl.currentPage = Int(round(scrollView.contentOffset.x/scrollView.width))
	}
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		pages[pageControl.currentPage].start()
	}
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		pages[pageControl.currentPage].stop()
	}
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		guard Screen.mac else { return }
		pages[pageControl.currentPage].start()
	}
}
