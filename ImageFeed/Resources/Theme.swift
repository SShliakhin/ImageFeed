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
        case cellHeight(image: UIImage?)
        case profileImage
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
        case let .cellHeight(image):
            guard let image = image else { return 0 }
            let imageInsets = contentInset(kind: .image)
            
            let imageSize = image.size
            let aspectRatio = imageSize.height / imageSize.width
            let cellWidth = UIScreen.main.bounds.width - imageInsets.left - imageInsets.right
            
            customSize = cellWidth * aspectRatio + imageInsets.top + imageInsets.bottom
        case .profileImage:
            customSize = 70
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
}
