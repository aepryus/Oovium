//
//  BootPond.swift
//  Oovium
//
//  Created by Joe Charlier on 3/14/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import OoviumKit
import UIKit

class BootPond: Pond {

	lazy var needNotMigrate: Pebble = {
		pebble(name: "Need Not Migrate") { (complete: @escaping (Bool) -> ()) in
			if let oldVersion = Pequod.basket.get(key: "version") {
				if oldVersion != Oovium.version {
					Log.print("Old: [\(oldVersion)], New: [\(Oovium.version)]")
					complete(false)
				} else {
					Log.print("Version [\(Oovium.version)] Not Changed")
					complete(true)
				}
			} else {
				Log.print("New Install")
				Pequod.basket.set(key: "version", value: Oovium.version)
				complete(true)
			}
		}
	}()

	lazy var migrate: Pebble = {
		pebble(name: "Migrate") { (complete: @escaping (Bool) -> ()) in
            var needsMigration: Bool = false
            needsMigration = Pequod.get(key: "version") == nil
            if needsMigration {
                print("Migrating to 2.0.2")
                Local.wipeSplashBoard()
                Local.archiveXML()
                Local.migrateXML()
            }
            
            needsMigration = Pequod.get(key: "version") == "2.0.2"
            if needsMigration {
                print("Migrating to 3.0")
                Local.moveAetherFor30()
                Pequod.unset(key: "aetherURL")
            }

            Pequod.basket.set(key: "version", value: Oovium.version)
            
			complete(true)
		}
	}()

	lazy var ping: Pebble = {
		pebble(name: "Ping") { (complete: @escaping (Bool) -> ()) in
			Pequod.ping({
				complete(true)
			}) {
				complete(false)
			}
		}
	}()

	lazy var loadOTID: Pebble = {
		pebble(name: "Load OTID") { (complete: @escaping (Bool) -> ()) in
			complete(Pequod.loadOTID() && Pequod.loadExpired())
		}
	}()
	lazy var loadUser: Pebble = {
		pebble(name: "Load User") { (complete: (Bool) -> ()) in
			complete(Pequod.loadUser())
		}
	}()
	lazy var loadToken: Pebble = {
		pebble(name: "Load Token") { (complete: (Bool) -> ()) in
			complete(Pequod.loadToken())
		}
	}()

	lazy var userLogin: Pebble = {
		pebble(name: "User Login") { (complete: @escaping (Bool) -> ()) in
			Pequod.loginAccount(user: Pequod.user, {
                complete(true)
			}) {
				Log.print("recovery user login failed")
				complete(false)
			}
		}
	}()
	lazy var queryCloud: Pebble = {
		pebble(name: "Query iCloud") { (complete: @escaping (Bool) -> ()) in
            guard CloudSpace.checkAvailability() else { complete(false); return }
            Space.cloud = CloudSpace({ complete(true) })
		}
	}()
    
    lazy var loadSettings: Pebble = {
        pebble(name: "loadSettings") { (complete: @escaping (Bool) -> ()) in
            if let iden: String = Loom.get(key: "settingsIden"),
               let settings: Settings = Loom.selectBy(iden: iden) {
                Oovium.settings = settings
            } else {
                Loom.transact { Oovium.settings = Loom.create() }
                Loom.set(key: "settingsIden", value: Oovium.settings.iden)
            }
            Skin.skin = Oovium.settings.skin.skin
            UIMenuSystem.main.setNeedsRebuild()
            complete(true)
        }
    }()
	lazy var startOovium: Pebble = {
		pebble(name: "Start Oovium") { (complete: @escaping (Bool) -> ()) in
			Launch.shiftToOovium()
			complete(true)
		}
	}()
    lazy var loadAether: Pebble = {
        pebble(name: "Load Aether") { (complete: @escaping (Bool) -> ()) in
            guard let aetherURL: String = Pequod.get(key: "aetherURL"),
                  let facade: AetherFacade = Facade.create(ooviumKey: aetherURL) as? AetherFacade
            else { complete(false); return }
            
            do {
                try facade.load { (json: String?) in
                    guard let json else { complete(false); return }
                    //                print("====================================================================")
                    //                print(json)
                    //                print("====================================================================")
                    let aether: Aether = Aether(json: json)
                    Oovium.aetherView.swapToAether(facade: facade, aether: aether)
                    complete(true)
                }
            } catch { complete(false) }
        }
    }()
    lazy var initializeAether: Pebble = {
        pebble(name: "Initialize Aether") { (complete: @escaping (Bool) -> ()) in
            let facade: AetherFacade = Facade.create(ooviumKey: "Local::aether01") as! AetherFacade
            
            let createAndStore = {
                let aether: Aether = Aether()
                aether.name = "aether01"
                facade.store(aether: aether) { (success: Bool) in
                    guard success else { complete(false); return }
                    Oovium.aetherView.swapToAether(facade: facade, aether: aether)
                    complete(true)
                }
            }
            do {
                try facade.load { (json: String?) in
                    if let json {
                        let aether: Aether = Aether(json: json)
                        Oovium.aetherView.swapToAether(facade: facade, aether: aether)
                        complete(true)
                    } else {
                        createAndStore()
                    }
                }
            } catch {
                print("initializeAether Local::aether01 failed to open [\(error)]")
                createAndStore()
            }
        }
    }()

	lazy var invalid: Pebble = {
		pebble(name: "Invalid") { (complete: @escaping (Bool) -> ()) in
			complete(true)
		}
	}()

// Init ============================================================================================
	override init() {
		super.init()

		loadOTID.ready = { true }
		loadToken.ready = { true }
		loadUser.ready = { true }
		needNotMigrate.ready = { true }
		ping.ready = { true }
        loadSettings.ready = { true }
		queryCloud.ready = { true }

		migrate.ready = { self.needNotMigrate.failed }

		userLogin.ready = {
			self.ping.succeeded
			&& self.loadToken.failed
			&& self.loadUser.succeeded
		}

        startOovium.ready = { self.loadSettings.succeeded }
        
        loadAether.ready = {
            (self.needNotMigrate.succeeded || self.migrate.succeeded)
            && self.queryCloud.completed
            && self.startOovium.succeeded
        }
        initializeAether.ready =  { self.loadAether.failed }

		invalid.ready = {
			self.loadToken.succeeded
			&& self.loadOTID.failed
		}
	}
}
