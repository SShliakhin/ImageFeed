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
	
	init(interactor: IImagesListInteractorInput, router: IImagesListRouter) {
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - IImagesListViewOutput

extension ImagesListPresenter: IImagesListViewOutput {
	func viewDidLoad() {
		interactor.loadImages()
	}
	func didSelectPicture(_ picture: Picture) {
		router.present(.toSingleImage(picture))
	}
}

// MARK: - IImagesListInteractorOutput

extension ImagesListPresenter: IImagesListInteractorOutput {
	func didloadImages(pictures: [Picture]) {
		view?.showImages(pictures: pictures)
	}
}
