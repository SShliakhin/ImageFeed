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
    }
    
    static func image(kind: ImageAsset) -> UIImage {
        return UIImage(named: kind.rawValue) ?? .actions
    }
}
