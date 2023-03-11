//
//  Picture.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 22.12.2022.
//

import UIKit

struct Photo {
	let id: String
	let size: CGSize
	let createdAt: Date
	let welcomeDescription: String
	let thumbImageURL: URL
	let largeImageURL: URL
	var isLiked: Bool
}
