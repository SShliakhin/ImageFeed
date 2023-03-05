//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class WebViewPresenter: IWebViewViewOutput {
    weak var view: IWebViewViewInput?
    private let router: IWebViewRouter
    
    init(router: IWebViewRouter) {
        self.router = router
    }
    
	func viewDidload() {
		guard let url = UnsplashAPI.getAuthorizationCodeRequest.url else {
			fatalError("Can't construct url")
		}
		view?.loadRequest(URLRequest(url: url))
	}
    
    func getAuthCode(from url: URL?) -> String? {
        if
            let url = url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }

    func didGetAuthCode(_ code: String) {
        router.navigate(.toAuth(code))
    }
    
    func didTapBack() {
		let emptyCode = ""
		router.navigate(.toAuth(emptyCode))
    }
}
