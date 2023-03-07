//
//  ProfileContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

// MARK: View Output (View -> Presenter)
protocol IProfileViewOutput: AnyObject {
    func viewDidLoad()
    func didTapLogout()
}

// MARK: View Input (Presenter -> View)
protocol IProfileViewInput: AnyObject {
    func showProfile(profile: ProfileResult)
	func updateAvatarURL(_ profileImageURL: URL)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IProfileInteractorInput: AnyObject {
    func cleanUpStorage()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IProfileInteractorOutput: AnyObject {
    func didCleanUpStorage()
	func didFetchProfileImageURL(_ url: URL)
}

// MARK: Router Input (Presenter -> Router)
protocol IProfileRouter: MainRouting {
}
