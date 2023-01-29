//
//  ImagesListContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol IImagesListViewOutput: AnyObject {
    func viewDidLoad()
}

// MARK: View Input (View -> Presenter)
protocol IImagesListViewInput: AnyObject {
    func showImages(pictures: [Picture])
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IImagesListInteractorInput: AnyObject {
    func loadImages()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IImagesListInteractorOutput: AnyObject {
    func didloadImages(pictures: [Picture])
}

// MARK: Router Input (Presenter -> Router)
protocol IImagesListRouter: MainRouting {
}
