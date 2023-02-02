//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 31.01.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    private let presenter: IWebViewViewOutput
    
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

    // MARK: - Init
    init(presenter: IWebViewViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        applyStyle()
        applyLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
    }
}

// MARK: - KVO
extension WebViewViewController {
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath ==  #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

// MARK: - IWebViewViewInput
extension WebViewViewController: IWebViewViewInput{}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = presenter.getAuthCode(from: navigationAction.request.url) {
            presenter.didGetAuthCode(code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - UIComponent
private extension WebViewViewController {
    func setup() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .primaryActionTriggered)
        
        webView.navigationDelegate = self
        let request = presenter.getRequest()
        webView.load(request)
    }
    
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypWhite)
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
        presenter.didTapBack()
    }
}
