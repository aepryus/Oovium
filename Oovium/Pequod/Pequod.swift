//
//  Pequod.swift
//  Oovium
//
//  Created by Joe Charlier on 4/12/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

public class Pequod {
	static let url: String = "https://aepry.us/pequod"
	public static let basket: Basket = Basket(SQLitePersist("pequod"))
	static var ping: Bool? = nil
	static var token: String? = nil
	static var user: String? = nil
	static var email: String? = nil
	static var otid: String? = nil
	static var expires: Date? = nil
	static var expired: Bool? = nil
	static var usedTrial: Bool? = nil

// Utility =========================================================================================
	static func set(key: String, value: String) {
		Pequod.basket.set(key: key, value: value)
	}
	static func get(key: String) -> String? {
		return Pequod.basket.get(key: key)
	}
	static func unset(key: String) {
		Pequod.basket.unset(key: key)
	}

	static func loadToken() -> Bool {
		Pequod.token = basket.get(key: "token")
		return Pequod.token != nil
	}
	static func loadUser() -> Bool {
		Pequod.user = basket.get(key: "user")
		Pequod.email = basket.get(key: "email")
		return Pequod.user != nil
	}
	static func loadOTID() -> Bool {
		Pequod.otid = basket.get(key: "otid")
		return Pequod.otid != nil
	}
	static func loadExpired() -> Bool {
		if let string = basket.get(key: "expires") {
			Pequod.expires = Date.fromISOFormatted(string: string)
		}
		if let string = basket.get(key: "expired") {
			Pequod.expired = string == "true"
		}
		if let string = basket.get(key: "usedTrial") {
			Pequod.usedTrial = string == "true"
		}
		return Pequod.expired != nil
	}
	
	static func logout() {
		Pequod.logoutAccount({
			print("logout successful")
			basket.wipe()
		}) {
			print("logout failed")
		}
	}
	
// Loom ============================================================================================
	static func aetherSelectBy(iden: String) -> Aether? {
		let shell: Shell? = basket.selectBy(iden: iden) as? Shell
		return shell?.extract()
	}
	static func aetherSelectBy(only: String) -> Aether? {
		let shell: Shell? = basket.selectBy(cls: Shell.self, only: only) as! Shell?
		return shell?.extract()
	}
	static func aetherSelectBy(only: String, into aether: Aether) {
		let shell: Shell? = basket.selectBy(cls: Shell.self, only: only) as! Shell?
		shell?.extract(into: aether)
	}
	static func aetherSelectAll() -> [Aether] {
		let shells: [Shell] = basket.selectAll(Shell.self) as! [Shell]
		return shells.map({$0.extract()})
	}
	static func aetherStore(_ aether: Aether) {
		basket.transact {
			let shell: Shell = basket.selectBy(cls: Shell.self, only: aether.name) as! Shell? ?? basket.createBy(cls: Shell.self, only: aether.name) as! Shell
			shell.insert(aether: aether)
		}
	}
	static func aetherRemove(name: String) {
		basket.transact {
			let shell: Shell? = basket.selectBy(cls: Shell.self, only: name) as! Shell?
			shell?.delete()
		}
	}
	
// Laguna ==========================================================================================
	private static var hold: [[String:Any]]?

	public static func synchronize(_ complete:@escaping ()->()) {
		let application = UIApplication.shared
		var sb: String = "[synchronize]"
		defer {print(sb)}
		
		var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
		
		bgTask = application.beginBackgroundTask {
			application.endBackgroundTask(UIBackgroundTaskIdentifier(rawValue: bgTask.rawValue))
			bgTask = UIBackgroundTaskIdentifier.invalid
			print("Background task expired")
		};
		
		let url = URL(string: "\(Pequod.url)/synchronize")!
		var request = URLRequest(url:url)
		request.httpMethod = "POST"
		
		var packet = Pequod.basket.syncPacket()
		packet["token"] = Pequod.token
		packet["fork"] = Pequod.basket.fork
		request.httpBody = packet.toJSON().data(using: .utf8)
		
//		print(packet.toJSON())
		
		let documentCount = (packet["documents"] as! [[String:Any]]).count
		sb += " sending: \(documentCount)"
		
		let task = URLSession.shared.dataTask(with: request) {data, response, error in
			var sb: String = "[synchronize]"
			defer {print(sb)}
			
			guard let data = data, error == nil else {
				print ("\(error!)")
				return
			}
			
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				print("response = \(httpStatus)")
			}
			
			let echo = String(data:data, encoding: .utf8)!.toAttributes()

			guard let echoed = echo["documents"] as? [[String:Any]], echoed.count != 0 else {
				sb += ", echoed: 0"
				application.endBackgroundTask(UIBackgroundTaskIdentifier(rawValue: bgTask.rawValue))
				complete()
				return
			}

			sb += " echoed: \(echoed.count)"
			
			if documentCount > 0 {
				let fork: Int = echo["fork"] as! Int
				sb += ", fork \(fork) queued"
				hold = echoed
				commit(task: bgTask, complete)
			} else {
				Pequod.basket.transact {
					for attributes in echoed {
						var anchor = Pequod.basket.selectBy(iden: attributes["iden"] as! String)
						if let anchor = anchor {
							anchor.dirtyUsingAttributes(attributes)
						} else {
							anchor = Pequod.basket.inject(attributes)
						}
					}
				}
				complete()
			}
		}
		task.resume()
		
	}
	public static func synchronize() {
		synchronize {}
	}
	private static func commit (task: UIBackgroundTaskIdentifier,_ complete:@escaping ()->()) {
		let application = UIApplication.shared
		let url = URL(string: "\(Pequod.url)/commit")!
		var request = URLRequest(url:url)
		request.httpMethod = "POST"
		
		var packet = [String:Any]()
		packet["token"] = Pequod.token
		request.httpBody = packet.toJSON().data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request) {data, response, error in
			var sb: String = "[commit]"
			var sb2: String? = nil
			defer {
				print(sb)
				if let p = sb2 {print(p)}
			}

			guard error == nil else {
				sb2 = "\(error!)"
				return
			}
			
			guard let hold = hold, let data = data else {
				sb += " hold empty"
				return
			}
			
			let echo = String(data:data, encoding: .utf8)!.toAttributes()
			let fork: Int = echo["fork"] as! Int
			Pequod.basket.set(key: "fork", value: "\(fork)")
			Pequod.basket.fork = fork
			
			Pequod.basket.transact {
				for attributes in hold {
					var anchor = Pequod.basket.selectBy(iden: attributes["iden"] as! String)
					if let anchor = anchor {
						anchor.dirtyUsingAttributes(attributes)
					} else {
						anchor = Pequod.basket.inject(attributes)
					}
				}
			}
			sb += " fork \(Pequod.basket.fork) committed"
			
			application.endBackgroundTask(task)
			
			complete()
		}
		task.resume()
	}
	
