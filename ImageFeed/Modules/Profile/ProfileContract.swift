//
//  ProfileContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol IProfileViewOutput: AnyObject {
    func viewDidLoad()
}

// MARK: View Input (View -> Presenter)
protocol IProfileViewInput: AnyObject {
    func showProfile(profile: ProfileViewModel)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IProfileInteractorInput: AnyObject {
    func obtainProfile()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IProfileInteractorOutput: AnyObject {
    func didObtainProfile(profile: Profile)
}

// MARK: Router Input (Presenter -> Router)
protocol IProfileRouter: MainRouting {
}
