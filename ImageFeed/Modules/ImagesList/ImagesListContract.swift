//
//  ImagesListContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

// MARK: View Output (View -> Presenter)
protocol IImagesListViewOutput: AnyObject {
	func viewDidLoad()
	func didRefreshContent()
	func hasNoAnimatedBy(_ indexPath: IndexPath) -> Bool
	func getPhotos() -> [Photo]
	func didSelectPicture(_ photo: Photo)
	func didChangeLikeStatusOf(photo: Photo)
	func didDisplayLastPhoto()
}

// MARK: View Input (Presenter -> View)
protocol IImagesListViewInput: AnyObject {
	func reloadTableView()
	func addRowsToTableView(indexPaths: [IndexPath])
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IImagesListInteractorInput: AnyObject {
	func fetchPhotos()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IImagesListInteractorOutput: AnyObject {
	func didLoadPhotos(_ photos: [Photo])
}

// MARK: Router Input (Presenter -> Router)
protocol IImagesListRouter: MainRouting {}
