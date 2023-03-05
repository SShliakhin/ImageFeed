//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 05.03.2023.
//

import Foundation

protocol IOAuth2Service {
	func fetchAuthToken(
		authCode: String,
		completion: @escaping (Result<OAuthTokenResponseBody, APIError>) -> Void
	)
}

struct OAuthTokenResponseBody: Model {
	let accessToken: String
	let tokenType: String
	let scope: String
	let createdAt: Date
}

final class OAuth2Service {
	private let network: APIClient
	private var task: NetworkTask?
	private var lastAuthCode: String?
	
	init(network: APIClient) {
		self.network = network
	}
}

extension OAuth2Service: IOAuth2Service {
	func fetchAuthToken(
		authCode: String,
		completion: @escaping (Result<OAuthTokenResponseBody, APIError>) -> Void
	) {
		assert(Thread.isMainThread)
		if lastAuthCode == authCode { return }
		task?.cancel()
		lastAuthCode = authCode
		
		let resourse = UnsplashAPI.getAuthTokenRequest(authCode)
		let request = PostRequest(endpoint: resourse.url, body: "")
		
		task = network.send(request){ [weak self] (result: Result<OAuthTokenResponseBody, APIError>) in
			guard let self = self else { return }
			switch result {
			case .success(let body):
				completion(.success(body))
				self.task = nil
			case .failure(let error):
				completion(.failure(error))
				self.lastAuthCode = nil
			}
		}
	}
}
