//
//  PhotoLike.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 16.03.2023.
//

import Foundation

struct LikeResult: Model {
	let photo: PhotoResult
}

extension LikeResult {
	static var decoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}
}
