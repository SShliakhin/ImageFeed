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
    func showProfile(profile: ProfileViewModel)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IProfileInteractorInput: AnyObject {
    func obtainProfile()
    func cleanUpStorage()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IProfileInteractorOutput: AnyObject {
    func didObtainProfile(profile: Profile)
    func didCleanUpStorage()
}

// MARK: Router Input (Presenter -> Router)
protocol IProfileRouter: MainRouting {
}
