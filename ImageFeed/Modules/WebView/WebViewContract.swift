//
//  WebViewContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

// MARK: View Output (View -> Presenter)
protocol IWebViewViewOutput: AnyObject {
	func viewDidload()
	func didUpdateProgressValue(_ newValue: Double)
	func getAuthCode(from url: URL?) -> String?
	func didGetAuthCode(_ code: String)
	func didTapBack()
}

// MARK: View Input (Presenter -> View)
protocol IWebViewViewInput: AnyObject {
	func loadRequest(_ request: URLRequest)
	func setProgressValue(_ newValue: Float)
	func setProgressHidden()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol IWebViewInteractorInput: AnyObject {
	func getAuthCode(from url: URL) -> String?
	func getAuthRequest() -> URLRequest
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IWebViewInteractorOutput: AnyObject {}

// MARK: Router Input (Presenter -> Router)
protocol IWebViewRouter: MainRouting {}
