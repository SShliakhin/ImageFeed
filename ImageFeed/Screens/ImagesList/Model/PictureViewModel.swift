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
    let isFavorite: Bool
    var callback: (() -> Void)? = nil
}

// MARK: Static methods
extension PictureViewModel {
    static func convert(_ model: Picture) -> PictureViewModel {
        .init(
            image: UIImage(named: model.image),
            dateString: dateFormatter.string(from: model.date),
            isFavorite: model.isFavorite
        )
    }
    
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

// MARK: - CellViewModel
extension PictureViewModel: CellViewModel {
    func setup(cell: ImagesListCell) {
        cell.picture = self
    }
}
