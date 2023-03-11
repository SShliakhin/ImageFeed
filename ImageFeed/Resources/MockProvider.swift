//
//  MockProvider.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 17.01.2023.
//

import Foundation
import UIKit

enum MockProvider {
	static let photos: [Photo] = {
		(0...20).map { number in
			let localImageString = String(describing: number)
			let image = UIImage(named: localImageString)!
			return Photo(
				id: localImageString,
				size: image.size,
				createdAt: Date(),
				welcomeDescription: "",
				thumbImageURL: URL(string: "sas.com")!,
				largeImageURL: URL(string: "sas.com")!,
				isLiked: number % 2 == 0
			)
		}
	}()
	
	static let profile = ProfileResult (
		//image: "avatar",
		firstName: "Екатерина",
		lastName: "Новикова",
		username: "ekaterina_nov",
		bio: "Hello, world"
	)
}
