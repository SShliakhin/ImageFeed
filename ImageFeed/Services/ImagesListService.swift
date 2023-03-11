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
}

extension IImagesListService {
	var didChangeNotification: Notification.Name {
		Notification.Name(rawValue: "ImagesListServiceDidChange")
	}
}

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

private extension PhotoResult {
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

final class ImagesListService {	
	private let notificationCenter: NotificationCenter
	private let network: APIClient
	
	private var bearerToken: String?
	private var task: NetworkTask?
	
	private (set) var photos: [Photo] = [] {
		didSet {
			notificationCenter.post(name: didChangeNotification, object: self)
			print("сигнал: Загрузил")
			print(photos)
		}
	}
	
	private var lastLoadedPage: Int {
		photos.count / photosPerPage
	}
	// TODO: - прокинуть извне
	private let photosPerPage = 10
	private let orderBy = OrderBy.latest
	
	init(network: APIClient, notificationCenter: NotificationCenter) {
		self.network = network
		self.notificationCenter = notificationCenter
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
				let newPhotos = result.map { $0.convert() }
				self.photos += newPhotos
				self.task = nil
			case .failure(let error):
				print(error.description)
			}
		}
	}
}
