//
//  SplashContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.02.2023.
//

import Foundation

// MARK: View Output (View -> Presenter)
protocol ISplashViewOutput: AnyObject {
    func viewDidLoad()
}

// MARK: View Input (Presenter -> View)
protocol ISplashViewInput: AnyObject {
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol ISplashInteractorInput: AnyObject {
	var hasToken: Bool { get }
	func fetchProfile()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol ISplashInteractorOutput: AnyObject {
	func didFetchProfileSuccess(profile: ProfileResult)
	func didFetchProfileFailure(error: APIError)
}

// MARK: Router Input (Presenter -> Router)
protocol ISplashRouter: MainRouting {
}
