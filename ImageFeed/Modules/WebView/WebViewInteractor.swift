//
//  WebViewInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 20.03.2023.
//

import Foundation

final class WebViewInteractor {
	weak var output: IWebViewInteractorOutput?
	private let apiHelper: IWebViewAPIHelper

	init(dep: IWebViewModuleDependency) {
		self.apiHelper = dep.apiHelper
	}
}

// MARK: - IAuthInteractorInput

extension WebViewInteractor: IWebViewInteractorInput {
	func getAuthCode(from url: URL) -> String? {
		apiHelper.code(from: url)
	}

	func getAuthRequest() -> URLRequest {
		apiHelper.authRequest()
	}
}
