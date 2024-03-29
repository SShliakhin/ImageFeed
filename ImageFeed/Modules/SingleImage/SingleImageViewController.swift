//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 13.01.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
	private let presenter: ISingleImageViewOutput

	// MARK: - UI
	private var image: UIImage? {
		didSet {
			guard let image = image else { return }
			fullScreenImageScrollView.configure(
				frame: view.bounds,
				image: image,
				minZoomScale: 0.01,
				maxZoomScale: 1.25
			)
		}
	}

	private lazy var fullScreenImageScrollView: FullScreenImageScrollView = {
		let scrollView = FullScreenImageScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
		return scrollView
	}()

	private lazy var backButton: UIButton = {
		let button = UIButton()

		// UI-tests
		button.accessibilityIdentifier = "backButton"

		button.setImage(Theme.image(kind: .backwardIcon), for: .normal)
		button.tintColor = Theme.color(usage: .ypWhite)
		return button
	}()

	private lazy var shareButton: UIButton = {
		let button = UIButton()
		button.setImage(Theme.image(kind: .shareIcon), for: .normal)
		return button
	}()

	// MARK: - Init
	init(presenter: ISingleImageViewOutput) {
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

// MARK: - IImagesListViewInput

extension SingleImageViewController: ISingleImageViewInput {
	func displayPhotoByData(_ data: Data) {
		if let image = UIImage(data: data) {
			self.image = image
		} else {
			showErrorDialog(with: "No image from data")
		}
	}
}

// MARK: - Actions
private extension SingleImageViewController {
	@objc func backButtonTapped(_ sender: UIButton) {
		presenter.didTapBack()
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

// MARK: - UIComponent
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

		fullScreenImageScrollView.configure(
			frame: view.bounds,
			image: Theme.image(kind: .imagePlaceholder),
			minZoomScale: 1,
			maxZoomScale: 1
		)
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

		NSLayoutConstraint.activate([
			fullScreenImageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
			fullScreenImageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			fullScreenImageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			fullScreenImageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			backButton.topAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.topAnchor,
				constant: Theme.spacing(usage: .standard2)
			),
			backButton.leadingAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leadingAnchor,
				constant: Theme.spacing(usage: .standard2)
			),

			shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			shareButton.bottomAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.bottomAnchor,
				constant: -Theme.spacing(usage: .standard2)
			)
		])
	}
}
