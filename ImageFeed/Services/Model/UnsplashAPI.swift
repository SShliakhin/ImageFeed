//
//  UnsplashAPI.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 05.02.2023.
//

import Foundation

enum UnsplashAPI: API {
    
    case getAuthorizationCodeRequest
    case getAuthTokenRequest(String)
	case getMe
    
    var scheme: HTTPScheme {
        switch self {
        @unknown default:
            return .https
        }
    }
    var baseURL: String {
        switch self {
        case .getAuthorizationCodeRequest:
            return "unsplash.com"
        case .getAuthTokenRequest:
            return "unsplash.com"
		case .getMe:
			return "api.unsplash.com"
        }
    }
    var path: String {
        switch self {
        case .getAuthorizationCodeRequest:
            return "/oauth/authorize"
        case .getAuthTokenRequest:
            return "/oauth/token"
		case .getMe:
			return "/me"
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case .getAuthorizationCodeRequest:
            return [
                URLQueryItem(name: "client_id", value: .key(.accessKey)),
                URLQueryItem(name: "redirect_uri", value: .key(.redirectURI)),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: .key(.accessScope))
            ]
        case .getAuthTokenRequest(let authCode):
            return [
                URLQueryItem(name: "client_id", value: .key(.accessKey)),
                URLQueryItem(name: "client_secret", value: .key(.secretKey)),
                URLQueryItem(name: "redirect_uri", value: .key(.redirectURI)),
                URLQueryItem(name: "code", value: authCode),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
		case .getMe:
			return nil
        }
    }
}
