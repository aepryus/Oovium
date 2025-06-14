/* =================================================================================================
	Oovium
	- objects to the people!
	- bringing sexy back
	- cogito ergo Oovium
	- μή μου τούς κύκλους τάραττε
    - a bicycle for the mind

	by Aepryus

	"I wonder how you'd take to working in a pocket calculator." - MCP

	Started: March 23, 2009
	Joe Charlier | Aepryus Software
================================================================================================= */

//
//  Oovium.swift
//  Oovium
//
//  Created by Joe Charlier on 10/1/16.
//  Copyright © 2016 Aepryus Software. All rights reserved.
//

import Acheron
import GameController
import OoviumEngine
import OoviumKit
import UIKit

public class Oovium {
	static var window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
	static var aetherController: OoviumController!
    static var menu: OoviumMenu = OoviumMenu()
	static var aetherView: AetherView!
    static var redDot: RedDot!

	static let bootPond: BootPond = BootPond()
	static let exitPond: ExitPond = ExitPond()
    
    static var settings: Settings = Settings()
    
    static var facade: DirFacade {
        set { OoviumState.behindView.leftExplorer.facade = newValue }
        get { OoviumState.behindView.leftExplorer.facade }
    }

	static var version: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0" }
	public static var screenBurn: Bool = true

	static let taglines = [
        "objects to the people!",
        "bringing sexy back",
        "cogito ergo Oovium",
        "μή μου τούς κύκλους τάραττε",
        "a bicycle for the mind",
        "escape from the grid"
    ]

    static func tagline() -> String { taglines.randomElement()! }

	static func color(for def: Def) -> UIColor {
		if def === RealDef.def { return UIColor.green }
		else if def === ComplexDef.def { return UIColor.cyan }
		else if def === VectorDef.def { return Text.Color.marine.uiColor }
		else if def === StringDef.def { return Text.Color.peach.uiColor }
		else if def === LambdaDef.def { return UIColor.cyan }
		else if def === RecipeDef.def { return UIColor.blue }
		else if def === DateDef.def { return UIColor.yellow }
		return UIColor.red
	}

	static var deviceDescription: String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let hardware = String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
		return "\(hardware);"
	}

    static func openStaticAether(name: String) {
        Oovium.aetherView.closeCurrentAether()
        Oovium.aetherView.facade = AetherFacade(name: name, parent: SpaceFacade(space: Space.statics))
        do {
            let aether: Aether = try Aether(json: Local.aetherJSONFromBundle(name: name))
            Oovium.aetherView.openAether(aether)
        } catch {}
    }
    
// Settings ========================================================================================
    static var skin: Settings.Skin {
        set {
            Loom.transact { Oovium.settings.skin = newValue }
            Skin.skin = Oovium.settings.skin.skin
            Oovium.reRender()
        }
        get { Oovium.settings.skin }
    }
    static var selectionMode: SelectionMode {
        set { Loom.transact { Oovium.settings.selectionMode = newValue } }
        get { Oovium.settings.selectionMode }
    }

// =================================================================================================

	static func alert(title: String? = nil, message: String, complete: @escaping ()->() = {}) {
		let controller: UIAlertController = UIAlertController(title: title ?? "Oovium", message: message, preferredStyle: .alert)
		controller.addAction(UIAlertAction(title: "OK".localized, style: .default) { (action: UIAlertAction) in
			complete()
		})
		Screen.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
	}
    
    static func setSkin(_ skin: Settings.Skin) {
    }

	static func redisplay(view: UIView) {
		view.setNeedsDisplay()
		view.subviews.forEach {Oovium.redisplay(view: $0)}
	}
	static func reRender() {
        Oovium.aetherView.backgroundColor = Skin.backColor
        (Oovium.aetherView.backView as! AboutView).fade()
		aetherView.hovers.forEach {
			Oovium.redisplay(view: $0)
			$0.reRender()
		}
		Oovium.redisplay(view: Oovium.aetherView)
		Oovium.aetherController.setNeedsStatusBarAppearanceUpdate()
	}

	static func start() {
        _ = ChainResponder.hasExternalKeyboard

		_ = UIFont.registerFont(bundle: fontBundle, fontName: "ChicagoFLF", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: fontBundle, fontName: "cambria", fontExtension: "ttc")

		Loom.start(basket: Pequod.basket, namespaces: ["Oovium", "OoviumKit", "OoviumEngine"])
		Pequod.basket.associate(type: "shell", only: "name")

		window.rootViewController = UIViewController()
		window.makeKeyAndVisible()

		bootPond.start()
	}
}
