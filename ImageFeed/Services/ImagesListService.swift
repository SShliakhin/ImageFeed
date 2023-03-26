//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 08.03.2023.
//

import UIKit

protocol IImagesListService {
	var photos: [Photo] { get }

	func fetchPhotosNextPage()
	func setToken(_ bearerToken: String)
	func changeLike(
		photoId: String,
		isLike: Bool,
		_ completion: @escaping (Result<Bool, APIError>) -> Void
	)
}

extension IImagesListService {
	var didChangeNotification: Notification.Name {
		Notification.Name(rawValue: "ImagesListServiceDidChange")
	}
}

final class ImagesListService {
	private let notificationCenter: NotificationCenter
	private let network: APIClient
	private let photosPerPage: Int
	private let orderBy: UnsplashAPI.PhotoOrderBy

	private var bearerToken: String?
	private var task: NetworkTask?
	private var lastLoadedPage = 0
	private var duplicateControl: [String: Bool] = [:]

	private (set) var photos: [Photo] = [] {
		didSet {
			notificationCenter.post(name: didChangeNotification, object: self)
		}
	}

	init(
		network: APIClient,
		notificationCenter: NotificationCenter,
		photosPerPage: Int,
		orderBy: UnsplashAPI.PhotoOrderBy
	) {
		self.network = network
		self.notificationCenter = notificationCenter
		self.photosPerPage = photosPerPage
		self.orderBy = orderBy
	}
}

extension ImagesListService: IImagesListService {
	func setToken(_ bearerToken: String) {
		self.bearerToken = bearerToken
	}

	func fetchPhotosNextPage() {
		guard let bearerToken = bearerToken else { return }

		assert(Thread.isMainThread)
		guard task == nil else { return }

		let resource = UnsplashAPI.getListPhotos(lastLoadedPage + 1, photosPerPage, orderBy)
		var request = Request(endpoint: resource.url).urlRequest()
		request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

		task = network.send(request) { [weak self] ( result: Result<[PhotoResult], APIError>) in
			guard let self = self else { return }
			switch result {
			case .success(let result):
				var newPhotos: [Photo] = []
				for photo in result where self.duplicateControl[photo.id] == nil {
					self.duplicateControl[photo.id] = true
					newPhotos.append(photo.convert())
				}

				self.lastLoadedPage += 1
				self.photos += newPhotos
				self.task = nil
			case .failure(let error):
				assertionFailure(error.description)
			}
		}
	}

	func changeLike(
		photoId: String,
		isLike: Bool,
		_ completion: @escaping (Result<Bool, APIError>) -> Void
	) {
		guard let bearerToken = bearerToken else { return }

		assert(Thread.isMainThread)
		guard task == nil else { return }

		let resource = UnsplashAPI.likeUnlike(photoId)
		var request = isLike
		? PostRequest(endpoint: resource.url, body: "").urlRequest()
		: Request(endpoint: resource.url, method: .delete).urlRequest()
		request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

		task = network.send(request) { [weak self] ( result: Result<LikeResult, APIError>) in
			let likeResult: Result<Bool, APIError>

			guard let self = self else { return }
			switch result {
			case .success:
				if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
					self.photos[index].isLiked = isLike
				}
				likeResult = .success(isLike)
				self.task = nil
			case .failure(let error):
				likeResult = .failure(error)
			}
			completion(likeResult)
		}
	}
}
