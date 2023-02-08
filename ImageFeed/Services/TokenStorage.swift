//
//  TokenStorage.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 07.02.2023.
//

import Foundation

protocol ITokenStorage {
    var token: String? { get set }
}

extension ITokenStorage {
    var bearerTokenKey: String {
        "bearerToken"
    }
}

struct TokenStorage: ITokenStorage {
    let userDefaults: UserDefaults

    var token: String? {
        get {
            userDefaults.string(forKey: bearerTokenKey)
        }

        set {
            userDefaults.set(newValue, forKey: bearerTokenKey)
        }
    }
}
