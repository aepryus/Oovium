//
//  Shell.swift
//  Oovium
//
//  Created by Joe Charlier on 4/17/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import OoviumEngine

class Shell: Anchor {
	@objc dynamic var name: String = ""
	@objc dynamic var key: String? = nil
	@objc dynamic var encrypted: String = ""
		
	private var encryptionKey: Data? {
		guard let key = key else {return nil}
		switch key {
			default:
				return key.data(using: .utf8)!
		}
	}
	
	func insert(aether: Aether) {
		name = aether.name
		if let encryptionKey = encryptionKey {
			let input: Data = aether.unload().toJSON().data(using: .utf8)!
			let output: Data = input.encryptAES256_CBC_PKCS7_IV(key: encryptionKey)!
			encrypted = String(data: output, encoding: .utf8)!
		} else {
			encrypted = aether.unload().toJSON()
		}
	}
	func extract() -> Aether {
		let json: String
		if let encryptionKey = encryptionKey {
			let input: Data = encrypted.data(using: .utf8)!
			let output: Data = input.decryptAES256_CBC_PKCS7_IV(key: encryptionKey)!
			json = String(data: output, encoding: .utf8)!
		} else {
			json = encrypted
		}
		return Aether(json: json)
	}
	func extract(into aether: Aether) {
		let json: String
		if let encryptionKey = encryptionKey {
			let input: Data = encrypted.data(using: .utf8)!
			let output: Data = input.decryptAES256_CBC_PKCS7_IV(key: encryptionKey)!
			json = String(data: output, encoding: .utf8)!
		} else {
			json = encrypted
		}
		aether.load(attributes: json.toAttributes())
	}

// Domain ==========================================================================================
	override var properties: [String] {
		return super.properties + ["name", "key", "encrypted"]
	}
}
