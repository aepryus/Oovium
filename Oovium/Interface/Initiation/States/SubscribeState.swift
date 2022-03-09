//
//  SubscribeState.swift
//  Oovium
//
//  Created by Joe Charlier on 4/29/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import AuthenticationServices
import StoreKit
import UIKit

class SubscribeState: LaunchState, UITextViewDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	let nuxView: NUXView = NUXView()
	let titleLabel: UILabel = UILabel()
	let monthlyButton: SubscribeButton = SubscribeButton()
	let yearlyButton: SubscribeButton = SubscribeButton()
	let urlsView: UITextView = UITextView()
	let loginButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)

	static let componentFormatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.maximumUnitCount = 1
		formatter.unitsStyle = .full
		return formatter
	}()
	static func format(_ numberOfUnits: Int, unit: SKProduct.PeriodUnit) -> String {
		let seconds: Int
		if unit == .day { seconds = 86400 }
		else if unit == .week { seconds = 604800 }
		else if unit == .month { seconds = 2678400}
		else /*if unit == .year*/ { seconds = 31536000 }
		return componentFormatter.string(from: TimeInterval(numberOfUnits*seconds)) ?? ""
	}

	override init() {
		super.init()

		let s: CGFloat = Screen.mac ? Screen.height/768 : Screen.s

		if Screen.iPhone {
			titleLabel.text = "Oovium\nSubscription".localized
			titleLabel.pen = Pen(font: UIFont(name: "Verdana-Bold", size: 12*s)!, color: .white)
		} else {
			titleLabel.text = "Oovium\nSubscription".localized
			titleLabel.textAlignment = .center
			titleLabel.pen = Pen(font: UIFont(name: "Verdana-Bold", size: 18*s)!, color: .white)
		}
		titleLabel.numberOfLines = 2

		monthlyButton.backgroundColor = .white
		monthlyButton.layer.cornerRadius = 8
		monthlyButton.addAction {
			Launch.shiftToBlank()
			AppStore.purchase(product: AppStore.products[0])
		}
		
		yearlyButton.backgroundColor = .white
		yearlyButton.layer.cornerRadius = 8
		yearlyButton.addAction {
			Launch.shiftToBlank()
			AppStore.purchase(product: AppStore.products[1])
		}
		
		let sb: NSMutableAttributedString = NSMutableAttributedString()
		let boldPen = Pen(font: UIFont.systemFont(ofSize: Screen.iPhone ? 11*s : 13*s, weight: .bold))
		sb.append("Terms of Use", pen: boldPen)
		sb.append(" and ", pen: Pen(font: UIFont.systemFont(ofSize: Screen.iPhone ? 11*s : 13*s), color: .white))
		sb.append("Privacy Policy", pen: boldPen)
		sb.addAttribute(NSAttributedString.Key.link, value: "terms", range: (sb.string as NSString).range(of: "Terms of Use"))
		sb.addAttribute(NSAttributedString.Key.link, value: "privacy", range: (sb.string as NSString).range(of: "Privacy Policy"))
		urlsView.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
		urlsView.attributedText = sb
		urlsView.backgroundColor = .clear
		urlsView.textAlignment = .center
		urlsView.isEditable = false
		urlsView.delegate = self

		loginButton.addAction {
			let request = ASAuthorizationAppleIDProvider().createRequest()
			request.requestedScopes = [.email]
			
			let controller = ASAuthorizationController(authorizationRequests: [request])
			controller.delegate = self
			controller.presentationContextProvider = self
			controller.performRequests()
		}
	}

