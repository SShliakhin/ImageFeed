//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 06.03.2023.
//

import Foundation
import SwiftKeychainWrapper

struct OAuth2TokenStorage: ITokenStorage {
	let keychainWrapper: KeychainWrapper
	
	var token: String? {
		get {
			keychainWrapper.string(forKey: bearerTokenKey)
		}
		set {
			guard let newValue = newValue else {
				keychainWrapper.removeObject(forKey: bearerTokenKey)
				return
			}
			keychainWrapper.set(newValue, forKey: bearerTokenKey)
		}
	}
	
	func removeToken() {
		keychainWrapper.removeObject(forKey: bearerTokenKey)
	}
}
