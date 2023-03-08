//
//  ImagesListInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ImagesListInteractor {
	weak var output: IImagesListInteractorOutput?
	private let picturesLoader: PicturesLoading
	
	init(picturesLoader: PicturesLoading) {
		self.picturesLoader = picturesLoader
	}
}

// MARK: - IImagesListInteractorInput

extension ImagesListInteractor: IImagesListInteractorInput {
	func loadImages() {
		let pictures = picturesLoader.loadPictures()
		output?.didloadImages(pictures: pictures)
	}
}
