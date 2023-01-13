//
//  Profile.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.01.2023.
//

import Foundation

struct Profile {
    let image: String
    let fullName: String
    let loginName: String
    let description: String
}

// MARK: - MockData
extension Profile {
    static let mockProfile = Profile(
        image: "avatar",
        fullName: "Екатерина Новикова",
        loginName: "@ekaterina_nov",
        description: "Hello, world"
    )
}
