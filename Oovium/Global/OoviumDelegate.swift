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
        Oovium.menu.buildMenu(with: builder)
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
