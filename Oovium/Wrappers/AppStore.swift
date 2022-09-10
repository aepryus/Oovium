//
//  AppStore.swift
//  Oovium
//
//  Created by Joe Charlier on 12/26/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumKit
import StoreKit

class AppStore: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate, SKRequestDelegate {
	static var products: [SKProduct] = []

// Private =========================================================================================
	static func generateReceiptString() -> String? {
		let receiptURL = Bundle.main.appStoreReceiptURL
		let receiptData = try? Data(contentsOf: receiptURL!)
		return receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
	}
	static func receiptValidation(_ success: @escaping ()->(), _ failure: @escaping ()->()) {
		Log.print("receiptValidation ====================================================")
	
		guard let receipt: String = AppStore.generateReceiptString() else { print("generateReceiptString failed");failure(); return }
					
		Pequod.verifyReceipt(receipt: receipt, { (otid: String, expires: Date, expired: Bool, usedTrial: Bool) in
			Log.print("success")
			Pequod.otid = otid
			Pequod.expires = expires
			Pequod.expired = expired
			Pequod.usedTrial = usedTrial
			Pequod.basket.set(key: "otid", value: otid)
			Pequod.basket.set(key: "expires", value: expires.toISOFormattedString())
			Pequod.basket.set(key: "expired", value: expired ? "true" : "false")
			Pequod.basket.set(key: "usedTrial", value: usedTrial ? "true" : "false")
			success()
		}) {
			Log.print("receiptValidation failure")
			failure()
		}
	}
	private func validateReceipt() {
		guard let receipt: String = AppStore.generateReceiptString() else { return }
		
		Pequod.verifyReceipt(receipt: receipt, { (otid: String, expires: Date, expired: Bool, usedTrial: Bool) in
			Log.print("receipt verified")
			
			Pequod.otid = otid
			Pequod.expires = expires
			Pequod.expired = expired
			Pequod.usedTrial = usedTrial
			Pequod.basket.set(key: "otid", value: otid)
			Pequod.basket.set(key: "expires", value: expires.toISOFormattedString())
			Pequod.basket.set(key: "expired", value: expired ? "true" : "false")
			Pequod.basket.set(key: "usedTrial", value: usedTrial ? "true" : "false")

			AppStore.onPurchaseCompleteQueue.async {
				AppStore.completePurchase()
			}
			
			guard Pequod.token == nil else {
				if expired {
//					Launch.shiftToSubscribe()
				} else {
					Launch.shiftToOovium()
				}
				return
			}

			Pequod.loginAccount(otid: otid, user: Pequod.user, email: Pequod.email, {
				Log.print("logged in via otid")
				if expired {
//					Launch.shiftToSubscribe()
				} else if Pequod.user == nil {
					Launch.shiftToSignUp()
				} else {
					Launch.shiftToOovium()
				}
			}) {
				Log.print("failed to log in via otid")
				Launch.shiftToOffline()
			}
		}) {
			Log.print("verifyReceipt failure")
//			Launch.shiftToSubscribe()
		}
	}
	
// SKPaymentTransactionObserver ====================================================================
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			switch transaction.transactionState {
				case .purchasing:	Log.print("purchasing")
				case .deferred:		Log.print("deferred")
				case .failed:
					if let error = transaction.error?.localizedDescription {
						Log.print("failed: [\(error)]")
						DispatchQueue.main.async { Oovium.alert(message: error) {
//							Launch.shiftToSubscribe()
							self.validateReceipt()
						}}
					} else {
						Log.print("failed")
						DispatchQueue.main.async { Oovium.alert(message: "Unknown Error, please try again later.") {
//							Launch.shiftToSubscribe()
							self.validateReceipt()
						} }
					}
					SKPaymentQueue.default().finishTransaction(transaction)
				case .restored:		Log.print("restored")
				case .purchased:
					Log.print("purchased")
					SKPaymentQueue.default().finishTransaction(transaction)
					validateReceipt()
				@unknown default:	Log.print("unknown [\(transaction.transactionState)]")
			}
		}
	}
	
// SKProductsRequstDelegate ========================================================================
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		for product in response.products {
			Log.print("[\(product.productIdentifier)][\(product.localizedTitle)][\(product.localizedDescription)][\(product.priceLocale.currencyCode ?? "")][\(product.priceLocale.currencySymbol ?? "")][\(product.price.doubleValue)]")
		}
		AppStore.products = response.products
		DispatchQueue.main.async { AppStore.onPricesLoaded(response.products) }
	}
	
// SKRequestDelegate ===============================================================================
	func requestDidFinish(_ request: SKRequest) {
		Log.print("AppStore.requestDidFinish:[\(String(describing: type(of: request)))]")
	}
	func request(_ request: SKRequest, didFailWithError error: Error) {
		Log.print("AppStore.request:[\(String(describing: type(of: request)))][\(error.localizedDescription)]")
		Log.print("\(error)")
		if request is SKProductsRequest {}
	}
	
// Static ==========================================================================================
	private static let appStore: AppStore = AppStore()
	private static var onPricesLoaded: ([SKProduct])->() = { (products: [SKProduct]) in }
	private static var onPurchaseComplete: (()->())? = nil
	private static var onPurchaseCompleteQueue: DispatchQueue = DispatchQueue(label: "onPurchaseCompleteQueue")
	
	static var identifier: String {
		return UIDevice.current.identifierForVendor?.uuidString ?? ""
	}
	static func refreshReceipt() {
		let request: SKReceiptRefreshRequest = SKReceiptRefreshRequest()
		request.delegate = AppStore.appStore
		request.start()
	}
	static func requestAppStoreReview() {
//		SKStoreReviewController.requestReview()
	}
	static func canMakePayments() -> Bool {
		return SKPaymentQueue.canMakePayments()
	}
	static func loadPrices(_ complete: @escaping ([SKProduct])->()) {
		onPricesLoaded = complete
		let pis: Set<String> = ["893_1", "893_2", "893_3"]
		let request = SKProductsRequest(productIdentifiers: pis)
		request.delegate = AppStore.appStore
		request.start()
	}
	static func purchase(product: SKProduct) {
		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)
	}
	private static func completePurchase() {
		onPurchaseComplete?()
		onPurchaseComplete = nil
	}
	static func pauseForPurchase(delay: Double,_ complete: @escaping ()->()) {
		onPurchaseComplete = complete
		onPurchaseCompleteQueue.asyncAfter(deadline: .now()+delay) {
			AppStore.completePurchase()
		}
	}
	
	static func start() {
		SKPaymentQueue.default().add(AppStore.appStore)
	}
	static func stop() {
		SKPaymentQueue.default().remove(AppStore.appStore)
	}
}
