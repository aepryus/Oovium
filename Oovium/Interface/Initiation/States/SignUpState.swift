//
//  SignUpState.swift
//  Oovium
//
//  Created by Joe Charlier on 4/29/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import AuthenticationServices
import Foundation

class SignUpState: LaunchState, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	var signUpButton: ASAuthorizationAppleIDButton = {
		if #available(iOS 13.2, *) {
			return ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .white)
		} else {
			return ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
		}
	}()
	let skipButton: UIButton = UIButton()

	override init() {
		super.init()
		
		signUpButton.addAction {
			let request = ASAuthorizationAppleIDProvider().createRequest()
			request.requestedScopes = [.email]
			
			let controller = ASAuthorizationController(authorizationRequests: [request])
			controller.delegate = self
			controller.presentationContextProvider = self
			controller.performRequests()
		}

		skipButton.backgroundColor = .white
		skipButton.layer.cornerRadius = 8
		let sb: NSMutableAttributedString = NSMutableAttributedString()
		sb.append("Skip".localized, pen: Pen(font: UIFont.systemFont(ofSize: 20.5, weight: .medium), color: .black, alignment: .center, kern: -0.2))
		skipButton.setAttributedTitle(sb, for: .normal)
		skipButton.addAction {
			Launch.shiftToOovium()
		}
	}
	
	static func decode(_ token: String) -> [String:AnyObject]? {
		let string = token.components(separatedBy: ".")
		let toDecode = string[1] as String

		var stringtoDecode: String = toDecode.replacingOccurrences(of: "-", with: "+") // 62nd char of encoding
		stringtoDecode = stringtoDecode.replacingOccurrences(of: "_", with: "/") // 63rd char of encoding
		switch (stringtoDecode.utf16.count % 4) {
			case 2: stringtoDecode = "\(stringtoDecode)=="
			case 3: stringtoDecode = "\(stringtoDecode)="
			default: // nothing to do stringtoDecode can stay the same
				print("")
		}
		let dataToDecode = Data(base64Encoded: stringtoDecode, options: [])
		let base64DecodedString = NSString(data: dataToDecode!, encoding: String.Encoding.utf8.rawValue)

		var values: [String:AnyObject]?
		if let string = base64DecodedString {
			if let data = string.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true) {
				values = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject]
			}
		}
		return values
	}
	
// LaunchState =======================================================================================
	override func onActivate() {
		Oovium.window.makeKeyAndVisible()
		Oovium.window.addSubview(signUpButton)
		Oovium.window.addSubview(skipButton)
		
		let s = Screen.s
		signUpButton.center(dy: -42*s, width: 240*s, height: 48*s)
		skipButton.top(dy: signUpButton.bottom + 36*s, width: 240*s, height: 48*s)
	}
	override func onDeactivate(_ complete: @escaping ()->()) {
		UIView.animate(withDuration: 0.2, animations: {
			self.signUpButton.alpha = 0
			self.skipButton.alpha = 0
		}) { (finished: Bool) in
			self.signUpButton.removeFromSuperview()
			self.skipButton.removeFromSuperview()
			self.signUpButton.alpha = 1
			self.skipButton.alpha = 1
			complete()
		}
	}
	
// ASAuthorizationControllerDelegate ===============================================================
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
		
		let email = credential.email ?? {
			if let data = credential.identityToken, let string = String(data: data, encoding: .utf8), let attributes = SignUpState.decode(string) {
				print(attributes.toJSON())
				return attributes["email"] as! String
			} else {
				return "N/A"
			}
		}()
		
		Pequod.registerAccount(user: credential.user, email: email, {
			Pequod.basket.set(key: "user", value: credential.user)
			Launch.shiftToOovium()
		}) {
			print("registerAccount failure")
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