// LaunchState =======================================================================================
	override func onActivate() {
		if Screen.mac, #available(iOS 13.0, *) {
			UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { (windowScene: UIWindowScene) in
				let size: CGSize = CGSize(width: 1194/0.77, height: 834/0.77)
				windowScene.sizeRestrictions?.minimumSize = size
				windowScene.sizeRestrictions?.maximumSize = size
			}
		}

		AppStore.loadPrices { (products: [SKProduct]) in
			guard products.count > 1 else {
				Launch.shiftToOovium()
				return
			}
			let mainPen: Pen = Pen(font: UIFont.systemFont(ofSize: Screen.iPhone ? (Pequod.user == nil ? 15 : 18) : (Screen.mac ? 24 : 20.5), weight: .medium), color: .black, alignment: .center, kern: -0.2)
			let subPen: Pen = Pen(font: UIFont.systemFont(ofSize: Screen.iPhone ? (Pequod.user == nil ? 11 : 13) : (Screen.mac ? 18 : 15), weight: .medium), color: .black, alignment: .center, kern: -0.2)

			var sb: NSMutableAttributedString = NSMutableAttributedString()
			sb.append("\(products[0].priceLocale.currencySymbol ?? "")\(products[0].price) / month", pen: mainPen)
			self.monthlyButton.mainText = sb
			if let numberOfPeriods = products[0].introductoryPrice?.numberOfPeriods, let unit = products[0].introductoryPrice?.subscriptionPeriod.unit {
				sb = NSMutableAttributedString()
				sb.append("\(SubscribeState.format(numberOfPeriods , unit: unit)) free trial", pen: subPen)
				self.monthlyButton.subText = sb
			}
			Oovium.window.addSubview(self.monthlyButton)

			sb = NSMutableAttributedString()
			sb.append("\(products[1].priceLocale.currencySymbol ?? "")\(products[1].price) / year", pen: mainPen)
			self.yearlyButton.mainText = sb
			if let numberOfPeriods = products[1].introductoryPrice?.numberOfPeriods, let unit = products[1].introductoryPrice?.subscriptionPeriod.unit {
				sb = NSMutableAttributedString()
				sb.append("\(SubscribeState.format(numberOfPeriods , unit: unit)) free trial", pen: subPen)
				self.yearlyButton.subText = sb
			}
			Oovium.window.addSubview(self.yearlyButton)
			
			if !Screen.iPhone {
				let s: CGFloat = Screen.mac ? Screen.height/768 : Screen.s
				let bw: CGFloat = 200*s
				self.monthlyButton.bottomLeft(dx: self.titleLabel.right+24*s, dy: -24*s, width: bw, height: 48*s)
				self.yearlyButton.bottomLeft(dx: self.monthlyButton.right+24*s, dy: -24*s, width: bw, height: 48*s)
			}
		}
		
