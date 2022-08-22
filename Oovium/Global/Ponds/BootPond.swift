//
//  BootPond.swift
//  Oovium
//
//  Created by Joe Charlier on 3/14/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import OoviumKit

class BootPond: Pond {
//	let forceUnsubscribed: Bool = true

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

//	lazy var isLocallySubscribed: Pebble = {
//		pebble(name: "Is Locally Subscribed") { (complete: @escaping (Bool) -> ()) in
//			guard !self.forceUnsubscribed else { complete(false); return }
//			guard let expired = Pequod.expired, let expires = Pequod.expires else { complete(true); return }
//			complete(!expired && Date.now <= expires)
//		}
//	}()
//	lazy var isRemotelySubscribed: Pebble = {
//		pebble(name: "Is Remotely Subscribed") { (complete: @escaping (Bool) -> ()) in
//			guard !self.forceUnsubscribed else { complete(false); return }
//			guard Pequod.ping == true else { complete(true); return }
//
//			Pequod.expired = true
//
//			AppStore.pauseForPurchase(delay: 5) {
//				if let expired = Pequod.expired, !expired {
//					complete(true)
//				} else {
//					AppStore.receiptValidation({
//						complete(!(Pequod.expired ?? false))
//					}) {
//						Pequod.loginAccount(user: Pequod.user, {
//							complete(!(Pequod.expired ?? false))
//						}) {
//							complete(false)
//						}
//					}
//				}
//			}
//		}
//	}()

//	lazy var receiptValidation: Pebble = {
//		pebble(name: "Receipt Validation") { (complete: @escaping (Bool) -> ()) in
//			AppStore.receiptValidation({
//				complete(true)
//			}) {
//				complete(false)
//			}
//		}
//	}()
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
//	lazy var otidLogin: Pebble = {
//		pebble(name: "OTID Login") { (complete: @escaping (Bool) -> ()) in
//			Pequod.loginAccount(otid: Pequod.otid, user: Pequod.user, email: Pequod.email, {
//				if Pequod.user != nil {
//					Launch.shiftToOovium()
//				} else {
//					Launch.shiftToSignUp()
//				}
//				complete(true)
//			}) {
//				Log.print("recovery otid login failed")
//				complete(false)
//			}
//		}
//	}()

//	lazy var showOffline: Pebble = {
//		pebble(name: "Show Offline") { (complete: @escaping (Bool) -> ()) in
//			Launch.shiftToOffline()
//			complete(true)
//		}
//	}()
//	lazy var showSubscribe: Pebble = {
//		pebble(name: "Show Subscribe") { (complete: @escaping (Bool) -> ()) in
//			Launch.shiftToSubscribe()
//			complete(true)
//		}
//	}()
//	lazy var showSignUp: Pebble = {
//		pebble(name: "Show Sign Up") { (complete: @escaping (Bool) -> ()) in
//			Launch.shiftToSignUp()
//			complete(true)
//		}
//	}()
	lazy var queryCloud: Pebble = {
		pebble(name: "Query iCloud") { (complete: @escaping (Bool) -> ()) in
			Space.cloud = CloudSpace(path: "", parent: Space.anchor) {
				complete(true)
			}
		}
	}()
	lazy var startOovium: Pebble = {
		pebble(name: "Start Oovium") { (complete: @escaping (Bool) -> ()) in
			Launch.shiftToOovium()
			complete(true)
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

//		isLocallySubscribed.ready = { self.loadToken.succeeded }
//		isRemotelySubscribed.ready = {
//			self.ping.completed
//			&& self.isLocallySubscribed.failed
//		}

		userLogin.ready = {
			self.ping.succeeded
			&& self.loadToken.failed
			&& self.loadUser.succeeded
		}

//		receiptValidation.ready = {
//			self.ping.succeeded
//			&& self.loadToken.failed
//			&& self.loadOTID.failed
//			&& (self.loadUser.failed || self.userLogin.failed)
//		}

//		otidLogin.ready = {
//			self.ping.succeeded
//			&& self.loadToken.failed
//			&& (self.loadOTID.succeeded || self.receiptValidation.succeeded)
//			&& (self.loadUser.failed || self.userLogin.failed)
//		}

//		showOffline.ready = {
//			self.ping.failed
//			&& self.loadToken.failed
//		}

//		showSubscribe.ready = {
//			self.ping.succeeded
//			&& (self.receiptValidation.failed || self.isRemotelySubscribed.failed)
//		}

//		showSignUp.ready = {
//			self.ping.succeeded
//			&& self.loadToken.succeeded
//			&& self.loadOTID.succeeded
//			&& (self.isLocallySubscribed.succeeded || self.isRemotelySubscribed.succeeded)
//			&& self.loadUser.failed
//		}

        startOovium.ready = {
			(self.needNotMigrate.succeeded || self.migrate.succeeded)
			&& self.queryCloud.succeeded
		}

		invalid.ready = {
			self.loadToken.succeeded
			&& self.loadOTID.failed
		}
	}
}
