//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.01.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    // MARK: - UI
	private lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = Theme.size(kind: .profileImageCornerRadius)
		imageView.clipsToBounds = true
		
		imageView.image = Theme.image(kind: .personPlaceholder)
		return imageView
	}()
    
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
	
	// MARK: - Properties
	private let presenter: IProfileViewOutput
	
	var profileViewModel: ProfileResult? {
		didSet {
			guard let profile = profileViewModel else { return }
			nameLabel.text = profile.name
			loginNameLabel.text = profile.loginName
			descriptionLabel.text = profile.bio
		}
	}
    
    // MARK: - Init
    init(presenter: IProfileViewOutput) {
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

// MARK: - IProfileViewInput

extension ProfileViewController: IProfileViewInput {
    func showProfile(profile: ProfileResult) {
        profileViewModel = profile
    }
	func updateAvatarURL(_ profileImageURL: URL) {
		profileImageView.kf.indicatorType = .activity
		profileImageView.kf.setImage(
			with: profileImageURL,
			placeholder: Theme.image(kind: .personPlaceholder)
		)
	}
}

// MARK: - Actions
private extension ProfileViewController {
	@objc func logoutButtonTapped(_ sender: UIButton) {
		presenter.didTapLogout()
	}
}

// MARK: - UIComponent
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
		let vStackView = UIStackView()
		let hStackView = UIStackView()
		
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
			spacing: Theme.spacing(usage: .standard),
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
