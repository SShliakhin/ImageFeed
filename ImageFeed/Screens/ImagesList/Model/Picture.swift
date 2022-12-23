//
//  Picture.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 22.12.2022.
//

import UIKit

struct Picture {
    let asset: String
    let date: Date
    let isFavorite: Bool
    var height: CGFloat
}

// MARK: - MockData
extension Picture {
    static let pictures: [Picture] = {
        (0...20).map { number in
            Picture(
                asset: String(describing: number),
                date: Date(),
                isFavorite: number % 2 == 0,
                height: 0
            )
        }
    }()
}
