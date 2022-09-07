//
//  BootPond.swift
//  Oovium
//
//  Created by Joe Charlier on 3/14/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import OoviumEngine
import OoviumKit

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
			if Pequod.basket.get(key: "version") == nil {
				Local.wipeSplashBoard()
				Local.archiveXML()
				Local.migrateXML()
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

				if Pequod.token != nil {
					if let expired = Pequod.expired, !expired {
						Launch.shiftToOovium()
					} else {
						Launch.shiftToSubscribe()
					}
					complete(true)
				} else if Pequod.otid == nil {
					Launch.shiftToSubscribe()
					complete(false)
				} else {
					complete(false)
				}
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
	lazy var startOovium: Pebble = {
		pebble(name: "Start Oovium") { (complete: @escaping (Bool) -> ()) in
			Launch.shiftToOovium()
			complete(true)
		}
	}()
    lazy var loadAether: Pebble = {
        pebble(name: "Load Aether") { (complete: @escaping (Bool) -> ()) in
            guard let aetherURL: String = Pequod.get(key: "aetherURL") else { complete(false); return }
            let facade: Facade = Facade.create(url: URL(fileURLWithPath: aetherURL))
            Space.digest(facade: facade) { (aether: Aether?) in
                guard let aether: Aether = aether else { return }
                Oovium.aetherView.swapToAether(facade: facade, aether: aether)
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
		queryCloud.ready = { true }

		migrate.ready = { self.needNotMigrate.failed }

		userLogin.ready = {
			self.ping.succeeded
			&& self.loadToken.failed
			&& self.loadUser.succeeded
		}

        startOovium.ready = {
			(self.needNotMigrate.succeeded || self.migrate.succeeded)
			&& self.queryCloud.succeeded
		}
        
        loadAether.ready = { self.startOovium.succeeded }

		invalid.ready = {
			self.loadToken.succeeded
			&& self.loadOTID.failed
		}
	}
}
