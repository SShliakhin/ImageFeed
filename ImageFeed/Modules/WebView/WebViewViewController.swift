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
	private var estimatedProgressObservation: NSKeyValueObservation?
	
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
		
		presenter.viewDidload()
	}
}

// MARK: - IWebViewViewInput

extension WebViewViewController: IWebViewViewInput {
	func setProgressValue(_ newValue: Float) {
		progressView.progress = newValue
	}

	func setProgressHidden() {
		progressView.isHidden = true
	}

	func loadRequest(_ request: URLRequest) {
		webView.load(request)
	}
}

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

// MARK: - KVO
private extension WebViewViewController {
	func setupEstimatedProgressObservation() {
		estimatedProgressObservation = webView.observe(
			\.estimatedProgress,
			 options: []
		) { [weak self] _, _ in
			guard let self = self else { return }
			self.presenter.didUpdateProgressValue(self.webView.estimatedProgress)
		}
	}
}

// MARK: - Actions
private extension WebViewViewController {
	@objc func backButtonTapped(_ sender: UIButton) {
		presenter.didTapBack()
	}
}

// MARK: - UIComponent
private extension WebViewViewController {
	func setup() {
		setupEstimatedProgressObservation()
		backButton.addTarget(self, action: #selector(backButtonTapped), for: .primaryActionTriggered)
		webView.navigationDelegate = self
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
