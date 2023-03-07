//
//  WebViewContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

// MARK: View Output (View -> Presenter)
protocol IWebViewViewOutput: AnyObject {
    func getAuthCode(from url: URL?) -> String?
    
    func didTapBack()
    func didGetAuthCode(_ code: String)
	func viewDidload()
}

// MARK: View Input (Presenter -> View)
protocol IWebViewViewInput: AnyObject {
	func loadRequest(_ request: URLRequest)
}

// MARK: Router Input (Presenter -> Router)
protocol IWebViewRouter: MainRouting {}
