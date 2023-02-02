//
//  WebViewContract.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol IWebViewViewOutput: AnyObject {
    func didTapBack()
    func didGetAuthCode(_ code: String)
}

// MARK: View Input (View -> Presenter)
protocol IWebViewViewInput: AnyObject {
}

protocol IWebViewModuleOutput: AnyObject {
    func webViewModule(_ vc: UIViewController, didAuthenticateWithCode code: String)
    func WebViewModuleDidCancel(_ vc: UIViewController)
}
