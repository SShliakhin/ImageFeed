//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 04.03.2023.
//

import Foundation

protocol IProfileImageService {
	var avatarURL: String? { get }
	func fetchProfileImageURL(
		username: String,
		bearerToken: String,
		completion: @escaping (Result<String, APIError>) -> Void
	)
}

struct UserResult: Codable, Model {
	let profileImage: ProfileImage?
}

struct ProfileImage: Codable, Model {
	let small: String?
}

final class ProfileImageService {
	static let shared = ProfileImageService()
	
	private var network: APIClient?
	private var task: NetworkTask?
	
	private (set) var avatarURL: String?
}

extension ProfileImageService: IProfileImageService {
	func fetchProfileImageURL(
		username: String,
		bearerToken: String,
		completion: @escaping (Result<String, APIError>) -> Void
	) {
		assert(Thread.isMainThread)
		guard task == nil else { return }
		
		network = .init(session: URLSession.shared)
		guard let network = network else { return }
		
		let resource = UnsplashAPI.getPublicUser(username)
		var request = Request(endpoint: resource.url).urlRequest()
		request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
		
		task = network.send(request) { [weak self] ( result: Result<UserResult, APIError>) in
			switch result {
			case .success(let userResult):
				if let smallPictureURL = userResult.profileImage?.small {
					completion(.success(smallPictureURL))
					self?.avatarURL = smallPictureURL
				} else {
					completion(.failure(.noImageURL))
				}
				self?.task = nil
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
