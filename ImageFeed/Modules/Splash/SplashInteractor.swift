//
//  SplashInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.02.2023.
//

import Foundation

final class SplashInteractor {
	weak var output: ISplashInteractorOutput?
	private let storage: ITokenStorage
	private let profileLoader: IProfileService
	private let profileImageURLLoader: IProfileImageURLService
	private let imagesListPageLoader: IImagesListService

	init(dep: IStartModuleDependency) {
		self.storage = dep.storage
		self.profileLoader = dep.profileLoader
		self.profileImageURLLoader = dep.profilePictureURLLoader
		self.imagesListPageLoader = dep.imagesListPageLoader
	}
}

// MARK: - ISplashInteractorInput

extension SplashInteractor: ISplashInteractorInput {
	var hasToken: Bool {
		storage.token != nil
	}
	
	func fetchProfile() {
		guard let token = storage.token else { return }
		profileLoader.fetchProfile(bearerToken: token) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let profile):
				self.output?.didFetchProfileSuccess(profile: profile)
				self.profileImageURLLoader.fetchProfileImageURL(
					username: profile.someUsername,
					bearerToken: token
				) { _ in }
				self.imagesListPageLoader.setToken(token)
				self.imagesListPageLoader.fetchPhotosNextPage()
			case .failure(let error):
				self.output?.didFetchProfileFailure(error: error)
			}
		}
	}
}
