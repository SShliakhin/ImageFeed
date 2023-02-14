//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import Foundation

struct OAuthTokenResponseBody: Model {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Date
}
