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

final class ImagesListService {	
	private let notificationCenter: NotificationCenter
	private let network: APIClient
	private let photosPerPage: Int
	private let orderBy: OrderBy
	
	private var bearerToken: String?
	private var task: NetworkTask?
	private var lastLoadedPage = 0
	private var duplicateСontrol: [String: Bool] = [:]
	
	private (set) var photos: [Photo] = [] {
		didSet {
			notificationCenter.post(name: didChangeNotification, object: self)
		}
	}
	
	init(
		network: APIClient,
		notificationCenter: NotificationCenter,
		photosPerPage: Int,
		orderBy: OrderBy
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
				for photo in result where self.duplicateСontrol[photo.id] == nil {
					self.duplicateСontrol[photo.id] = true
					newPhotos.append(photo.convert())
				}
				
				self.lastLoadedPage += 1
				self.photos += newPhotos
				self.task = nil
			case .failure(let error):
				print(error.description)
			}
		}
	}
}
