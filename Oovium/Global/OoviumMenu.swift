//
//  OoviumMenu.swift
//  Oovium
//
//  Created by Joe Charlier on 11/2/24.
//  Copyright © 2024 Aepryus Software. All rights reserved.
//

import UIKit

class OoviumMenu {
   func buildMenu(with builder: UIMenuBuilder) {
       [.services, .hide, .file, .edit, .format, .view, .window, .help].forEach { builder.remove(menu: $0) }

       let aboutAction = UIAction(title: "About Oovium", handler: { _ in Oovium.aetherController.onAbout() })
       builder.replace(menu: .about, with: UIMenu(title: "", identifier: .about, options: .displayInline, children: [aboutAction]))

       let clearAction = UIAction(title: "Clear", handler: { _ in Oovium.aetherController.onClear() })
       
       let aetherMenu = UIMenu(title: "Aether", children: [clearAction])
       builder.insertSibling(aetherMenu, afterMenu: .application)

       let staticsMenu = UIMenu(title: "Statics", children: [
           UIAction(title: "Cheat Sheet", handler: { _ in Oovium.openStaticAether(name: "CheatSheet") }),
           UIAction(title: "What's New", handler: { _ in Oovium.openStaticAether(name: "WhatsNew") }),
           UIAction(title: "Horizon", handler: { _ in Oovium.openStaticAether(name: "Horizon") })
       ])
       builder.insertChild(staticsMenu, atEndOfMenu: aetherMenu.identifier)

       let skinMenu = UIMenu(title: "Skins", image: UIImage(systemName: "paintbrush"), children: [
            UIAction(title: "Tron".localized, state: Oovium.skin == .tron ? .on : .off) { _ in
               Oovium.skin = .tron
               UIMenuSystem.main.setNeedsRebuild()
           },
           UIAction(title: "Ivory".localized, state: Oovium.skin == .ivory ? .on : .off) { _ in
               Oovium.skin = .ivory
               UIMenuSystem.main.setNeedsRebuild()
           }
       ])
       
       let selectionMenu = UIMenu(title: "Selection Mode", image: UIImage(systemName: "lasso"), children: [
           UIAction(title: "Lasso".localized, state: Oovium.selectionMode == .lasso ? .on : .off) { _ in
               Oovium.selectionMode = .lasso
               UIMenuSystem.main.setNeedsRebuild()
           },
           UIAction(title: "Rectangle".localized, state: Oovium.selectionMode == .rectangle ? .on : .off) { _ in
               Oovium.selectionMode = .rectangle
               UIMenuSystem.main.setNeedsRebuild()
           }
       ])

       let optionsMenu = UIMenu(title: "Options", children: [skinMenu, selectionMenu])
       builder.insertSibling(optionsMenu, afterMenu: aetherMenu.identifier)

       let linksMenu = UIMenu(title: "Links", children: [
           UIAction(title: "Discord", handler: { _ in UIApplication.shared.open(URL(string: "https://discord.gg/BZ8bmhUgVq")!) }),
           UIAction(title: "Vimeo", handler: { _ in UIApplication.shared.open(URL(string: "https://vimeo.com/aepryus")!) }),
           UIAction(title: "Review", handler: { _ in UIApplication.shared.open(URL(string: "http://itunes.apple.com/app/oovium/id336573328?mt=8")!) }),
           UIAction(title: "Oovium", handler: { _ in UIApplication.shared.open(URL(string: "http://aepryus.com/Principia?view=article&articleID=3")!) })
       ])
       builder.insertSibling(linksMenu, afterMenu: optionsMenu.identifier)
   }
}
