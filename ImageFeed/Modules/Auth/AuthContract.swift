//
//  AuthContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol IAuthViewOutput: AnyObject {
    func didTapLogin()
}

// MARK: View Input (View -> Presenter)
protocol IAuthViewInput: AnyObject {
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
