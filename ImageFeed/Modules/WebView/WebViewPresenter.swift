//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class WebViewPresenter {
	weak var view: IWebViewViewInput?
	private let interactor: IWebViewInteractorInput
	private let router: IWebViewRouter

	init(interactor: IWebViewInteractorInput, router: IWebViewRouter) {
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - IWebViewViewOutput

extension WebViewPresenter: IWebViewViewOutput {
	func viewDidLoad() {
		let request = interactor.getAuthRequest()
		view?.loadRequest(request)
	}

	func didUpdateProgressValue(_ newValue: Double) {
		if abs(newValue - 1.0) <= 0.0001 {
			view?.setProgressHidden()
		} else {
			view?.setProgressValue(Float(newValue))
		}
	}

	func getAuthCode(from url: URL?) -> String? {
		guard let url = url else {
			fatalError("Can't construct url for code")
		}
		return interactor.getAuthCode(from: url)
	}

	func didGetAuthCode(_ code: String) {
		router.navigate(.toAuth(code))
	}

	func didTapBack() {
		let emptyCode = ""
		router.navigate(.toAuth(emptyCode))
	}
}
