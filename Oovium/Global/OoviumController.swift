//
//  OoviumController.swift
//  Oovium
//
//  Created by Joe Charlier on 2/23/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import OoviumKit
import UIKit
import UniformTypeIdentifiers

class OoviumController: UIViewController, UIDocumentPickerDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addKeyCommand(UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(onEscape)))
        addKeyCommand(UIKeyCommand(input: "\r", modifierFlags: [], action: #selector(onReturn)))
        addKeyCommand(UIKeyCommand(input: UIKeyCommand.inputDelete, modifierFlags: [], action: #selector(onDelete)))
        addKeyCommand(UIKeyCommand(input: "\u{7f}", modifierFlags: [], action: #selector(onDelete)))
        addKeyCommand(UIKeyCommand(input: "x", modifierFlags: [.command], action: #selector(onCut)))
        addKeyCommand(UIKeyCommand(input: "c", modifierFlags: [.command], action: #selector(onCopy)))
        addKeyCommand(UIKeyCommand(input: "v", modifierFlags: [.command], action: #selector(onPaste)))
        addKeyCommand(UIKeyCommand(input: "z", modifierFlags: [.command], action: #selector(onUndo)))
        addKeyCommand(UIKeyCommand(input: "z", modifierFlags: [.command, .shift], action: #selector(onRedo)))
        addKeyCommand(UIKeyCommand(input: "a", modifierFlags: [.command,], action: #selector(onSelectAll)))
        addKeyCommand(UIKeyCommand(input: "y", modifierFlags: [], action: #selector(onYes)))
        addKeyCommand(UIKeyCommand(input: "n", modifierFlags: [], action: #selector(onNo)))
    }
    required init?(coder: NSCoder) { fatalError() }

    func stretch() {
        Oovium.aetherView.stretch()
        Oovium.aetherView.needsStretch = false
    }
    
// Menus ==========================================================================================
    func onAbout() {
        if let backView = Oovium.aetherView.backView as? AboutView { backView.fade(aboutOn: true) }
        Oovium.aetherView.printTowers()
        print(Oovium.aetherView.aether.unload().toJSON())
    }
    @objc func onClear() {
        Oovium.aetherView.invokeConfirmModal("clearConfirm".localized, {
            Oovium.aetherView.clearAether()
        })
    }
    @objc func onNew() {
        OoviumState.behindView.leftExplorer.controller.onNewAether()
    }
    @objc func onOpen() {
        Oovium.aetherView.controller.toggleExplorer()
    }
    @objc func onSave() {
        Oovium.aetherView.saveAether()
        
    }
    @objc func onDuplicate() {
        Oovium.aetherView.controller.duplicateAether()
    }
    @objc func onInsertCSV() {
        let controller: UIDocumentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.commaSeparatedText])
        controller.allowsMultipleSelection = true
        controller.delegate = self
        present(controller, animated: true) {}
    }

// Keys ============================================================================================
    @objc func onReturn() { Oovium.aetherView.onReturnQ() }
    @objc func onEscape() { Oovium.aetherView.onEscape() }
    @objc func onDelete() { Oovium.aetherView.onDelete() }
    @objc func onCut() { Oovium.aetherView.onCut() }
    @objc func onCopy() { Oovium.aetherView.onCopy() }
    @objc func onPaste() { Oovium.aetherView.onPaste() }
    @objc func onUndo() { Oovium.aetherView.undo() }
    @objc func onRedo() { Oovium.aetherView.redo() }
    @objc func onSelectAll() { Oovium.aetherView.selectAll() }
    @objc func onYes() { Oovium.aetherView.onYes() }
    @objc func onNo() { Oovium.aetherView.onNo() }

// UIViewController ================================================================================
    override var preferredStatusBarStyle: UIStatusBarStyle { Skin.statusBarStyle }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .fade }
    override var prefersHomeIndicatorAutoHidden: Bool { true }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if Screen.mac {
            Oovium.aetherView.frame = CGRect(x: Oovium.aetherView.left, y: Screen.safeTop, width: size.width, height: size.height-Screen.safeTop)
            OoviumState.behindView.frame = CGRect(origin: OoviumState.behindView.frame.origin, size: CGSize(width: OoviumState.behindView.width, height: size.height-OoviumState.behindView.top))
        } else {
            // [ Hack ] This assumes that safeTop == safeLeft in order to anticipate safeLeft before the animation occurs.  Can't use the coordinator because the Hovers get messed up. jjc 10/10/22
            let safeLeft: CGFloat = size.width == Screen.width ? 0 : max(Screen.safeTop, Screen.safeLeft)
            let x: CGFloat = Oovium.aetherView.left == 0 ? 0 : Screen.iPhone ? Screen.width - 20*Screen.s + safeLeft : 355*Screen.s
            Oovium.aetherView.frame = CGRect(x: x, y: Oovium.aetherView.top, width: size.width, height: size.height-Oovium.aetherView.top)
            OoviumState.behindView.frame = CGRect(origin: OoviumState.behindView.frame.origin, size: CGSize(width: OoviumState.behindView.width, height: size.height-OoviumState.behindView.top))
        }
        coordinator.animate { (context: UIViewControllerTransitionCoordinatorContext) in
            Modal.shieldView.render()
        }
    }
    
// UIDocumentPickerDelegate ========================================================================
    private func importCSVs(urls: [URL]) throws {
        urls.forEach {
            guard let data: Data = FileManager.default.contents(atPath: $0.path),
                  let dataString = String(data: data, encoding: .utf8)
                else { return }
            
            let lines: [String] = CSV.split(csv: dataString)
            let csv: [[String]] = lines.map { CSV.split(line: $0) }
            Oovium.aetherView.importCSV(tokens: csv)
        }
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            try importCSVs(urls: [url])
        } catch {
            print("\(error)")
        }
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        do {
            try importCSVs(urls: urls)
        } catch {
            print("\(error)")
        }
    }
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) { }
}
