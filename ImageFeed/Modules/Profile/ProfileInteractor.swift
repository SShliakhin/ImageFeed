//
//  ProfileInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ProfileInteractor {
	weak var output: IProfileInteractorOutput?
	private let storage: ITokenStorage
	private let profilePictureURLLoader: IProfileImageURLService
	private var profileImageServiceObserver: NSObjectProtocol?
	
	init(dep: IProfileModuleDependency) {
		self.storage = dep.storage
		self.profilePictureURLLoader = dep.profilePictureURLLoader
		
		profileImageServiceObserver = dep.notificationCenter.addObserver(
			forName: ProfileImageURLService.didChangeNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self = self else { return }
			self.fetchProfileImageURL()
		}
		fetchProfileImageURL()
	}
}

private extension ProfileInteractor {
	func fetchProfileImageURL() {
		guard
			let profileImageURL = profilePictureURLLoader.profileImageURL,
			let url = URL(string: profileImageURL)
		else { return }
		output?.didFetchProfileImageURL(url)
	}
}

// MARK: - IProfileInteractorInput

extension ProfileInteractor: IProfileInteractorInput {
	func cleanUpStorage() {
		storage.removeToken()
		output?.didCleanUpStorage()
	}
}
