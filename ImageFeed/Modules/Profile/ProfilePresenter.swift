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
	private let profile: ProfileResult
    
	init(interactor: IProfileInteractorInput, router: IProfileRouter, profile: ProfileResult) {
        self.interactor = interactor
        self.router = router
		self.profile = profile
    }
    
	func viewDidLoad() {
		view?.showProfile(profile: profile)
	}
    func didTapLogout() {
        interactor.cleanUpStorage()
    }
}

// MARK: - IProfileInteractorOutput

extension ProfilePresenter: IProfileInteractorOutput {
    func didCleanUpStorage() {
        let emptyCode = ""
        router.navigate(.toAuth(emptyCode))
    }
	
	func didFetchProfileImageURL(_ url: URL) {
		view?.updateAvatarURL(url)
	}
}
