//
//  PictureViewModel.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 22.12.2022.
//

import UIKit

struct PictureViewModel {
    let image: UIImage?
    let dateString: String
    var isFavorite: Bool
    let height: CGFloat
}

// MARK: MockData
extension PictureViewModel {
    static let pictureViewModels: [PictureViewModel] = {
        let pictures = Picture.pictures
        return pictures.map { item in
                .init(
                    image: UIImage(named: item.image),
                    dateString: dateFormatter.string(from: item.date),
                    isFavorite: item.isFavorite,
                    height: getCellHeight(by: UIImage(named: item.image))
                )
        }
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    static func getCellHeight(by image: UIImage?) -> CGFloat {
        guard let image = image else { return 0 }
        
        let imageSize = image.size
        let aspectRatio = imageSize.height / imageSize.width
        let cellWidth = UIScreen.main.bounds.width - Theme.spacing(usage: .standard2) * 2
        let cellHeight = cellWidth * aspectRatio + Theme.spacing(usage: .standardHalf) * 2
        return cellHeight
    }
}
