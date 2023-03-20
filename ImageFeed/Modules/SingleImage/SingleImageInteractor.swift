//
//  SingleImageInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class SingleImageInteractor {
	weak var output: ISingleImageInteractorOutput?
	private let singleImageDataLoader: ISingleImageService

	init(dep: ISingleImageModuleDependency) {
		self.singleImageDataLoader = dep.singleImageDataLoader
	}
}

// MARK: - ISingleImageInteractorInput

extension SingleImageInteractor: ISingleImageInteractorInput {
	func fetchImageDataBy(url: URL) {
		singleImageDataLoader.fetchImageDataBy(url: url) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let data):
				self.output?.didFetchImageDataSuccess(data: data)
			case .failure(let error):
				self.output?.didFetchImageDataFailure(error: error)
			}
		}
	}
}
