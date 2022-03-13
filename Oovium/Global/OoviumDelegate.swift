//
//  OoviumDelegate.swift
//  Oovium
//
//  Created by Joe Charlier on 10/1/16.
//  Copyright © 2016 Aepryus Software. All rights reserved.
//

import OoviumKit
import UIKit

@main
class OoviumDelegate: UIResponder, UIApplicationDelegate {
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
	func applicationDidBecomeActive(_ application: UIApplication) {
		Oovium.bootPond.addCompletionTask {
//			Oovium.iCloudDownload()
			iCloud.uploadClassic()
		}
	}
	func applicationWillResignActive(_ application: UIApplication) {
		Log.print("==================== [ Oovium - Exiting ] =======================================")
		Oovium.exitPond.start()
	}
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return [.all]
	}

// MacOS ===========================================================================================
	@objc func onAbout() {
		if let backView = Oovium.aetherView.backView as? BackView { backView.fade(aboutOn: true) }
	}

	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)
		
		builder.remove(menu: .services)
		builder.remove(menu: .format)
		builder.remove(menu: .toolbar)

		var action: UIAction = UIAction(title: "About Oovium", handler: { (action: UIAction) in
			if let backView = Oovium.aetherView.backView as? BackView { backView.fade(aboutOn: true) }
		})
		builder.replace(menu: .about, with: UIMenu(title: "", image: nil, identifier: .about, options: .displayInline, children: [action]))

		action = UIAction(title: "Preferences...", handler: { (action: UIAction) in
			print("Preferences...")
		})

		let menu: UIMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [action])
		builder.insertSibling(menu, afterMenu: .about)
	}
}
