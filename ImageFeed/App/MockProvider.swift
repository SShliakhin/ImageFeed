//
//  MockProvider.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 17.01.2023.
//

import Foundation

enum MockProvider {
    static let pictures: [Picture] = {
        (0...20).map { number in
            Picture(
                image: String(describing: number),
                date: Date(),
                isFavorite: number % 2 == 0
            )
        }
    }()
    
    static let profile = Profile(
        image: "avatar",
        fullName: "Екатерина Новикова",
        loginName: "@ekaterina_nov",
        description: "Hello, world"
    )
}
