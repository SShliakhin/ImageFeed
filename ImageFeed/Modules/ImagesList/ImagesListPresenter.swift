//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ImagesListPresenter {
	weak var view: (IImagesListViewInput & ILoadWithProgressHUD)?
	private let interactor: IImagesListInteractorInput
	private let router: IImagesListRouter
	
	private var photos: [Photo] = []
	private var didAnimatePhoto: [IndexPath: Bool] = [:]
	
	init(interactor: IImagesListInteractorInput, router: IImagesListRouter) {
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - IImagesListViewOutput

extension ImagesListPresenter: IImagesListViewOutput {
	func hasNoAnimatedBy(_ indexPath: IndexPath) -> Bool {
		guard didAnimatePhoto[indexPath] == nil else { return false }
		didAnimatePhoto[indexPath] = true
		return true
	}
	
	func didRefreshContent() {
		photos = photos.shuffled()
		didAnimatePhoto = [:]
	}
	
	func didChangeLikeStatusOf(photo: Photo) {
		// TODO: - изменить статус лайка
		print(#function, "изменить статус лайка")
	}
	
	func viewDidLoad() {
		view?.startIndicator()
		interactor.loadImages()
	}
	func getPhotos() -> [Photo] {
		return photos
	}
	func didSelectPicture(_ photo: Photo) {
		router.present(.toSingleImage(photo))
	}
}

// MARK: - IImagesListInteractorOutput

extension ImagesListPresenter: IImagesListInteractorOutput {
	func didloadImages(photos: [Photo]) {
		self.photos = photos
		view?.stopIndicator()
	}
}
