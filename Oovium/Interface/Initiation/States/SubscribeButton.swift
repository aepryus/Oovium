//
//  SubscribeButton.swift
//  Oovium
//
//  Created by Joe Charlier on 7/8/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class SubscribeButton: UIControl {
	var mainText: NSAttributedString = NSAttributedString() {
		didSet {
			mainLabel.attributedText = mainText
			setNeedsLayout()
		}
	}
	var subText: NSAttributedString = NSAttributedString() {
		didSet {
			subLabel.attributedText = subText
			setNeedsLayout()
		}
	}
	
	private let mainLabel: UILabel = UILabel()
	private let subLabel: UILabel = UILabel()
	
	init() {
		super.init(frame: .zero)
		
		addSubview(mainLabel)
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func layoutSubviews() {
		let s: CGFloat = Screen.mac ? Screen.height/768 : Screen.s

		mainLabel.sizeToFit()
		if let usedTrial = Pequod.usedTrial, usedTrial {
			subLabel.removeFromSuperview()
			mainLabel.center()
		} else {
			addSubview(subLabel)
			subLabel.sizeToFit()
			if Screen.iPhone {
				mainLabel.center(dy: -7*s)
				subLabel.center(dy: 9*s)
			} else {
				mainLabel.center(dy: -9*s)
				subLabel.center(dy: 11*s)
			}
		}
	}
}
