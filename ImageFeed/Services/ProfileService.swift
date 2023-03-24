import Foundation

protocol IProfileService {
	func fetchProfile(
		bearerToken: String,
		completion: @escaping (Result<ProfileResult, APIError>) -> Void
	)
}

struct ProfileResult: Model, Equatable {
	let firstName: String?
	let lastName: String?
	let username: String?
	let bio: String?

	var name: String {
		[firstName, lastName]
			.compactMap { $0 }
			.joined(separator: " ")
	}

	var someUsername: String {
		guard let username = username else { return "" }
		return username
	}

	var loginName: String {
		"@\(someUsername)"
	}
}

final class ProfileService {
	private let network: APIClient
	private var task: NetworkTask?

	init(network: APIClient) {
		self.network = network
	}
}

extension ProfileService: IProfileService {
	func fetchProfile(bearerToken: String, completion: @escaping (Result<ProfileResult, APIError>) -> Void) {
		assert(Thread.isMainThread)
		guard task == nil else { return }

		let resource = UnsplashAPI.getMe
		var request = Request(endpoint: resource.url).urlRequest()
		request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

		task = network.send(request) { [weak self] ( result: Result<ProfileResult, APIError>) in
			switch result {
			case .success(let profile):
				completion(.success(profile))
				self?.task = nil
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
