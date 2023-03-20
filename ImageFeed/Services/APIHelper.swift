//
//  APIHelper.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 20.03.2023.
//

import Foundation
import SwiftUI

protocol IWebViewAPIHelper {
	func authRequest() -> URLRequest
	func code(from url: URL) -> String?
}

struct APIHelper {
	typealias APIConfiguration = UnsplashAPI
}

extension APIHelper: IWebViewAPIHelper {
	func authRequest() -> URLRequest {
		guard let url = APIConfiguration.getAuthorizationCodeRequest.url else {
			fatalError("Can't construct url for auth request")
		}
		return URLRequest(url: url)
	}

	func code(from url: URL) -> String? {
		if let urlComponents = URLComponents(string: url.absoluteString),
			urlComponents.path == "/oauth/authorize/native",
			let items = urlComponents.queryItems,
			let codeItem = items.first(where: { $0.name == "code" }) {
			return codeItem.value
		} else {
			return nil
		}
	}
}
