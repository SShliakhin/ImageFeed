//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 04.03.2023.
//

import Foundation

protocol IProfileImageURLService {
	var profileImageURL: String? { get }
	func fetchProfileImageURL(
		username: String,
		bearerToken: String,
		completion: @escaping (Result<String, APIError>) -> Void
	)
}

extension IProfileImageURLService {
	var didChangeNotification: Notification.Name {
		Notification.Name(rawValue: "ProfileImageProviderDidChange")
	}
}

struct UserResult: Model {
	let profileImage: ProfileImage?

	struct ProfileImage: Model {
		let small: String?
	}
}

final class ProfileImageURLService {
	private let notificationCenter: NotificationCenter
	private let network: APIClient
	private var task: NetworkTask?

	private (set) var profileImageURL: String? {
		didSet {
			notificationCenter.post(
				name: didChangeNotification,
				object: self,
				userInfo: ["URL": self.profileImageURL as Any]
			)
		}
	}

	init(network: APIClient, notificationCenter: NotificationCenter) {
		self.network = network
		self.notificationCenter = notificationCenter
	}
}

extension ProfileImageURLService: IProfileImageURLService {
	func fetchProfileImageURL(
		username: String,
		bearerToken: String,
		completion: @escaping (Result<String, APIError>) -> Void
	) {
		assert(Thread.isMainThread)
		guard task == nil else { return }

		let resource = UnsplashAPI.getPublicUser(username)
		var request = Request(endpoint: resource.url).urlRequest()
		request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

		task = network.send(request) { [weak self] ( result: Result<UserResult, APIError>) in
			guard let self = self else { return }
			switch result {
			case .success(let userResult):
				if let smallPictureURL = userResult.profileImage?.small {
					completion(.success(smallPictureURL))
					self.profileImageURL = smallPictureURL
				} else {
					completion(.failure(.errorMessage("No image URL")))
				}
				self.task = nil
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
