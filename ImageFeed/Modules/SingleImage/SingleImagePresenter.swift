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
	
	init(interactor: ISingleImageInteractorInput, router: ISingleImageRouter) {
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - ISingleImageViewOutput

extension SingleImagePresenter: ISingleImageViewOutput {
	func viewDidLoad() {
		view?.showImage()
	}
	func didTapBack() {
		guard let vc = view as? UIViewController else { return }
		vc.dismiss(animated: true)
	}
}

// MARK: - ISingleImageInteractorOutput

extension SingleImagePresenter: ISingleImageInteractorOutput {}
