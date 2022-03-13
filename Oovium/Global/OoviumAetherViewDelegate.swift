//
//  OoviumAetherViewDelegate.swift
//  Oovium
//
//  Created by Joe Charlier on 3/10/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine
import OoviumKit

class OoviumAetherViewDelegate: AetherViewDelegate {
	func onNew(aetherView: AetherView, aether: Aether) {
		aetherView.markPositions()
		aetherView.space?.storeAether(aether, complete: { (success: Bool) in })
	}
	func onClose(aetherView: AetherView, aether: Aether) {
		aetherView.markPositions()
		aetherView.space?.storeAether(aether)
	}
	func onOpen(aetherView: AetherView, aether: Aether) {
		if let space: Space = aetherView.space {
			Pequod.set(key: "aetherPath", value: space.aetherPath(aether: aether))
		}
		aetherView.orb.chainEditor.customSchematic?.render(aether: aether)
	}
	func onSave(aetherView: AetherView, aether: Aether) {}
}
