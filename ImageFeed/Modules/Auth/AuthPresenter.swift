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
        print(#function)
        vc.dismiss(animated: true)
    }
    
    func webViewModuleDidCancel(_ vc: UIViewController) {
        vc.dismiss(animated: true)
    }
}
