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
	private let imagesListPageLoader: IImagesListService
	private var imagesListServiceObserver: NSObjectProtocol?
	
	init(picturesLoader: PicturesLoading, dep: IImagesListModuleDependency) {
		self.picturesLoader = picturesLoader
		self.imagesListPageLoader = dep.imagesListPageLoader
		self.imagesListServiceObserver = dep.notificationCenter.addObserver(
			forName: self.imagesListPageLoader.didChangeNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self = self else { return }
			self.fetchNextPageImagesList()
		}
		
		imagesListPageLoader.fetchPhotosNextPage()
	}
}

private extension ImagesListInteractor {
	func fetchNextPageImagesList() {
		print("сигнал: Загрузил")
		print(imagesListPageLoader.photos)
	}
}

// MARK: - IImagesListInteractorInput

extension ImagesListInteractor: IImagesListInteractorInput {
	func loadImages() {
		let photos = picturesLoader.loadPictures()
		output?.didloadImages(photos: photos)
	}
}
