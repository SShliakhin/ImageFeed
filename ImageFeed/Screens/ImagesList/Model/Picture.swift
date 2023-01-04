//
//  Picture.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 22.12.2022.
//

import Foundation

struct Picture {
    let image: String
    let date: Date
    let isFavorite: Bool
}

// MARK: - MockData
extension Picture {
    static let pictures: [Picture] = {
        (0...20).map { number in
            Picture(
                image: String(describing: number),
                date: Date(),
                isFavorite: number % 2 == 0
            )
        }
    }()
}
