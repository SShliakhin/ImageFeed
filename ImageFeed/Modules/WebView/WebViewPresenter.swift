//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class WebViewPresenter: IWebViewViewOutput {
    weak var view: IWebViewViewInput?
    weak var moduleOutput: IWebViewModuleOutput?

    func didGetAuthCode(_ code: String) {
        guard let view = view as? UIViewController else { return }
        moduleOutput?.webViewModule(view , didAuthenticateWithCode: code)
    }
    
    func didTapBack() {
        guard let view = view as? UIViewController else { return }
        moduleOutput?.WebViewModuleDidCancel(view)
    }
}
