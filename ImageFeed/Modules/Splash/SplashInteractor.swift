//
//  SplashInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.02.2023.
//

import Foundation

final class SplashInteractor: ISplashInteractorInput {
	weak var output: ISplashInteractorOutput?
	private let storage: ITokenStorage
	private let profileLoader: IProfileService
	// одиночка
	private let profileImageURLLoader = ProfileImageService.shared
	
	var hasToken: Bool {
		storage.token != nil
	}
	
	init(storage: ITokenStorage, profileLoader: IProfileService) {
		self.storage = storage
		self.profileLoader = profileLoader
	}
	
	func fetchProfile() {
		guard let token = storage.token else { return }
		profileLoader.fetchProfile(bearerToken: token) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let profile):
				self.output?.didFetchProfileSuccess(profile: profile)
				self.profileImageURLLoader.fetchProfileImageURL(username: profile.someUsername, bearerToken: token) { _ in }
			case .failure(let error):
				self.output?.didFetchProfileFailure(error: error)
			}
		}
	}
}
