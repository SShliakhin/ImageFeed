//
//  PictureViewModel.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 22.12.2022.
//

import UIKit

struct PhotoViewModel {
	let image: UIImage?
	let imageURL: URL
	let size: CGSize
	let dateString: String
	let isFavorite: Bool
	var setStatusFavorite: (() -> Void)? = nil
}

extension PhotoViewModel {
	init(from model: Photo, setStatusFavorite: (() -> Void)? = nil) {
		image = UIImage(named: model.id)
		imageURL = model.thumbImageURL
		size = model.size
		dateString = Theme.dateFormatter.string(from: model.createdAt)
		isFavorite = model.isLiked
		self.setStatusFavorite = setStatusFavorite
	}
}

// MARK: - PhotoViewModel

extension PhotoViewModel: CellViewModel {
	func setup(cell: ImagesListCell) {
		cell.picture = self
	}
}