// Private =========================================================================================
	static func request(path: String, method: String, params: [String:String]? = nil, _ success: @escaping ([String:Any])->(), _ failure: @escaping ()->()) {
		let url: URL = URL(string: "\(Pequod.url)\(path)")!
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = method
		
		if let params = params {
			request.httpBody = params.toJSON().data(using: .utf8)
		}
		
		let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
			guard error == nil else {
				print("error: \(error!)")
				failure();return
			}

			guard let data = data else { failure();return }
			
			if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
				print("\n[ \(path) : \(response.statusCode) ] ===================================================")
				if let headers = request.allHTTPHeaderFields { print("headers ========================\n\(headers.toJSON())\n") }
				if let params = params { print("params =========================\n\(params.toJSON())\n") }
				if let message = String(data: data, encoding: .utf8) { print("message =========================\n\(message)\n") }
				failure();return
			}
		
			if let result = String(data: data, encoding: .utf8) {
				success(result.toAttributes())
			} else {
				failure()
			}
		}
		task.resume()
	}

// Public ==========================================================================================
	static func ping(_ success: @escaping ()->(), _ failure: @escaping ()->()) {
		request(path: "/ping", method: "GET", { (attributes: [String:Any]) in
			Pequod.ping = true
			success()
		}) {
			Pequod.ping = false
			failure()
		}
	}
	static func registerAccount(user: String, email: String, _ success: @escaping ()->(), _ failure: @escaping ()->()) {
		request(path: "/registerAccount", method: "POST", params: ["token":Pequod.token!, "user":user, "email":email], { (attributes: [String:Any]) in
			print(attributes.toJSON())
			success()
		}) {failure()}
	}
	static func loginAccount(otid: String? = nil, user: String? = nil, email: String? = nil, _ success: @escaping ()->(), _ failure: @escaping ()->()) {
		var params: [String:String] = ["tag":Oovium.deviceDescription]
		
		print("loginAccount ===========================")

		// The following stores the values in case the login fails, so that it can be attempted on startup later or so user can be passed along on otid login
		if let otid = otid {
			params["otid"] = otid
			Pequod.otid = otid
			basket.set(key: "otid", value: otid)
		}
		if let user = user {
			params["user"] = user
			Pequod.user = user
			basket.set(key: "user", value: user)
		}
		if let email = email {
			params["email"] = email
			Pequod.email = email
			basket.set(key: "email", value: email)
		}
		
		request(path: "/loginAccount", method: "POST", params: params, { (attributes: [String:Any]) in

			if let token = attributes["token"] as? String, let otid = attributes["otid"] as? String, let expiresString = attributes["expires"] as? String, let expired: Bool = attributes["expired"] as? Bool {
				Pequod.token = token
				basket.set(key: "token", value: token)
				Pequod.otid = otid
				basket.set(key: "otid", value: otid)
				let expires: Date = Date.fromISOFormatted(string: expiresString)!
				Pequod.expires = expires
				Pequod.expired = expired
				Pequod.basket.set(key: "otid", value: otid)

				Pequod.basket.set(key: "expires", value: expires.toISOFormattedString())
				Pequod.basket.set(key: "expired", value: expired ? "true" : "false")

				if let user: String = attributes["user"] as? String {
					Pequod.user = user
					basket.set(key: "user", value: user)
				}
				Pequod.synchronize()
				DispatchQueue.main.async { success() }
			} else {
				DispatchQueue.main.async { success() }
			}
		}) {
			DispatchQueue.main.async { failure() }
		}
	}
	static func logoutAccount(_ success: @escaping ()->(), _ failure: @escaping ()->()) {
		request(path: "/logoutAccount", method: "POST", params: ["token":Pequod.token!], { (attributes: [String:Any]) in
			print(attributes.toJSON())
			DispatchQueue.main.async { success() }
		}) {failure()}
	}
	static func verifyReceipt(receipt: String,  _ success: @escaping (String, Date, Bool, Bool)->(), _ failure: @escaping ()->()) {
		request(path: "/verifyReceipt", method: "POST", params: ["receipt":receipt], { (attributes: [String:Any]) in
			
			print(attributes.toJSON())
			
			if	let otid = attributes["otid"] as? String,
				let expiresString = attributes["expires"] as? String,
				let expired: Bool = attributes["expired"] as? Bool,
				let usedTrial: Bool = attributes["usedTrial"] as? Bool {
				
				let expires: Date = Date.fromISOFormatted(string: expiresString)!
				DispatchQueue.main.async { success(otid, expires, expired, usedTrial) }
				
			} else {
				DispatchQueue.main.async { failure() }
			}
		}) {failure()}
	}
}
