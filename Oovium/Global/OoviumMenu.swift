//
//  OoviumMenu.swift
//  Oovium
//
//  Created by Joe Charlier on 11/2/24.
//  Copyright © 2024 Aepryus Software. All rights reserved.
//

import UIKit


class OoviumMenu {
    func buildMenu(with builder: UIMenuBuilder) {
        // Only modify the main system menu
        guard builder.system == .main else { return }
        
        // Remove default system menus
        [.services, .hide, .file, .edit, .format, .view, .window, .help].forEach {
            builder.remove(menu: $0)
        }

        // About Menu
        let aboutAction: UIAction = UIAction(title: "About Oovium", handler: { (action: UIAction) in
            Oovium.aetherController.onAbout()
        })
        builder.replace(menu: .about, with: UIMenu(title: "", identifier: .about, options: .displayInline, children: [aboutAction]))

        // Aether Menu
        let newCommand: UIKeyCommand = UIKeyCommand(title: "New".localized, action: #selector(Oovium.aetherController.onNew), input: "n", modifierFlags: .command)
        let openCommand: UIKeyCommand = UIKeyCommand(title: "Open".localized, action: #selector(Oovium.aetherController.onOpen), input: "o", modifierFlags: .command)
        let saveCommand: UIKeyCommand = UIKeyCommand(title: "Save".localized, action: #selector(Oovium.aetherController.onSave), input: "s", modifierFlags: .command)
        let duplicateCommand: UIKeyCommand = UIKeyCommand(title: "Duplicate".localized, action: #selector(Oovium.aetherController.onDuplicate), input: "d", modifierFlags: .command)
        let clearCommand: UICommand = UICommand(title: "Clear".localized, action: #selector(Oovium.aetherController.onClear))

        let cheatSheetAction: UIAction = UIAction(title: "Cheat Sheet", handler: { (action: UIAction) in
            Oovium.openStaticAether(name: "CheatSheet")
        })
        
        let version31Action: UIAction = UIAction(title: "Version 3.1", handler: { (action: UIAction) in
            Oovium.openStaticAether(name: "WhatsNew31")
        })
        let version30Action: UIAction = UIAction(title: "Version 3.0", handler: { (action: UIAction) in
            Oovium.openStaticAether(name: "WhatsNew30")
        })
        let whatsNewMenu: UIMenu = UIMenu(title: "What's New", children: [version31Action, version30Action])
        
        let roadMapAction: UIAction = UIAction(title: "Road Map", handler: { (action: UIAction) in
            Oovium.openStaticAether(name: "Horizon31")
        })

        let aetherMenu: UIMenu = UIMenu(title: "Aether", children: [
            UIMenu(title: "", options: .displayInline, children: [
                newCommand, openCommand, saveCommand, duplicateCommand, clearCommand
            ]),
            UIMenu(title: "", options: .displayInline, children: [
                cheatSheetAction, whatsNewMenu, roadMapAction
            ])
        ])        
        builder.insertSibling(aetherMenu, afterMenu: .application)

        // Edit Menu
        let undoCommand: UIKeyCommand = UIKeyCommand(title: "Undo".localized, action: #selector(Oovium.aetherController.onUndo), input: "z", modifierFlags: .command)
        let redoCommand: UIKeyCommand = UIKeyCommand(title: "Redo".localized, action: #selector(Oovium.aetherController.onRedo), input: "z", modifierFlags: [.command, .shift])
        let cutCommand: UIKeyCommand = UIKeyCommand(title: "Cut".localized, action: #selector(Oovium.aetherController.onCut), input: "x", modifierFlags: .command)
        let copyCommand: UIKeyCommand = UIKeyCommand(title: "Copy".localized, action: #selector(Oovium.aetherController.onCopy), input: "c", modifierFlags: .command)
        let pasteCommand: UIKeyCommand = UIKeyCommand(title: "Paste".localized, action: #selector(Oovium.aetherController.onPaste), input: "v", modifierFlags: .command)
        let selectAllCommand: UIKeyCommand = UIKeyCommand(title: "Select All".localized, action: #selector(Oovium.aetherController.onSelectAll), input: "a", modifierFlags: .command)

        let editMenu: UIMenu = UIMenu(title: "Aedit", children: [
            UIMenu(title: "", options: .displayInline, children: [
                undoCommand,
                redoCommand
            ]),
            UIMenu(title: "", options: .displayInline, children: [
                cutCommand,
                copyCommand,
                pasteCommand
            ]),
            UIMenu(title: "", options: .displayInline, children: [selectAllCommand])
        ])
        builder.insertSibling(editMenu, afterMenu: aetherMenu.identifier)
        
        // Options Menu
        let skinMenu: UIMenu = UIMenu(title: "Skins", image: UIImage(systemName: "paintbrush"), children: [
            UIAction(title: "Tron".localized, state: Oovium.skin == .tron ? .on : .off) { (action: UIAction) in
                Oovium.skin = .tron
                UIMenuSystem.main.setNeedsRebuild()
            },
            UIAction(title: "Ivory".localized, state: Oovium.skin == .ivory ? .on : .off) { (action: UIAction) in
                Oovium.skin = .ivory
                UIMenuSystem.main.setNeedsRebuild()
            }
        ])
        
        let selectionMenu: UIMenu = UIMenu(title: "Selection Mode", image: UIImage(systemName: "lasso"), children: [
            UIAction(title: "Lasso".localized, state: Oovium.selectionMode == .lasso ? .on : .off) { (action: UIAction) in
                Oovium.selectionMode = .lasso
                UIMenuSystem.main.setNeedsRebuild()
            },
            UIAction(title: "Rectangle".localized, state: Oovium.selectionMode == .rectangle ? .on : .off) { (action: UIAction) in
                Oovium.selectionMode = .rectangle
                UIMenuSystem.main.setNeedsRebuild()
            }
        ])

        let optionsMenu: UIMenu = UIMenu(title: "Options", children: [skinMenu, selectionMenu])
        builder.insertSibling(optionsMenu, afterMenu: editMenu.identifier)

        // Links Menu
        let linksMenu: UIMenu = UIMenu(title: "Links", children: [
            UIAction(title: "Discord", handler: { (action: UIAction) in
                UIApplication.shared.open(URL(string: "https://discord.gg/BZ8bmhUgVq")!)
            }),
            UIAction(title: "Vimeo", handler: { (action: UIAction) in
                UIApplication.shared.open(URL(string: "https://vimeo.com/aepryus")!)
            }),
            UIAction(title: "Review", handler: { (action: UIAction) in
                UIApplication.shared.open(URL(string: "http://itunes.apple.com/app/oovium/id336573328?mt=8")!)
            }),
            UIAction(title: "Oovium", handler: { (action: UIAction) in
                UIApplication.shared.open(URL(string: "http://aepryus.com/Principia?view=article&articleID=3")!)
            })
        ])
        builder.insertSibling(linksMenu, afterMenu: optionsMenu.identifier)
    }
}
