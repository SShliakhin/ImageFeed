//
//  SingleImageContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

// MARK: View Output (View -> Presenter)
protocol ISingleImageViewOutput: AnyObject {
	func viewDidLoad()
	func didTapBack()
}

// MARK: View Input (Presenter -> View)
protocol ISingleImageViewInput: IViewControllerWithErrorDialog, ILoadWithProgressHUD {
	func displayPhotoByData(_ data: Data)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol ISingleImageInteractorInput: AnyObject {
	func fetchImageDataBy(url: URL)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol ISingleImageInteractorOutput: AnyObject {
	func didFetchImageDataSuccess(data: Data)
	func didFetchImageDataFailure(error: APIError)
}

// MARK: Router Input (Presenter -> Router)
protocol ISingleImageRouter: MainRouting {}
