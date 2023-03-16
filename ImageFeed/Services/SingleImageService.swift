//
//  SingleImageService.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 16.03.2023.
//

import Foundation

protocol ISingleImageService {
	func fetchImageDataBy(
		url: URL,
		completion: @escaping (Result<Data, APIError>) -> Void
	)
}

final class SingleImageService {
	private let network: APIClient
	private var task: NetworkTask?
	private var lastURL: URL?

	init(network: APIClient) {
		self.network = network
	}
}

extension SingleImageService: ISingleImageService {
	func fetchImageDataBy(
		url: URL,
		completion: @escaping (Result<Data, APIError>) -> Void
	) {
		assert(Thread.isMainThread)
		if lastURL == url { return }
		task?.cancel()
		lastURL = url

		let request = Request(endpoint: url)

		task = network.send(request){ [weak self] (result: Result<Data, APIError>) in
			guard let self = self else { return }
			switch result {
			case .success(let data):
				completion(.success(data))
				self.task = nil
				self.lastURL = nil
			case .failure(let error):
				completion(.failure(error))
				self.lastURL = nil
			}
		}
	}
}
