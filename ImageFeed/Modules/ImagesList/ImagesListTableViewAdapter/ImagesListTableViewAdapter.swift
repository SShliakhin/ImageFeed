//
//  ImagesListTableViewAdapter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 11.03.2023.
//

import UIKit

final class ImagesListTableViewAdapter: NSObject {
	private let presenter: IImagesListViewOutput

	init(presenter: IImagesListViewOutput) {
		self.presenter = presenter
	}
}

private extension ImagesListTableViewAdapter {
	func itemCount() -> Int {
		getPhotos().count
	}
	func getPhotos() -> [Photo] {
		presenter.getPhotos()
	}
}

// MARK: - UITableViewDataSource

extension ImagesListTableViewAdapter: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		itemCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let photo = getPhotos()[safe: indexPath.row] else { return UITableViewCell() }
		let model = PhotoViewModel(from: photo) { [weak self] in
			self?.presenter.didChangeLikeStatusOf(photo: photo)
		}

		return tableView.dequeueReusableCell(withModel: model, for: indexPath)
	}
}

// MARK: - UITableViewDelegate

extension ImagesListTableViewAdapter: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let photo = getPhotos()[safe: indexPath.row] else { return }
		presenter.didSelectPhoto(photo)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let photo = getPhotos()[safe: indexPath.row] else { return CGFloat.zero }
		return Theme.size(kind: .cellHeight(size: photo.size))
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard presenter.hasNoAnimatedBy(indexPath) else { return }

		cell.transform3DMakeRotation(
			degree: 90,
			x: 0,
			y: 1,
			z: 0,
			duration: 0.85,
			delay: 0.1
		)

		// на время UI-tests выключать
//		if indexPath.row == itemCount() - 1 {
//			presenter.didDisplayLastPhoto()
//		}
	}
}
