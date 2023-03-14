//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 11.03.2023.
//

import Foundation

struct PhotoResult: Model {
	let id: String
	let createdAt: Date?
	let width: Int
	let height: Int
	let likedByUser: Bool
	let description: String?
	let urls: PhotoUrlsResult
	
	struct PhotoUrlsResult: Model {
		let full: URL
		let small: URL
	}
}

extension PhotoResult {
	static var decoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}
}

extension PhotoResult {
	func convert() -> Photo {
		Photo(
			id: self.id,
			size: .init(width: self.width, height: self.height),
			createdAt: self.createdAt ?? Date(),
			welcomeDescription: self.description ?? "",
			thumbImageURL: self.urls.small,
			largeImageURL: self.urls.full,
			isLiked: self.likedByUser
		)
	}
}
