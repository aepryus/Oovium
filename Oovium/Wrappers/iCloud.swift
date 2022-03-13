//
//  iCloud.swift
//  Oovium
//
//  Created by Joe Charlier on 4/19/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Foundation

class iCloud {
	static func uploadClassic() {
		if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents/Classic") {
			if !FileManager.default.fileExists(atPath: iCloudURL.path) {
				do {
					try FileManager.default.createDirectory(at: iCloudURL, withIntermediateDirectories: true, attributes: nil)
				} catch {
					print("error creating directory")
				}
			}
			
			if let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
				do {
					let contents = try FileManager.default.contentsOfDirectory(at: localURL, includingPropertiesForKeys: nil, options: []).filter({$0.pathExtension == "xml"})
					try contents.forEach {
						let toURL = iCloudURL.appendingPathComponent($0.lastPathComponent).deletingPathExtension().appendingPathExtension("xml")
						if !FileManager.default.fileExists(atPath: toURL.path) {
							try FileManager.default.copyItem(at: $0, to: toURL)
						}
					}
				} catch {
					print("error:\(error)")
				}
			}

		} else {
			print("iCloud is NOT working!")
		}
	}
//	static func download() {
//		guard	let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents/Classic"),
//				FileManager.default.fileExists(atPath: iCloudURL.path),
//				let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
//			else {return}
//		
//		do {
//			let contents = try FileManager.default.contentsOfDirectory(at: iCloudURL, includingPropertiesForKeys: nil, options: []).filter({$0.pathExtension == "xml"})
//			try contents.forEach {
//				let toURL = localURL.appendingPathComponent($0.lastPathComponent).deletingPathExtension().appendingPathExtension("oo")
//				guard !FileManager.default.fileExists(atPath: toURL.path) else {return}
//				try FileManager.default.copyItem(at: $0, to: toURL)
//			}
//		} catch {
//			print("\(error)")
//		}
//	}
}
