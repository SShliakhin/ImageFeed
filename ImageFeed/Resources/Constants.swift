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
}

extension String {
    static func key(_ constant: Constant) -> Self { constant.rawValue }
}
