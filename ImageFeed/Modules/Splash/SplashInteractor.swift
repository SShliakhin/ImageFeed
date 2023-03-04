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
			switch result {
			case .success(let profile):
				self?.output?.didFetchProfile(profile: profile)
			case .failure(let error):
				print(error)
			}
		}
	}
}
