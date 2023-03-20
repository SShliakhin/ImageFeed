//
//  PictureViewModel.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 22.12.2022.
//

import UIKit

struct PhotoViewModel {
	let imageURL: URL
	let size: CGSize
	let dateString: String
	let isFavorite: Bool
	var changeFavorite: (() -> Void)?
}

extension PhotoViewModel {
	init(from model: Photo, changeFavorite: (() -> Void)? = nil) {
		imageURL = model.thumbImageURL
		size = model.size
		dateString = model.createdAtString
		isFavorite = model.isLiked
		self.changeFavorite = changeFavorite
	}
}

// MARK: - PhotoViewModel

extension PhotoViewModel: CellViewModel {
	func setup(cell: ImagesListCell) {
		cell.photo = self
	}
}
