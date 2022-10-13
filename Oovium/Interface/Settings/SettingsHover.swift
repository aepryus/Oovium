//
//  SettingsHover.swift
//  Oovium
//
//  Created by Joe Charlier on 8/20/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import OoviumKit
import UIKit

public class SettingsHover: Modal {
	
	let scaleView = ScaleView()
    let swapButton: SwapButton = SwapButton()
    let ok: Trapezoid = Trapezoid(title: "OK".localized, leftSlant: .down, rightSlant: .up)
    let cancel: Trapezoid = Trapezoid(title: "Cancel".localized, leftSlant: .up, rightSlant: .down)
	
	public init(aetherView: AetherView) {
        super.init(anchor: .center, size: CGSize(width: 200, height: 200))
		super.render()
		
		scaleView.onChange = {(scale: CGFloat) in
			Oo.s = scale
		}
		addSubview(scaleView)

        addSubview(swapButton)
        swapButton.addAction { [unowned swapButton] in
            swapButton.rotateView()
        }
        
        addSubview(ok)
        ok.addAction { [unowned self] in
            self.dismiss()
            Loom.transact {
                Oovium.settings.skin = self.swapButton.position == 0 ? .tron : .ivory
            }
            print("\(Oovium.settings.unload().toJSON())")
            Skin.skin = Oovium.settings.skin.skin
            Oovium.reRender()
        }

        addSubview(cancel)
        cancel.addAction { [weak self] in self?.dismiss() }
        
        print("Settings: \(Oovium.settings.unload().toJSON())")
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

// UIView ==========================================================================================
    public override func layoutSubviews() {
        scaleView.frame = CGRect(x: 50, y: 50, width: 200, height: 100)
        swapButton.topLeft(dx: 20*Oo.gS, dy: 20*Oo.gS, width: 24*Oo.gS, height: 24*Oo.gS)
        cancel.bottomLeft(dx: 16*gS, dy: -16*gS, width: 128*gS, height: 32*gS)
        ok.topRight(dx: -16*gS, dy: 16*gS, width: 128*gS, height: 32*gS)
    }
    public override func draw(_ rect: CGRect) {
        let path = CGMutablePath()
        path.addRoundedRect(in: rect.insetBy(dx: 2*Oo.s, dy: 2*Oo.s), cornerWidth: 6*Oo.s, cornerHeight: 6*Oo.s)
        Skin.bubble(path: path, uiColor: OOColor.marine.uiColor, width: 4.0/3.0*Oo.s)
    }
}
