//
//  Security.swift
//  Oovium
//
//  Created by Joe Charlier on 4/17/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

// Taken from: http://www.splinter.com.au/2019/06/09/pure-swift-common-crypto-aes-encryption/

import CommonCrypto
import Foundation

class Security {
	static func crypt(operation: Int, algorithm: Int, options: Int, key: Data, initializationVector: Data, dataIn: Data) -> Data? {
		return key.withUnsafeBytes { keyUnsafeRawBufferPointer in
			return dataIn.withUnsafeBytes { dataInUnsafeRawBufferPointer in
				return initializationVector.withUnsafeBytes { ivUnsafeRawBufferPointer in
					let dataOutSize: Int = dataIn.count + kCCBlockSizeAES128*2
					let dataOut = UnsafeMutableRawPointer.allocate(byteCount: dataOutSize, alignment: 1)
					defer { dataOut.deallocate() }
					var dataOutMoved: Int = 0
					let status = CCCrypt(CCOperation(operation), CCAlgorithm(algorithm), CCOptions(options), keyUnsafeRawBufferPointer.baseAddress, key.count, ivUnsafeRawBufferPointer.baseAddress, dataInUnsafeRawBufferPointer.baseAddress, dataIn.count, dataOut, dataOutSize, &dataOutMoved)
					guard status == kCCSuccess else { return nil }
					return Data(bytes: dataOut, count: dataOutMoved)
				}
			}
		}
	}
	static func randomGenerateBytes(count: Int) -> Data? {
		let bytes = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: 1)
		defer { bytes.deallocate() }
		let status = CCRandomGenerateBytes(bytes, count)
		guard status == kCCSuccess else { return nil }
		return Data(bytes: bytes, count: count)
	}
}

extension Data {
    func encryptAES256_CBC_PKCS7_IV(key: Data) -> Data? {
        guard let iv = Security.randomGenerateBytes(count: kCCBlockSizeAES128) else { return nil }
        guard let ciphertext = Security.crypt(operation: kCCEncrypt, algorithm: kCCAlgorithmAES, options: kCCOptionPKCS7Padding, key: key, initializationVector: iv, dataIn: self)
			else { return nil }
        return iv + ciphertext
    }
    func decryptAES256_CBC_PKCS7_IV(key: Data) -> Data? {
        guard count > kCCBlockSizeAES128 else { return nil }
        let iv = prefix(kCCBlockSizeAES128)
        let ciphertext = suffix(from: kCCBlockSizeAES128)
        return Security.crypt(operation: kCCDecrypt, algorithm: kCCAlgorithmAES, options: kCCOptionPKCS7Padding, key: key, initializationVector: iv, dataIn: ciphertext)
    }
}
