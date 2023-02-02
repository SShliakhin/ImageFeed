//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class WebViewPresenter: IWebViewViewOutput {
    weak var view: IWebViewViewInput?
    weak var moduleOutput: IWebViewModuleOutput?
    
    func getRequest() -> URLRequest {
        guard var urlComponents = URLComponents(string: .key(.unsplashAuthorizeURLString)) else {
            fatalError("Can't construct urlComponent")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: .key(.accessKey)),
            URLQueryItem(name: "redirect_uri", value: .key(.redirectURI)),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: .key(.accessScope))
        ]
        guard let url = urlComponents.url else {
            fatalError("Can't construct url")
        }
        
        return URLRequest(url: url)
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
        guard let view = view as? UIViewController else { return }
        moduleOutput?.webViewModule(view, didAuthenticateWithCode: code)
    }
    
    func didTapBack() {
        guard let view = view as? UIViewController else { return }
        moduleOutput?.webViewModuleDidCancel(view)
    }
}
