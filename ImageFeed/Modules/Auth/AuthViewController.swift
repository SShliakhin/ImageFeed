//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 31.01.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let presenter: IAuthViewOutput
    
    // MARK: - UI
    private lazy var unsplashLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Theme.image(kind: .unsplashLogo)
        imageView.tintColor = Theme.color(usage: .ypWhite)
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
		button.setTitle(Appearance.loginButtonTitle, for: .normal)
        button.titleLabel?.font = Theme.font(style: .bold17)
        button.setTitleColor(Theme.color(usage: .ypBlack), for: .normal)
        button.backgroundColor = Theme.color(usage: .ypWhite)
        
        button.layer.cornerRadius = Theme.size(kind: .cornerRadius)
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Init
    init(presenter: IAuthViewOutput) {
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
        
        presenter.viewDidLoad()
    }
}

// MARK: - IAuthViewInput

extension AuthViewController: IAuthViewInput {}

// MARK: - ILoadWithProgressHUD

extension AuthViewController: ILoadWithProgressHUD {}

// MARK: - Actions
private extension AuthViewController {
	@objc func loginButtonTapped(_ sender: UIButton) {
		presenter.didTapLogin()
	}
}

// MARK: - UIComponent
private extension AuthViewController {
    private func setup() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .primaryActionTriggered)
    }
    
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypBlack)
    }
    
    func applyLayout() {
        [
			unsplashLogoImageView,
			loginButton
		].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            unsplashLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            unsplashLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Theme.spacing(usage: .standard2)),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Theme.spacing(usage: .standard2)),
            loginButton.heightAnchor.constraint(equalToConstant: Theme.size(kind: .loginButtonHeight)),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Theme.spacing(usage: .loginButtonToBottom))
        ])
    }
}

private extension AuthViewController {
	enum Appearance {
		static let loginButtonTitle = "Войти"
	}
}
