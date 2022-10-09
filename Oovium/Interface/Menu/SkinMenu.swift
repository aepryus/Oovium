//
//  SkinMenu.swift
//  Oovium
//
//  Created by Joe Charlier on 10/5/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import OoviumKit
import UIKit

class SkinMenu: KeyPad {
    init(redDot: RedDot) {
        let schematic = Schematic(rows: 2, cols: 1)
        super.init(redDot: redDot, anchor: .bottomLeft, size: CGSize(width: 104, height: 214), offset: UIOffset(horizontal: 78, vertical: 0), fixed: RedDot.fixed, schematic: schematic)
        
        let apricot = UIColor(red: 1, green: 0.4, blue: 0.2, alpha: 1)

        schematic.add(row: 0, col: 0, key: Key(text: NSLocalizedString("tron", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: apricot, {
            self.redDot.dismissRootMenu()
            Oovium.setSkin(.tron)
        }))
        
        schematic.add(row: 1, col: 0, key: Key(text: NSLocalizedString("ivory", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: apricot, {
            self.redDot.dismissRootMenu()
            Oovium.setSkin(.ivory)
        }))
        
        self.schematic = schematic
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }

// Events ==========================================================================================
    override func onInvoke() {
        self.redDot.dismissAetherMenu()
        self.redDot.dismissHelpMenu()
        (self.redDot.rootMenu.schematic.keySlots[1].key as! Key).active = true
    }
    override func onDismiss() {
        (self.redDot.rootMenu.schematic.keySlots[1].key as! Key).active = false
    }
}
