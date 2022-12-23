//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 22.12.2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseID = String(describing: ImagesListCell.self)
    
    private let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton = UIButton(type: .custom)
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(style: .regular13)
        label.textColor = Theme.color(usage: .ypWhite)
        return label
    }()
    
    private var picture: PictureViewModel? {
        didSet {
            guard let picture = picture else { return }
            pictureImageView.image = picture.image
            setIsFavorite(picture.isFavorite)
            dateLabel.text = picture.dateString
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        applyStyle()
        applyLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setIsFavorite(false)
    }
    
}

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
    }
    
    func applyLayout() {
        [
            pictureImageView,
            likeButton,
            dateLabel
        ].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            pictureImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pictureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likeButton.trailingAnchor.constraint(equalTo: pictureImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: pictureImageView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            dateLabel.leadingAnchor.constraint(equalTo: pictureImageView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: pictureImageView.bottomAnchor, constant: -8)
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

// MARK: - Cell configuration
extension ImagesListCell {
    func configure(with viewModel: PictureViewModel) {
        picture = viewModel
    }
}

// MARK: - Action
extension ImagesListCell {
    @objc private func likeButtonTapped(_ sender: UIButton) {
        guard var picture = picture else { return }
        picture.isFavorite.toggle()
        setIsFavorite(picture.isFavorite)
    }
}
