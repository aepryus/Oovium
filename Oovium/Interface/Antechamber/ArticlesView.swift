//
//  ArticlesView.swift
//  Oovium
//
//  Created by Joe Charlier on 1/5/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import OoviumKit
import UIKit

class ArticlesView: AETableView, UITableViewDataSource {
	var articles: [Article] = []
	var selected: Article? = nil {
		didSet {
			guard let aether = selected?.aether else { return }
			antechamber.articleView.lockVerticalScrolling = true
			antechamber.articleView.swapToAether(aether: aether)
		}
	}
	unowned let antechamber: Antechamber
	
	init(antechamber: Antechamber) {
		self.antechamber = antechamber

		super.init()

		backgroundColor = .clear

		let Oo2Released: Date = Date("9/4/20")
		
		var article: Article = Article()
		article.title = "Oovium Moving to Subscriptions"
		article.date = Oo2Released
		article.aether = Aether(json: Local.aetherJSONFromBundle(name: "Subscriptions"))
		articles.append(article)
		
		article = Article()
		article.title = "Oovium 2.0 Completed"
		article.date = Oo2Released
		article.aether = Aether(json: Local.aetherJSONFromBundle(name: "Oovium2"))
		articles.append(article)
		
		article = Article()
		article.title = "Oovium To Do"
		article.date = Oo2Released
		article.aether = Aether(json: Local.aetherJSONFromBundle(name: "OoviumToDo"))
		articles.append(article)
		
		article = Article()
		article.title = "Aexels and Evolizer"
		article.date = Oo2Released
		article.aether = Aether(json: Local.aetherJSONFromBundle(name: "AexelsEvolizer"))
		articles.append(article)
		
		dataSource = self
		register(ArticleCell.self, forCellReuseIdentifier: "cell")
		contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 6*s, right: 0)
		
		defer {
			selected = articles[0]
		}
	}
	required init?(coder: NSCoder) {fatalError()}
	
// UITableViewDataSource ===========================================================================
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		articles.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ArticleCell
		cell.antechamber = antechamber
		cell.article = articles[indexPath.row]
		return cell
	}
}
