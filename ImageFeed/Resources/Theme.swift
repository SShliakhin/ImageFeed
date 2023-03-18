//
//  Theme.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 21.12.2022.
//

import UIKit

enum Theme {
	
	// MARK: - Fonts
	enum FontStyle {
		case bold23
		case bold20
		case bold17
		case regular17
		case regular13
	}
	
	static func font(style: FontStyle) -> UIFont {
		let customFont: UIFont
		
		switch style {
		case .bold23:
			customFont = UIFont(name: "YSDisplay-Bold", size: 23.0) ?? UIFont.systemFont(ofSize: 23.0)
		case .bold20:
			customFont = UIFont(name: "YSDisplay-Bold", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
		case .bold17:
			customFont = UIFont(name: "YSDisplay-Bold", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0)
		case .regular17:
			customFont = UIFont(name: "YandexSansDisplay-Regular", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0)
		case .regular13:
			customFont = UIFont(name: "YandexSansDisplay-Regular", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
		}
		
		return customFont
	}
	
	// MARK: - Colors
	enum Color {
		case ypBlack
		case ypGray
		case ypBackground
		case ypWhite
		case ypWhiteAlpha50
		case ypRed
		case ypBlue
	}
	
	static func color(usage: Color) -> UIColor {
		let customColor: UIColor
		
		switch usage {
		case .ypBlack:
			customColor = UIColor(named: "ypBlack") ?? UIColor.black
		case .ypGray:
			customColor = UIColor(named: "ypGray") ?? UIColor.systemGray
		case .ypBackground:
			customColor = UIColor(named: "ypBackground") ?? UIColor.systemBackground
		case .ypWhite:
			customColor = UIColor(named: "ypWhite") ?? UIColor.white
		case .ypWhiteAlpha50:
			customColor = UIColor(named: "ypWhiteAlpha50") ?? UIColor.white.withAlphaComponent(0.50)
		case .ypRed:
			customColor = UIColor(named: "ypRed") ?? UIColor.systemRed
		case .ypBlue:
			customColor = UIColor(named: "ypBlue") ?? UIColor.systemBlue
		}
		
		return customColor
	}
	
	// MARK: - Images
	enum ImageAsset: String {
		case practicumLogo, unsplashLogo
		case favoritePlaceholder, imagePlaceholder, personPlaceholder
		case tabListIcon, tabProfileIcon
		case favoriteActiveIcon, favoriteNoActiveIcon
		case backwardIcon, exitIcon, shareIcon
		case avatar
	}
	
	static func image(kind: ImageAsset) -> UIImage {
		return UIImage(named: kind.rawValue) ?? .actions
	}
	
	// MARK: - ContentInset
	enum ContentInset {
		case table
		case image
	}
	
	static func contentInset(kind: ContentInset) -> UIEdgeInsets {
		let customInsets: UIEdgeInsets
		
		switch kind {
		case .table:
			customInsets = UIEdgeInsets(
				top: 12,
				left: 0,
				bottom: 12,
				right: 0
			)
		case .image:
			customInsets = UIEdgeInsets(
				top: 4,
				left: 16,
				bottom: 4,
				right: 16
			)
		}
		
		return customInsets
	}
	
	// MARK: - Spacing
	enum Spacing {
		case standard
		case standard2
		case standardHalf
		case standard4
		case loginButtonToBottom
	}
	
	static func spacing(usage: Spacing) -> CGFloat {
		let customSpacing: CGFloat
		
		switch usage {
		case .standard:
			customSpacing = 8
		case .standard2:
			customSpacing = 16
		case .standardHalf:
			customSpacing = 4
		case .standard4:
			customSpacing = 32
		case .loginButtonToBottom:
			customSpacing = 90
		}
		
		return customSpacing
	}
	
	// MARK: - Size
	enum Size {
		case cornerRadius
		case likeButton
		case gradientHeight
		case cellHeight(size: CGSize)
		case profileImage
		case profileImageCornerRadius
		case loginButtonHeight
	}
	
	static func size(kind: Size) -> CGFloat {
		let customSize: CGFloat
		
		switch kind {
		case .cornerRadius:
			customSize = 16
		case .likeButton:
			customSize = 42
		case .gradientHeight:
			customSize = 30
		case let .cellHeight(size):
			let imageInsets = contentInset(kind: .image)
			let aspectRatio = size.height / size.width
			let cellWidth = UIScreen.main.bounds.width - imageInsets.left - imageInsets.right
			
			customSize = cellWidth * aspectRatio + imageInsets.top + imageInsets.bottom
		case .profileImage:
			customSize = 70
		case .profileImageCornerRadius:
			customSize = 35
		case .loginButtonHeight:
			customSize = 48
		}
		
		return customSize
	}
	
	// MARK: - DateFormatter
	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter
	}()

	// MARK: - Animation

	// MARK: - Gradient
	enum GradientKind {
		case bottomForDate
		case avatar(UIView)
		case label(UIView)
		case label2(UIView)
		case loader
	}

	static func gradientLayer(kind: GradientKind) -> CAGradientLayer {
		let baseGradient = CAGradientLayer()
		baseGradient.locations = [0, 0.1, 0.3]
		baseGradient.colors = [
			UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
			UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
			UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
		]
		baseGradient.startPoint = CGPoint(x: 0, y: 0.5)
		baseGradient.endPoint = CGPoint(x: 1, y: 0.5)

		switch kind {
		case .avatar(let view):
			baseGradient.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
			baseGradient.cornerRadius = 35
			baseGradient.masksToBounds = true
			view.layer.insertSublayer(baseGradient, at: 0)
		case .label(let view):
			baseGradient.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 33))
			baseGradient.cornerRadius = 6
			baseGradient.masksToBounds = true
			view.layer.insertSublayer(baseGradient, at: 0)
		case .label2(let view):
			baseGradient.frame = CGRect(origin: .zero, size: CGSize(width: 150, height: 22))
			baseGradient.cornerRadius = 6
			baseGradient.masksToBounds = true
			view.layer.insertSublayer(baseGradient, at: 0)
		case .loader:
			break
		case .bottomForDate:
			baseGradient.locations = [0, 0.5]
			baseGradient.colors = [
				color(usage: .ypBlack).withAlphaComponent(0.2).cgColor,
				color(usage: .ypBlack).withAlphaComponent(0).cgColor
			]
		}

		return baseGradient
	}

	// MARK: - BasicAnimation
	enum BasicAnimationKind {
		case locations
	}

	static func changeAnimation(kind: BasicAnimationKind) -> CABasicAnimation {
		let baseAnimation = CABasicAnimation()
		baseAnimation.duration = 1.0
		baseAnimation.repeatCount = .infinity
		baseAnimation.autoreverses = true
		baseAnimation.fromValue = [0, 0.1, 0.3]
		baseAnimation.toValue = [0, 0.8, 1]

		switch kind {
		case .locations:
			baseAnimation.keyPath = "locations"
		}

		return baseAnimation
	}
}
