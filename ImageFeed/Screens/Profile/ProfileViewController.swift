//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.01.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var profile: Profile
    var profileViewModel: ProfileViewModel? {
        didSet {
            guard let profile = profileViewModel else { return }
            profileImageView.image = profile.image
            nameLabel.text = profile.fullName
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.description
        }
    }
    
    private lazy var vStackView = UIStackView()
    private lazy var hStackView = UIStackView()
    
    private lazy var profileImageView = UIImageView()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(style: .bold23)
        label.textColor = Theme.color(usage: .ypWhite)
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(style: .regular13)
        label.textColor = Theme.color(usage: .ypGray)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(style: .regular13)
        label.textColor = Theme.color(usage: .ypWhite)
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = Theme.image(kind: .exitIcon)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = Theme.color(usage: .ypRed)
        return button
    }()
    
    init(with profile: Profile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        applyStyle()
        applyLayout()
        
        profileViewModel = ProfileViewModel(from: profile)
    }
}

private extension ProfileViewController {
    func setup() {
        logoutButton.addTarget(
            self,
            action: #selector(logoutButtonTapped),
            for: .primaryActionTriggered
        )
    }
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypBlack)
    }
    func applyLayout() {
        hStackView.arrangeStackView(
            subviews: [
                profileImageView,
                UIView(),
                logoutButton
            ],
            aligment: .center
        )
        
        vStackView.arrangeStackView(
            subviews: [
                hStackView,
                nameLabel,
                loginNameLabel,
                descriptionLabel
            ],
            spacing: 8,
            axis: .vertical,
            aligment: .leading
        )
        
        [vStackView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.spacing(usage: .standard4)),
            vStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Theme.spacing(usage: .standard2)),
            vStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Theme.spacing(usage: .standard2)),
            profileImageView.heightAnchor.constraint(equalToConstant: Theme.size(kind: .profileImage)),
            profileImageView.widthAnchor.constraint(equalToConstant: Theme.size(kind: .profileImage)),
            hStackView.widthAnchor.constraint(equalTo: vStackView.widthAnchor, constant: -Theme.spacing(usage: .standard))
        ])
    }
}

// MARK: - Actions
private extension ProfileViewController {
    @objc func logoutButtonTapped(_ sender: UIButton) {
        print(#function)
    }
}
