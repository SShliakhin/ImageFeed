//
//  ProfileInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation
import WebKit

final class ProfileInteractor {
	weak var output: IProfileInteractorOutput?
	private let storage: ITokenStorage
	private let profilePictureURLLoader: IProfileImageURLService
	private var profileImageServiceObserver: NSObjectProtocol?
	
	init(dep: IProfileModuleDependency) {
		self.storage = dep.storage
		self.profilePictureURLLoader = dep.profilePictureURLLoader
		
		profileImageServiceObserver = dep.notificationCenter.addObserver(
			forName: profilePictureURLLoader.didChangeNotification,
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
	func cleanUpUserData() {
		removeWebData()
		removeToken()
		output?.didCleanUpUserData()
	}
}

// MARK: - Private methods
private extension ProfileInteractor {
	func removeToken() {
		storage.removeToken()
	}

	func removeWebData() {
		// Очищаем все куки из хранилища.
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		// Запрашиваем все данные из локального хранилища.
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			// Массив полученных записей удаляем из хранилища.
			records.forEach { record in
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
			}
		}
	}
}
