//
//  AuthPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class AuthPresenter: IAuthViewOutput {
    weak var view: IAuthViewInput?
    private let router: IAuthRouter
    
    init(router: IAuthRouter) {
        self.router = router
    }

    func didTapLogin() {
        router.navigate(.toWebView(self))
    }
}

extension AuthPresenter: IWebViewModuleOutput {
    func webViewModule(_ vc: UIViewController, didAuthenticateWithCode code: String) {
        let network = APIClient(session: .shared)
        
        let resourse = UnsplashAPI.getAuthTokenRequest(code)
        let request = PostRequest(endpoint: resourse.url, body: "")
        
        network.send(request){ (result: Result<OAuthTokenResponseBody, APIError>) in
            switch result {
            case .success(let body): print("Token: ===========", body.accessToken)
            case .failure(let error): print(error.localizedDescription)
            }
        }
        vc.dismiss(animated: true)
    }
    
    func webViewModuleDidCancel(_ vc: UIViewController) {
        vc.dismiss(animated: true)
    }
}
