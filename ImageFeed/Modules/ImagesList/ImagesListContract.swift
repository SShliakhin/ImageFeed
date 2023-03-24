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
	func didChangeLikeStatusOf(photo: Photo)
	func didDisplayLastPhoto()
	func didSelectPhoto(_ photo: Photo)
}

// MARK: View Input (Presenter -> View)
protocol IImagesListViewInput: ILoadWithProgressHUD, IViewControllerWithErrorDialog {
	func reloadTableView()
	func addRowsToTableView(indexPaths: [IndexPath])
	func updateRowByIndex(_ index: Int)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IImagesListInteractorInput: AnyObject {
	func fetchPhotos()
	func changePhotoLike(photoId: String, isLike: Bool)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IImagesListInteractorOutput: AnyObject {
	func didFetchPhotos(_ photos: [Photo])
	func didChangePhotoLikeSuccess(photoId: String, isLike: Bool)
	func didChangePhotoLikeFailure(error: APIError)
}

// MARK: Router Input (Presenter -> Router)
protocol IImagesListRouter: MainRouting {}
