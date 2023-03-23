//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 22.12.2022.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
	// MARK: - UI
	private lazy var photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = Theme.size(kind: .cornerRadius)
		imageView.clipsToBounds = true
		return imageView
	}()

	private lazy var likeButton: UIButton = {
		let button = UIButton(type: .custom)

		// UI-tests
		button.accessibilityIdentifier = "likeButton"

		return button
	}()

	private lazy var gradientView: GradientView = {
		let view = GradientView()
		let layer = Theme.gradientLayer(kind: .bottomForDate)
		view.configure(from: layer)

		view.layer.cornerRadius = Theme.size(kind: .cornerRadius)
		view.layer.maskedCorners = [
			.layerMinXMaxYCorner,
			.layerMaxXMaxYCorner
		]
		view.layer.masksToBounds = true

		return view
	}()

	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.font = Theme.font(style: .regular13)
		label.textColor = Theme.color(usage: .ypWhite)
		return label
	}()

	// MARK: - Properties
	var photo: PhotoViewModel? {
		didSet {
			guard let photo = photo else { return }

			let indicator = GradientKFIndicator(
				gradientLayer: Theme.gradientLayer(kind: .loader),
				changeAnimation: Theme.changeAnimation(kind: .locations)
			)
			photoImageView.kf.indicatorType = .custom(indicator: indicator)
			photoImageView.kf.setImage(with: photo.imageURL) { [weak self] result in
				guard let self = self else { return }
				if case .failure = result {
					self.photoImageView.image = Theme.image(kind: .imagePlaceholder)
				}
			}

			setIsFavorite(photo.isFavorite)
			dateLabel.text = photo.dateString
		}
	}

	// MARK: - Init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
		applyStyle()
		applyLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Override methods
	override func prepareForReuse() {
		super.prepareForReuse()
		setIsFavorite(false)
		photoImageView.kf.cancelDownloadTask()
	}
}

// MARK: - UIComponent
private extension ImagesListCell {
	func setup() {
		likeButton.addTarget(
			self,
			action: #selector(likeButtonTapped),
			for: .primaryActionTriggered
		)
	}

	func applyStyle() {
		backgroundColor = .clear
		selectionStyle = .none
	}

	func applyLayout() {
		[
			photoImageView,
			likeButton,
			gradientView,
			dateLabel
		].forEach { item in
			item.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(item)
		}

		let pictureInsets = Theme.contentInset(kind: .image)

		NSLayoutConstraint.activate([
			photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: pictureInsets.top),
			photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -pictureInsets.bottom),
			photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: pictureInsets.left),
			photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -pictureInsets.right),

			likeButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
			likeButton.topAnchor.constraint(equalTo: photoImageView.topAnchor),
			likeButton.heightAnchor.constraint(equalToConstant: Theme.size(kind: .likeButton)),
			likeButton.widthAnchor.constraint(equalToConstant: Theme.size(kind: .likeButton)),

			gradientView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
			gradientView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
			gradientView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
			gradientView.heightAnchor.constraint(equalToConstant: Theme.size(kind: .gradientHeight)),

			dateLabel.leadingAnchor.constraint(
				equalTo: photoImageView.leadingAnchor,
				constant: Theme.spacing(usage: .standard)
			),
			dateLabel.trailingAnchor.constraint(
				lessThanOrEqualTo: photoImageView.trailingAnchor,
				constant: -Theme.spacing(usage: .standard)
			),
			dateLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -Theme.spacing(usage: .standard))
		])
	}

	func setIsFavorite(_ state: Bool) {
		likeButton.setBackgroundImage(
			state
			? Theme.image(kind: .favoriteActiveIcon)
			: Theme.image(kind: .favoriteNoActiveIcon),
			for: .normal
		)
	}
}

// MARK: - Action
extension ImagesListCell {
	@objc private func likeButtonTapped(_ sender: UIButton) {
		photo?.changeFavorite?()
	}
}
