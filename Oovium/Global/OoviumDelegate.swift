//
//  OoviumDelegate.swift
//  Oovium
//
//  Created by Joe Charlier on 10/1/16.
//  Copyright © 2016 Aepryus Software. All rights reserved.
//

import OoviumEngine
import OoviumKit
import UIKit

@main
class OoviumDelegate: UIResponder, UIApplicationDelegate, AetherViewDelegate {
	var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid

// UIApplicationDelegate ===========================================================================
	var window: UIWindow? {
		set { fatalError() }
		get { Oovium.window }
	}
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		Log.print("==================== [ Oovium - Booting ] =======================================")

		Oovium.start()

		return true
	}
    func applicationWillResignActive(_ application: UIApplication) {
		Log.print("==================== [ Oovium - Exiting ] =======================================")
        if Oovium.exitPond.started {
            guard Oovium.exitPond.complete else { return }
            Oovium.exitPond.reset()
        }
        Oovium.exitPond.start()
	}
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask { [.all] }
    
// MacOS ===========================================================================================
	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)

        builder.remove(menu: .services)
        builder.remove(menu: .hide)

		let aboutAction: UIAction = UIAction(title: "About Oovium", handler: { (action: UIAction) in
			if let backView = Oovium.aetherView.backView as? AboutView { backView.fade(aboutOn: true) }
            Oovium.aetherView.printTowers()
            print(Oovium.aetherView.aether.unload().toJSON())
		})
		builder.replace(menu: .about, with: UIMenu(title: "", image: nil, identifier: .about, options: .displayInline, children: [aboutAction]))

        let clearAction = UIAction(title: "Clear", handler: { _ in
            Oovium.aetherView.invokeConfirmModal("clearConfirm".localized, {
                Oovium.aetherView.clearAether()
            })
        })

        let aetherMenu: UIMenu = UIMenu(title: "Aether", children: [clearAction])
        builder.insertSibling(aetherMenu, afterMenu: .application)

        let tronAction = UIAction(title: "Tron", handler: { _ in Oovium.setSkin(.tron) })
        let ivoryAction = UIAction(title: "Ivory", handler: { _ in Oovium.setSkin(.ivory) })

        let skinMenu: UIMenu = UIMenu(title: "Skin", children: [tronAction, ivoryAction])
        builder.insertSibling(skinMenu, afterMenu: aetherMenu.identifier)

        let discordAction = UIAction(title: "Discord", handler: { _ in
            UIApplication.shared.open(URL(string: "https://discord.gg/BZ8bmhUgVq")!, options: [:], completionHandler: nil)
        })
        let vimeoAction = UIAction(title: "Vimeo", handler: { _ in
            UIApplication.shared.open(URL(string: "https://vimeo.com/aepryus")!, options: [:], completionHandler: nil)
        })
        let reviewAction = UIAction(title: "Review", handler: { _ in
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/app/oovium/id336573328?mt=8")!, options: [:], completionHandler: nil)
        })
        let ooviumAction = UIAction(title: "Oovium", handler: { _ in
            UIApplication.shared.open(URL(string: "http://aepryus.com/Principia?view=article&articleID=3")!, options: [:], completionHandler: nil)
        })
        
        let helpMenu: UIMenu = UIMenu(title: "Links", children: [discordAction, vimeoAction, reviewAction, ooviumAction])
        builder.insertSibling(helpMenu, afterMenu: skinMenu.identifier)
        
        let cheatSheetAction = UIAction(title: "Cheat Sheet", handler: { _ in
            Oovium.openStaticAether(name: "CheatSheet")
        })
        let whatsNewAction = UIAction(title: "What's New", handler: { _ in
            Oovium.openStaticAether(name: "WhatsNew")
        })
        let horizonAction = UIAction(title: "Horizon", handler: { _ in
            Oovium.openStaticAether(name: "Horizon")
        })
        let staticsMenu: UIMenu = UIMenu(title: "Statics", children: [cheatSheetAction, whatsNewAction, horizonAction])
        builder.insertChild(staticsMenu, atEndOfMenu: aetherMenu.identifier)
        
        builder.remove(menu: .file)
        builder.remove(menu: .edit)
        builder.remove(menu: .format)
        builder.remove(menu: .view)
        builder.remove(menu: .window)
        builder.remove(menu: .help)
	}
    
// AetherViewDelegate ==============================================================================
    func onNew(aetherView: AetherView, aether: Aether) {
        aetherView.markPositions()
    }
    func onClose(aetherView: AetherView, aether: Aether) {
        aetherView.markPositions()
    }
    func onOpen(aetherView: AetherView, aether: Aether) {
        guard let facade: AetherFacade = aetherView.facade else { return }
        Pequod.set(key: "aetherURL", value: facade.ooviumKey)
        OoviumState.behindView.leftExplorer.facade = facade.parent
        aetherView.orb.chainEditor.customSchematic?.render(aether: aether)
    }
    func onSave(aetherView: AetherView, aether: Aether) {}
}
