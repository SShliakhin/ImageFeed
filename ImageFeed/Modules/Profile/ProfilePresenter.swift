//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ProfilePresenter {
	weak var view: IProfileViewInput?
	private let interactor: IProfileInteractorInput
	private let router: IProfileRouter
	private let profile: ProfileResult
	
	init(interactor: IProfileInteractorInput, router: IProfileRouter, profile: ProfileResult) {
		self.interactor = interactor
		self.router = router
		self.profile = profile
	}
}

// MARK: - IProfileViewOutput

extension ProfilePresenter: IProfileViewOutput {
	func viewDidLoad() {
		view?.showProfile(profile: profile)
	}
	func logout() {
		interactor.cleanUpUserData()
	}
}

// MARK: - IProfileInteractorOutput

extension ProfilePresenter: IProfileInteractorOutput {
	func didCleanUpUserData() {
		let emptyCode = ""
		router.navigate(.toAuth(emptyCode))
	}
	func didFetchProfileImageURL(_ url: URL) {
		view?.updateAvatarURL(url)
	}
}
