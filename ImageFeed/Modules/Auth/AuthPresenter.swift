//
//  AuthPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class AuthPresenter: IAuthViewOutput {
	weak var view: (IAuthViewInput & ILoadWithProgressHUD)?
    private let interactor: IAuthInteractorInput
    private let router: IAuthRouter
    private var code: String
        
    init(interactor: IAuthInteractorInput, router: IAuthRouter, code: String) {
        self.interactor = interactor
        self.router = router
        self.code = code
    }
    
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

extension AuthPresenter: IAuthInteractorOutput {
    func didFetchBearerTokenSuccess(_ message: String) {
        print(message)
		view?.stopIndicator()
		router.navigate(.toStart)
    }
    func didFetchBearerTokenFailure(error: APIError) {
        view?.stopIndicator()
		view?.showErrorDialog(with: error.description)
    }
}