//		Hovers.dismissModalIfInvoked()
		
		monthlyButton.alpha = 0
		monthlyButton.removeFromSuperview()
		yearlyButton.alpha = 0
		yearlyButton.removeFromSuperview()
		loginButton.alpha = 0

		Oovium.window.makeKeyAndVisible()
		nuxView.alpha = 1
		Oovium.window.addSubview(nuxView)
		
		Oovium.window.addSubview(titleLabel)
		
		if Pequod.user == nil {
			Oovium.window.addSubview(loginButton)
			Oovium.window.addSubview(urlsView)
		} else {
			loginButton.removeFromSuperview()
			urlsView.removeFromSuperview()
		}
		
		let s: CGFloat = Screen.mac ? Screen.height/768 : Screen.s

		if Screen.iPhone {
			nuxView.top(width: min(Screen.width, Screen.height), height: max(Screen.width, Screen.height))
		} else {
			nuxView.top(width: max(Screen.width, Screen.height), height: min(Screen.width, Screen.height))
		}
		if Screen.iPhone {
			if Pequod.user == nil {
				let bw: CGFloat = 108*s
				titleLabel.bottomLeft(dx: 8*s, dy: -56*s, width: 144*s, height: 40*s)
				monthlyButton.bottomLeft(dx: 8*s, dy: -20*s, width: bw, height: 36*s)
				yearlyButton.bottomLeft(dx: monthlyButton.right+8*s, dy: -20*s, width: bw, height: 36*s)
				loginButton.bottomRight(dx: -8*s, dy: -20*s, width: 120*s, height: 36*s)
				urlsView.bottomRight(dx: -8*s, dy: -60*s, width: 120*s, height: 40*s)
			} else {
				let bw: CGFloat = 150*s
				titleLabel.text = "Oovium Subscription".localized
				titleLabel.bottom(dy: -4*s, width: 144*s, height: 20*s)
				monthlyButton.bottom(dx: -bw/2-4*s, dy: -28*s, width: bw, height: 44*s)
				yearlyButton.bottom(dx: bw/2+4*s, dy: -28*s, width: bw, height: 44*s)
			}
		} else {
			let bw: CGFloat = 200*s
			titleLabel.bottomLeft(dx: 24*s, dy: -24*s, width: 160*s, height: 48*s)
			monthlyButton.bottomLeft(dx: titleLabel.right+24*s, dy: -24*s, width: bw, height: 48*s)
			yearlyButton.bottomLeft(dx: monthlyButton.right+24*s, dy: -24*s, width: bw, height: 48*s)
			loginButton.bottomRight(dx: -24*s, dy: -24*s, width: 200*s, height: 48*s)
			if Pequod.user == nil { urlsView.bottomLeft(dx: yearlyButton.right+(loginButton.left-yearlyButton.right-160*s)/2, dy: -24*s, width: 160*s, height: 48*s) }
			else { urlsView.bottomRight(dx: -24*s, dy: -24*s, width: 160*s, height: 48*s) }
		}

		UIView.animate(withDuration: 0.2, animations: {
			self.titleLabel.alpha = 1
			self.monthlyButton.alpha = 1
			self.yearlyButton.alpha = 1
			self.urlsView.alpha = 1
			self.loginButton.alpha = 1
		}) { (completed: Bool) in
			self.nuxView.pages[0].start()
		}
	}
	override func onDeactivate(_ complete: @escaping ()->()) {
		UIView.animate(withDuration: 0.2, animations: {
			self.nuxView.alpha = 0
			self.titleLabel.alpha = 0
			self.monthlyButton.alpha = 0
			self.yearlyButton.alpha = 0
			self.urlsView.alpha = 0
			self.loginButton.alpha = 0
		}) { (finished: Bool) in
			self.nuxView.removeFromSuperview()
			self.titleLabel.removeFromSuperview()
			self.monthlyButton.removeFromSuperview()
			self.yearlyButton.removeFromSuperview()
			self.urlsView.removeFromSuperview()
			self.loginButton.removeFromSuperview()
			complete()
		}
	}

// UITextViewDelegate ==============================================================================
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
		if "\(URL)" == "terms" {
			Oovium.alert(title: "Terms of Use", message: """
				Oovium is a calculator.  As such the only current restriction on usage is that we request users not to type 55378008 into Oovium and turn it upside down.

				In the future, when Oovium Online comes about there will probably be additional restrictions added, but for now this is all we've got.
			""")
		} else if "\(URL)" == "privacy" {
			Oovium.alert(title: "Privacy Policy", message: """
				Aepryus collects crash reports using the 3rd party service called Fabric, so that it can find and fix crashes as soon as possible. It also stores the user's email address provided by 'Sign in with Apple'.  Other than that Aepryus collects no other information.
				
				In the future, Aepryus may offer an ability to store aethers online, however, these will be encrypted with a client side key so that Aepryus won't be able to access any of the data even if compelled to do so.
			""")
		}
		return true
	}
	
// ASAuthorizationControllerDelegate ===============================================================
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {return}
		
		let email = credential.email ?? {
			if let data = credential.identityToken, let string = String(data: data, encoding: .utf8), let attributes = SignUpState.decode(string) {
				print(attributes.toJSON())
				return attributes["email"] as! String
			} else {
				return "N/A"
			}
		}()
		
		Pequod.loginAccount(user: credential.user, email: email, {
			if Pequod.otid != nil, let expired = Pequod.expired, !expired {
				Launch.shiftToOovium()
			} else {
				self.loginButton.removeFromSuperview()
			}
		}) {
			print("login failed")
		}
	}
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		print("\(error)")
	}
	
// ASAuthorizationControllerPresentationContextProviding ===========================================
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return Oovium.window
	}
}
