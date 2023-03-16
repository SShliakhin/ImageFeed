//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ImagesListPresenter {
	weak var view: IImagesListViewInput?
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
	func didDisplayLastPhoto() {
		view?.startIndicator()
		interactor.fetchPhotos()
	}

	func hasNoAnimatedBy(_ indexPath: IndexPath) -> Bool {
		guard didAnimatePhoto[indexPath] == nil else { return false }
		didAnimatePhoto[indexPath] = true
		return true
	}
	
	func didRefreshContent() {
		photos = photos.shuffled()
		didAnimatePhoto = [:]
	}
	func viewDidLoad() {
		view?.startIndicator()
	}
	func getPhotos() -> [Photo] {
		return photos
	}
	
	func didChangeLikeStatusOf(photo: Photo) {
		if let index = photos.firstIndex(where: { $0.id == photo.id } ) {
			view?.startIndicator()
			interactor.changePhotoLike(photoId: photo.id, isLike: !photos[index].isLiked)
		}
	}
	func didSelectPicture(_ photo: Photo) {
		router.present(.toSingleImage(photo))
	}
}

// MARK: - IImagesListInteractorOutput

extension ImagesListPresenter: IImagesListInteractorOutput {
	func didChangePhotoLikeSuccess(photoId: String, isLike: Bool) {
		view?.stopIndicator()
		if let index = photos.firstIndex(where: { $0.id == photoId } ) {
			photos[index].isLiked = isLike
			view?.updateRowByIndex(index)
		}
	}

	func didChangePhotoLikeFailure(error: APIError) {
		view?.stopIndicator()
		view?.showErrorDialog(with: error.description)
	}

	func didFetchPhotos(_ photos: [Photo]) {
		guard let view = view else { return }

		view.stopIndicator()
		
		let oldCount = self.photos.count
		let newCount = photos.count
		
		let newPhotos = photos[oldCount..<newCount]
		self.photos += newPhotos
		
		guard oldCount > 0 else { return view.reloadTableView() }
		
		if oldCount != newCount {
			let indexPaths = (oldCount..<newCount).map { i in
				IndexPath(row: i, section: 0)
			}
			view.addRowsToTableView(indexPaths: indexPaths)
		}
	}
}
