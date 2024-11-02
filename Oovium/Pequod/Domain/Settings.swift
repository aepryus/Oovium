//
//  Settings.swift
//  Oovium
//
//  Created by Joe Charlier on 9/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import OoviumKit

class Settings: Anchor {
    enum Skin: CaseIterable {
        case tron, ivory
        
        var skin: OoviumKit.Skin {
            switch self {
                case .tron: return Skin.tronSkin
                case .ivory: return Skin.ivorySkin
            }
        }
        
        static let tronSkin: TronSkin = TronSkin()
        static let ivorySkin: IvorySkin = IvorySkin()
    }
    enum SelectionMode: CaseIterable {
        case lasso, rectangle
    }
    
    var skin: Skin {
        set { skinString = newValue.toString() }
        get { Skin.from(string: skinString)! }
    }
    var selectionMode: SelectionMode {
        set { selectionModeString = newValue.toString() }
        get { SelectionMode.from(string: selectionModeString)! }
    }
    
    @objc dynamic var skinString: String = Skin.tron.toString()
    @objc dynamic var selectionModeString: String = "lasso"
    @objc dynamic var gadgetScale: Double = 1
    @objc dynamic var aetherScale: Double = 1
    
// Domain ==========================================================================================
    override var properties: [String] { super.properties + ["skinString", "selectionModeString", "gadgetScale", "aetherScale"] }
}
