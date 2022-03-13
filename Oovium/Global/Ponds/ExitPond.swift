//
//  ExitPond.swift
//  Oovium
//
//  Created by Joe Charlier on 4/14/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

class ExitPond: BackgroundPond {

	lazy var saveAether: Pebble = {
		pebble(name: "Save Aether") { (complete: @escaping (Bool) -> ()) in
			guard let aetherView = Oovium.aetherView else { complete(false); return }
			aetherView.saveAether { (success: Bool) in
				complete(success)
			}

//			Pequod.synchronize()
//			aetherView.markPositions()
//			print("\(aetherView.aether.unload().toJSON())")
		}
	}()

// Init ============================================================================================
	init() {
		super.init { print("ExitPond timed Out without completing.") }

		saveAether.ready = { true }
	}
}
