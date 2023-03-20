//
//  AuthPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class AuthPresenter {
	weak var view: IAuthViewInput?
	private let interactor: IAuthInteractorInput
	private let router: IAuthRouter
	private var code: String

	init(interactor: IAuthInteractorInput, router: IAuthRouter, code: String) {
		self.interactor = interactor
		self.router = router
		self.code = code
	}
}

// MARK: - IAuthViewOutput

extension AuthPresenter: IAuthViewOutput {
	func viewDidLoad() {
		guard code.isEmpty == false else {
			return
		}
		view?.startIndicator()
		interactor.fetchBearerTokenByCode(code)
	}
	func didTapLogin() {
		router.navigate(.toWebView)
	}
}

// MARK: - IAuthInteractorOutput

extension AuthPresenter: IAuthInteractorOutput {
	func didFetchBearerTokenSuccess() {
		view?.stopIndicator()
		router.navigate(.toStart)
	}
	func didFetchBearerTokenFailure(error: APIError) {
		view?.stopIndicator()
		view?.showErrorDialog(with: error.description)
	}
}
