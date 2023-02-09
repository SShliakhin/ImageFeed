//
//  AuthPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class AuthPresenter: IAuthViewOutput {
    weak var view: IAuthViewInput?
    private let interactor: IAuthInteractorInput
    private let router: IAuthRouter
    
    private weak var externalVC: UIViewController?
    
    init(interactor: IAuthInteractorInput, router: IAuthRouter) {
        self.interactor = interactor
        self.router = router
    }

    func didTapLogin() {
        router.navigate(.toWebView(self))
    }
}

extension AuthPresenter: IWebViewModuleOutput {
    func webViewModule(_ vc: UIViewController, didAuthenticateWithCode code: String) {
        externalVC = vc
        interactor.fetchBearerTokenByCode(code)
    }
    
    func webViewModuleDidCancel(_ vc: UIViewController) {
        router.dismissExternalVC(vc)
    }
}

extension AuthPresenter: IAuthInteractorOutput {
    func didFetchBearerTokenSuccess(_ message: String) {
        print(message)
        router.dismissExternalVC(externalVC)
    }
    func didFetchBearerTokenFailure(error: APIError) {
        print(error.description)
        router.dismissExternalVC(externalVC)
    }
}
