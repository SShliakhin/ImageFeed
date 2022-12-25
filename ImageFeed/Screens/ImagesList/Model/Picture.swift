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
    let height: CGFloat
}

// MARK: - MockData
extension Picture {
    static let pictures: [Picture] = {
        (0...20).map { number in
            Picture(
                asset: String(describing: number),
                date: Date(),
                isFavorite: number % 2 == 0,
                height: getHeight(
                    for: UIImage(named: String(describing: number))
                )
            )
        }
    }()
    
    static func getHeight(for image: UIImage?) -> CGFloat {
        guard let image = image else { return 0 }

        let imageSize = image.size
        let aspectRatio = imageSize.height / imageSize.width
        let cellWidth = UIScreen.main.bounds.width - Theme.spacing(usage: .standard2) * 2
        let cellHeight = cellWidth * aspectRatio + Theme.spacing(usage: .standardHalf) * 2
        return cellHeight
    }
}
