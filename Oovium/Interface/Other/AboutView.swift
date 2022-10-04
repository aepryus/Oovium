//
//  AboutView.swift
//  Oovium
//
//  Created by Joe Charlier on 9/22/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumKit
import UIKit

class AboutView: UIView {
    let graphImage: UIImageView = UIImageView()
    let ooviumLabel: UILabel = UILabel()
    let aepryusLabel: UILabel = UILabel()
    let versionLabel: UILabel = UILabel()
    let tagLineLabel: UILabel = UILabel()
    let copyrightLabel: UILabel = UILabel()
    
    let pen80: Pen = Pen(font: UIFont.ooMath(size: 89*Screen.s), color: .white)
    let pen23: Pen = Pen(font: UIFont(name: "Palatino", size: 23*Screen.s)!, color: .white)
    let penItalic: Pen = Pen(font: UIFont(name: "Palatino-Italic", size: 23*Screen.s)!, color: .white, alignment: .center)

    init() {
        super.init(frame: .zero)
        backgroundColor = Skin.backColor
        
        graphImage.image = UIImage(named: "Graph")!
        graphImage.contentMode = .scaleAspectFill
        addSubview(graphImage)
        
        ooviumLabel.text = "Oovium"
        ooviumLabel.pen = pen80
        ooviumLabel.shadowColor = .green.alpha(0.7)
        addSubview(ooviumLabel)
        
        versionLabel.text = "\("Version".localized) \(Oovium.version)"
        versionLabel.pen = pen23
        versionLabel.shadowColor = .green.alpha(0.4)
        addSubview(versionLabel)
        
        tagLineLabel.text = Oovium.tagline()
        tagLineLabel.pen = penItalic
        tagLineLabel.shadowColor = .green.alpha(0.4)
        addSubview(tagLineLabel)
        
        aepryusLabel.text = "Aepryus Software"
        aepryusLabel.pen = pen23
        aepryusLabel.shadowColor = .green.alpha(0.4)
        addSubview(aepryusLabel)
        
        copyrightLabel.text = "\u{00A9} 2022"
        copyrightLabel.pen = pen23
        copyrightLabel.shadowColor = .green.alpha(0.4)
        addSubview(copyrightLabel)
        
        faded()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func faded() {
        graphImage.alpha = 0.2
        ooviumLabel.alpha = 0.2
        versionLabel.alpha = 0
        tagLineLabel.alpha = 0
        aepryusLabel.alpha = 0
        copyrightLabel.alpha = 0
    }
    private func brighten(aboutOn: Bool) {
        graphImage.alpha = 1
        ooviumLabel.alpha = 1
        versionLabel.alpha = aboutOn ? 1 : 0
        tagLineLabel.alpha = aboutOn ? 1 : 0
        aepryusLabel.alpha = aboutOn ? 1 : 0
        copyrightLabel.alpha = aboutOn ? 1 : 0
    }
    
    func fade(aboutOn: Bool) {
        tagLineLabel.text = Oovium.tagline()
        brighten(aboutOn: aboutOn)
        UIView.animate(withDuration: 8.0) {
            self.faded()
        }
    }
    
    private func layout046() {
        graphImage.topLeft(dx: -60*s, dy: 120*s, width: 740*s, height: 740*s * graphImage.image!.ratio)
        ooviumLabel.topLeft(dx: 12*s, dy: 110*s, width: 300*s, height: 80*s)
        versionLabel.topLeft(dx: 180*s, dy: ooviumLabel.bottom, width: 160*s, height: 23*s)
        tagLineLabel.topLeft(dx: -46*s, dy: 296*s, width: 360*s, height: 30*s)
        copyrightLabel.topLeft(dx: 640*s, dy: 1000*s, width: 72*s, height: 23*s)
        aepryusLabel.topLeft(dx: 540*s, dy: copyrightLabel.bottom, width: 188*s, height: 23*s)
    }
    private func layoutOther() {
        graphImage.topLeft(dx: 56*s, dy: 220*s, width: 740*s, height: 740*s * graphImage.image!.ratio)
        ooviumLabel.topLeft(dx: 32*s, dy: 110*s, width: 300*s, height: 80*s)
        versionLabel.topLeft(dx: 200*s, dy: ooviumLabel.bottom, width: 160*s, height: 23*s)
        tagLineLabel.topLeft(dx: 20*s, dy: 380*s, width: 360*s, height: 30*s)
        copyrightLabel.topLeft(dx: 640*s, dy: 1000*s, width: 72*s, height: 23*s)
        aepryusLabel.topLeft(dx: 540*s, dy: copyrightLabel.bottom, width: 188*s, height: 23*s)
    }
    
// UIView ==========================================================================================
    override func layoutSubviews() {
        switch Screen.ratio {
            case .rat046:   layout046()
            case .rat056:   layout046()
            case .rat067:   layout046()
            default:        layoutOther()
        }
    }
}
