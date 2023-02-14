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

// MARK: - ILoadWithProgressHUD

extension SplashViewController: ILoadWithProgressHUD {}

// MARK: - UIComponent
private extension SplashViewController {
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypBlack)
    }
    func applyLayout() {
        view.addSubview(practicumLogoImageView)
        practicumLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            practicumLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            practicumLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
