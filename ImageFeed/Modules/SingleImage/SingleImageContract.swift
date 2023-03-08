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
protocol ISingleImageViewInput: AnyObject {
	func showImage()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol ISingleImageInteractorInput: AnyObject {}

// MARK: Interactor Output (Interactor -> Presenter)
protocol ISingleImageInteractorOutput: AnyObject {}

// MARK: Router Input (Presenter -> Router)
protocol ISingleImageRouter: MainRouting {}
