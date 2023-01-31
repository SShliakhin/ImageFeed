//
//  Constants.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 31.01.2023.
//

import Foundation

enum Constant: String {
    case accessKey = "c8SI91LkiH6yY5SDWDKLtjNOYdgPaKAEwmD2dWs35eU"
    case secretKey = "qg_ghS6ZMMDJP1aU1oiC6Bts3KTDKBt03G28yhrTMrM"
    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    case accessScope = "public+read_user+write_likes"
    case defaultBaseURLString = "https://api.unsplash.com"
    case unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

extension String {
    static func key(_ constant: Constant) -> Self { constant.rawValue }
}

extension URL {
    static var defaultBaseURL: Self { .init(string: .key(.defaultBaseURLString))! }
    static var unsplashAuthorizeURL: Self { .init(string: .key(.unsplashAuthorizeURLString))! }
}
