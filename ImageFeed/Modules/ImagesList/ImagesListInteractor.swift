//
//  ImagesListInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ImagesListInteractor {
	weak var output: IImagesListInteractorOutput?
	private let imagesListService: IImagesListService
	private var imagesListServiceObserver: NSObjectProtocol?

	init(dep: IImagesListModuleDependency) {
		self.imagesListService = dep.imagesListPageLoader
		self.imagesListServiceObserver = dep.notificationCenter.addObserver(
			forName: self.imagesListService.didChangeNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self = self else { return }
			self.didFetchNextPageImagesList()
		}

		imagesListService.fetchPhotosNextPage()
	}
}

private extension ImagesListInteractor {
	func didFetchNextPageImagesList() {
		output?.didFetchPhotos(imagesListService.photos)
	}
}

// MARK: - IImagesListInteractorInput

extension ImagesListInteractor: IImagesListInteractorInput {
	func changePhotoLike(photoId: String, isLike: Bool) {
		imagesListService.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let isLike):
				self.output?.didChangePhotoLikeSuccess(photoId: photoId, isLike: isLike)
			case .failure(let error):
				self.output?.didChangePhotoLikeFailure(error: error)
			}
		}
	}

	func fetchPhotos() {
		imagesListService.fetchPhotosNextPage()
	}
}
