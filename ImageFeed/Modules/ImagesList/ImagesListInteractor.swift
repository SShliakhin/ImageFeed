//
//  ImagesListInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ImagesListInteractor {
	weak var output: IImagesListInteractorOutput?
	private let imagesListPageLoader: IImagesListService
	private var imagesListServiceObserver: NSObjectProtocol?
		
	init(dep: IImagesListModuleDependency) {
		self.imagesListPageLoader = dep.imagesListPageLoader
		self.imagesListServiceObserver = dep.notificationCenter.addObserver(
			forName: self.imagesListPageLoader.didChangeNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self = self else { return }
			self.didFetchNextPageImagesList()
		}
		
		imagesListPageLoader.fetchPhotosNextPage()
	}
}

private extension ImagesListInteractor {
	func didFetchNextPageImagesList() {
		output?.didLoadPhotos(imagesListPageLoader.photos)
	}
}

// MARK: - IImagesListInteractorInput

extension ImagesListInteractor: IImagesListInteractorInput {
	func fetchPhotos() {
		imagesListPageLoader.fetchPhotosNextPage()
	}
}
