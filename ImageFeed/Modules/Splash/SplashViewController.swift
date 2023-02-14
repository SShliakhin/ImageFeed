//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 11.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let presenter: ISplashViewOutput
    
    // MARK: - Init
    init(presenter: ISplashViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var practicumLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Theme.image(kind: .practicumLogo)
        imageView.tintColor = Theme.color(usage: .ypWhite)
        return imageView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyle()
        applyLayout()
        
        presenter.viewDidLoad()
    }
}

// MARK: - ISplashViewInput

extension SplashViewController: ISplashViewInput {}

// MARK: - ILoadWithIndicator

extension SplashViewController: ILoadWithIndicator {}

// MARK: - UIComponent
private extension SplashViewController {
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypBlack)
    }
    func applyLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        view.addSubview(practicumLogoImageView)
        practicumLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            practicumLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            practicumLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
