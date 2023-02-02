//
//  AuthPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import Foundation

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
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        print(#function)
        vc.dismiss(animated: true)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
