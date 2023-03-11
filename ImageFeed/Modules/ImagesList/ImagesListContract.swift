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
	func didSelectPicture(_ photo: Photo)
}

// MARK: View Input (Presenter -> View)
protocol IImagesListViewInput: AnyObject {
	func showImages(photos: [Photo])
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IImagesListInteractorInput: AnyObject {
	func loadImages()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IImagesListInteractorOutput: AnyObject {
	func didloadImages(photos: [Photo])
}

// MARK: Router Input (Presenter -> Router)
protocol IImagesListRouter: MainRouting {}
