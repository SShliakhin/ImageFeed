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

extension PictureViewModel {
	init(from model: Picture, callback: (() -> Void)? = nil) {
		image = UIImage(named: model.image)
		dateString = Theme.dateFormatter.string(from: model.date)
		isFavorite = model.isFavorite
		self.callback = callback
	}
}

// MARK: - CellViewModel
extension PictureViewModel: CellViewModel {
	func setup(cell: ImagesListCell) {
		cell.picture = self
	}
}
