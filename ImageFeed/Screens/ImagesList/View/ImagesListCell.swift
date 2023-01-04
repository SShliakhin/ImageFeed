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
        imageView.layer.cornerRadius = Theme.size(kind: .cornerRadius)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton = UIButton(type: .custom)
    var didLikeTaped: (() -> Void)?
    
    private let gradientView: GradientView = {
        let view = GradientView()
        
        view.configure(
            colors: [
                Theme.color(usage: .ypBlack).withAlphaComponent(0.2).cgColor,
                Theme.color(usage: .ypBlack).withAlphaComponent(0).cgColor
            ],
            locations: [0, 0.5],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5)
        )
        
        view.layer.cornerRadius = Theme.size(kind: .cornerRadius)
        view.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        view.layer.masksToBounds = true
        
        return view
    }()
    
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
        selectionStyle = .none
    }
    
    func applyLayout() {
        [
            pictureImageView,
            likeButton,
            gradientView,
            dateLabel
        ].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.spacing(usage: .standardHalf)),
            pictureImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Theme.spacing(usage: .standardHalf)),
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.spacing(usage: .standard2)),
            pictureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.spacing(usage: .standard2)),
            
            likeButton.trailingAnchor.constraint(equalTo: pictureImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: pictureImageView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: Theme.size(kind: .likeButton)),
            likeButton.widthAnchor.constraint(equalToConstant: Theme.size(kind: .likeButton)),
            
            gradientView.leadingAnchor.constraint(equalTo: pictureImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: pictureImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: pictureImageView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: Theme.size(kind: .gradientHeight)),
            
            dateLabel.leadingAnchor.constraint(equalTo: pictureImageView.leadingAnchor, constant: Theme.spacing(usage: .standard)),
            dateLabel.bottomAnchor.constraint(equalTo: pictureImageView.bottomAnchor, constant: -Theme.spacing(usage: .standard))
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
        let currentLike = sender.backgroundImage(for: .normal) == Theme.image(kind: .favoriteActiveIcon)
        setIsFavorite(!currentLike)
        guard let didLikeTaped = didLikeTaped else { return }
        didLikeTaped()
    }
}
