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
	
	// одиночка
	private let profileImageURLLoader = ProfileImageService.shared
	private var profileImageServiceObserver: NSObjectProtocol?
    
	init(interactor: IProfileInteractorInput, router: IProfileRouter, profile: ProfileResult) {
        self.interactor = interactor
        self.router = router
		self.profile = profile
    }
    
	func viewDidLoad() {
		view?.showProfile(profile: profile)
		profileImageServiceObserver = NotificationCenter.default.addObserver(
			forName: ProfileImageService.didChangeNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self = self else { return }
			self.updateAvatar()
		}
		updateAvatar()
	}
    func didTapLogout() {
        interactor.cleanUpStorage()
    }
}

private extension ProfilePresenter {
	private func updateAvatar() {
		guard
			let profileImageURL = ProfileImageService.shared.profileImageURL,
			let url = URL(string: profileImageURL)
		else { return }
		print(#function, url)
		// TODO [Sprint 11] Обновить аватар, используя Kingfisher
	}
}

// MARK: - IProfileInteractorOutput

extension ProfilePresenter: IProfileInteractorOutput {
    func didCleanUpStorage() {
        let emptyCode = ""
        router.navigate(.toAuth(emptyCode))
    }
}
