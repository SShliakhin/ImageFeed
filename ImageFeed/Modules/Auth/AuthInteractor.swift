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
    private let network: APIClient
	
	private var task: NetworkTask?
	private var lastCode: String?
    
    init(storage: ITokenStorage, network: APIClient) {
        self.storage = storage
        self.network = network
    }
    
    func fetchBearerTokenByCode(_ code: String) {
		assert(Thread.isMainThread)
		if lastCode == code { return }
		task?.cancel()
		lastCode = code
		
        let resourse = UnsplashAPI.getAuthTokenRequest(code)
        let request = PostRequest(endpoint: resourse.url, body: "")
		
		task = network.send(request){ [weak self] (result: Result<OAuthTokenResponseBody, APIError>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                self.storage.token = body.accessToken
                self.output?.didFetchBearerTokenSuccess("Token: =========== \(body.accessToken)")
				self.task = nil
            case .failure(let error):
                self.output?.didFetchBearerTokenFailure(error: error)
				self.lastCode = nil
            }
        }
    }
}
