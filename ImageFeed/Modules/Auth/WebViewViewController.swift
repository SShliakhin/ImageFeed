//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 31.01.2023.
//

import UIKit
import WebKit

protocol IWebViewModuleOutput: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    weak var moduleOutput: IWebViewModuleOutput?
    
    // MARK: - UI
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = Theme.color(usage: .ypWhite)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Theme.image(kind: .backwardIcon), for: .normal)
        button.tintColor = Theme.color(usage: .ypBlack)
        return button
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.tintColor = Theme.color(usage: .ypBlack)
        return progressView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        applyStyle()
        applyLayout()
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = getAuthCode(from: navigationAction) {
            moduleOutput?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func getAuthCode(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

// MARK: - UIComponent
private extension WebViewViewController {
    func setup() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .primaryActionTriggered)
        setupWebView()
    }
    
    func setupWebView() {
        webView.navigationDelegate = self
        
        guard var urlComponents = URLComponents(string: .key(.unsplashAuthorizeURLString)) else {
            fatalError("Can't construct urlComponent")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: .key(.accessKey)),
            URLQueryItem(name: "redirect_uri", value: .key(.redirectURI)),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: .key(.accessScope))
        ]
        guard let url = urlComponents.url else {
            fatalError("Can't construct url")
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypWhite)
        progressView.progress = 0.5
    }
    
    func applyLayout() {
        [webView, backButton, progressView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.spacing(usage: .standard2)),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Theme.spacing(usage: .standard2)),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Actions
private extension WebViewViewController {
    @objc func backButtonTapped(_ sender: UIButton) {
        moduleOutput?.webViewViewControllerDidCancel(self)
    }
}
