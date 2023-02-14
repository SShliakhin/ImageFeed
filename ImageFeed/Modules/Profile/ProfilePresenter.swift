//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ProfilePresenter: IProfileViewOutput {
    weak var view: IProfileViewInput?
    private let interactor: IProfileInteractorInput
    private let router: IProfileRouter
    
    init(interactor: IProfileInteractorInput, router: IProfileRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.obtainProfile()
    }
    func didTapLogout() {
        interactor.cleanUpStorage()
    }
}

extension ProfilePresenter: IProfileInteractorOutput {
    func didCleanUpStorage() {
        let emptyCode = ""
        router.navigate(.toAuth(emptyCode))
    }
    
    func didObtainProfile(profile: Profile) {
        let profileViewModel = ProfileViewModel(from: profile)
        view?.showProfile(profile: profileViewModel)
    }
}
