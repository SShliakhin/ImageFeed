//
//  AuthInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 09.02.2023.
//

import Foundation

final class AuthInteractor: IAuthInteractorInput {
	weak var output: IAuthInteractorOutput?
	private var storage: ITokenStorage
	private let oauth2TokenLoader: IOAuth2Service
	
	init(storage: ITokenStorage, oauth2TokenLoader: IOAuth2Service) {
		self.storage = storage
		self.oauth2TokenLoader = oauth2TokenLoader
	}
	
	func fetchBearerTokenByCode(_ code: String) {
		oauth2TokenLoader.fetchAuthToken(authCode: code) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let body):
				let token = body.accessToken
				self.storage.token = token
				self.output?.didFetchBearerTokenSuccess("Token: === \(token)")
			case .failure(let error):
				self.output?.didFetchBearerTokenFailure(error: error)
			}
		}
	}
}
