//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 13.01.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    private let picture: Picture
    private var image: UIImage? {
        didSet {
            guard let image = image else {
                return
            }
            fullScreenImageScrollView.configure(image: image)
        }
    }
    
    private lazy var fullScreenImageScrollView: FullScreenImageScrollView = {
        .init(frame: view.bounds)
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Theme.image(kind: .backwardIcon), for: .normal)
        button.tintColor = Theme.color(usage: .ypWhite)
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(Theme.image(kind: .shareIcon), for: .normal)
        return button
    }()

    
    init(picture: Picture) {
        self.picture = picture
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
        
        let pictureViewModel = PictureViewModel.init(from: picture)
        image = pictureViewModel.image
    }
}

private extension SingleImageViewController {
    func setup() {
        backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .primaryActionTriggered
        )
        
        shareButton.addTarget(
            self,
            action: #selector(shareButtonTapped),
            for: .primaryActionTriggered
        )
    }
    
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypBlack)
    }
    
    func applyLayout() {
        [
            fullScreenImageScrollView,
            backButton,
            shareButton
        ].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            fullScreenImageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            fullScreenImageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            fullScreenImageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenImageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Theme.spacing(usage: .standard2)),
            backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Theme.spacing(usage: .standard2)),
            
            shareButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Theme.spacing(usage: .standard2))
        ])
    }
}

// MARK: - Actions
private extension SingleImageViewController {
    @objc func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        guard let image = image else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        present(activityVC, animated: true)
    }
}
