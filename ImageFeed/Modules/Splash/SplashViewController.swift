//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 11.02.2023.
//

import UIKit

class SplashViewController: UIViewController {
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
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyle()
        applyLayout()
        
        presenter.viewDidLoad()
    }
}

// MARK: - ISplashtViewInput

extension SplashViewController: ISplashViewInput {
    func activityIndicatorStart() {
        activityIndicator.startAnimating()
    }
    func activityIndicatorStop() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UIComponent

private extension SplashViewController {
    func applyStyle() {
        view.backgroundColor = UIColor.white
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
    }
    func applyLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
    }
}
