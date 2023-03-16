//
//  SingleImagePresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

final class SingleImagePresenter {
	weak var view: ISingleImageViewInput?
	private let interactor: ISingleImageInteractorInput
	private let router: ISingleImageRouter
	private let photo: Photo
	
	init(interactor: ISingleImageInteractorInput, router: ISingleImageRouter, photo: Photo) {
		self.interactor = interactor
		self.router = router
		self.photo = photo
	}
}

// MARK: - ISingleImageViewOutput

extension SingleImagePresenter: ISingleImageViewOutput {
	func viewDidLoad() {
		view?.startIndicator()
		interactor.fetchImageDataBy(url: photo.largeImageURL)
	}
	func didTapBack() {
		guard let vc = view as? UIViewController else { return }
		vc.dismiss(animated: true)
	}
}

// MARK: - ISingleImageInteractorOutput

extension SingleImagePresenter: ISingleImageInteractorOutput {
	func didFetchImageDataSuccess(data: Data) {
		view?.stopIndicator()
		view?.displayPhotoByData(data)
	}

	func didFetchImageDataFailure(error: APIError) {
		view?.stopIndicator()
		view?.showErrorDialog(with: error.description)
	}
}
