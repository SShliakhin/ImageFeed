//
//  PicturesLoader.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 28.01.2023.
//

import Foundation

protocol PicturesLoading {
	func loadPictures() -> [Photo]
}

struct PicturesLoader: PicturesLoading {
	func loadPictures() -> [Photo] {
		MockProvider.photos
	}
}
