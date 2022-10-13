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
		Oovium.exitPond.start()
	}
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask { [.all] }
    
// MacOS ===========================================================================================
	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)

		builder.remove(menu: .services)
		builder.remove(menu: .format)
		builder.remove(menu: .toolbar)

		let aboutAction: UIAction = UIAction(title: "About Oovium", handler: { (action: UIAction) in
			if let backView = Oovium.aetherView.backView as? AboutView { backView.fade(aboutOn: true) }
		})
		builder.replace(menu: .about, with: UIMenu(title: "", image: nil, identifier: .about, options: .displayInline, children: [aboutAction]))
        
        let tronAction = UIAction(title: "Tron", handler: { (action: UIAction) in
            Oovium.setSkin(.tron)
        })

        let ivoryAction = UIAction(title: "Ivory", handler: { (action: UIAction) in
            Oovium.setSkin(.ivory)
        })

        let menu: UIMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [tronAction, ivoryAction])
        builder.insertSibling(menu, afterMenu: .about)
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
