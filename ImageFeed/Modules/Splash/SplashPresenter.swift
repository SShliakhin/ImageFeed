//
//  SplashPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.02.2023.
//

import Foundation

final class SplashPresenter {
	weak var view: ISplashViewInput?
	private let interactor: ISplashInteractorInput
	private let router: MainRouting
	
	init(interactor: ISplashInteractorInput, router: MainRouting) {
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - ISplashViewOutput

extension SplashPresenter: ISplashViewOutput {
	func viewDidLoad() {
		if interactor.hasToken {
			view?.startIndicator()
			interactor.fetchProfile()
		} else {
			let emptyCode = ""
			router.navigate(.toAuth(emptyCode))
		}
	}
}

// MARK: - ISplashInteractorOutput

extension SplashPresenter: ISplashInteractorOutput {
	func didFetchProfileSuccess(profile: ProfileResult) {
		view?.stopIndicator()
		self.router.navigate(.toMainModule(profile))
	}
	
	func didFetchProfileFailure(error: APIError) {
		view?.stopIndicator()
		view?.showErrorDialog(with: error.description) { [weak self] in
			guard let self = self else { return }
			let emptyCode = ""
			self.router.navigate(.toAuth(emptyCode))
		}
	}
}
