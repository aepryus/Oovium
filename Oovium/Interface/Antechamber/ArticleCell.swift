//
//  ArticleCell.swift
//  Oovium
//
//  Created by Joe Charlier on 1/5/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
	unowned var antechamber: Antechamber!
	var article: Article! {
		didSet {
			dateLabel.text = ArticleCell.dateFormatter.string(from: article.date)
			titleLabel.text = article.title
			backView.layer.backgroundColor = uiColor.alpha(0.6).cgColor
			backView.layer.borderColor = uiColor.cgColor
			setNeedsLayout()
		}
	}
	
	let backView: UIView = UIView()
	let dateLabel: UILabel = UILabel()
	let titleLabel: UILabel = UILabel()
	
	static let dateFormatter: DateFormatter = {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateFormat = "MMM d, yyyy"
		return formatter
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .clear
		
		backView.layer.cornerRadius = 5*s
		backView.layer.borderWidth = 1.5*s
		addSubview(backView)

		dateLabel.font = UIFont.verdana(size: 13)
		dateLabel.textColor = .black
		dateLabel.textAlignment = .right
		backView.addSubview(dateLabel)

		titleLabel.font = UIFont.verdana(size: 18)
		titleLabel.textColor = .black
		titleLabel.numberOfLines = 0
		backView.addSubview(titleLabel)
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
		addGestureRecognizer(gesture)
	}
	required init?(coder: NSCoder) { fatalError() }
	
	var uiColor: UIColor {
		if antechamber.selected !== article {
			return UIColor(rgb: 0xCEF3E2)
		} else {
			return UIColor(rgb: 0xF3E2CE)
		}
	}
	
// Events ==========================================================================================
	@objc func onTap() {
		antechamber.selected = article
	}
	
// UIView ==========================================================================================
	override func layoutSubviews() {
		backView.bottom(width: width-10*s, height: height-6*s)
		dateLabel.bottomRight(dx: -5*s, dy: -5*s, width: 160*s, height: 13*s)

		titleLabel.frame = CGRect(x: 0, y: 0, width: width-20, height: 1)
		titleLabel.sizeToFit()
		titleLabel.topLeft(dx: 5*s, dy: 5*s)
	}
}
