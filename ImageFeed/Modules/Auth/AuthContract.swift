//
//  AuthContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

// MARK: View Output (View -> Presenter)
protocol IAuthViewOutput: AnyObject {
    func viewDidLoad()
    func didTapLogin()
}

// MARK: View Input (Presenter -> View)
protocol IAuthViewInput: AnyObject {
    func hideLoginButton()
    func showLoginButton()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IAuthInteractorInput: AnyObject {
    func fetchBearerTokenByCode(_ code: String)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IAuthInteractorOutput: AnyObject {
    func didFetchBearerTokenSuccess(_ message: String)
    func didFetchBearerTokenFailure(error: APIError)
}

// MARK: Router Input (Presenter -> Router)
protocol IAuthRouter: MainRouting {
}
