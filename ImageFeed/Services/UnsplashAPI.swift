//
//  UnsplashAPI.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 05.02.2023.
//

import Foundation

enum Constant: String {
	case accessKey = "c8SI91LkiH6yY5SDWDKLtjNOYdgPaKAEwmD2dWs35eU"
	case secretKey = "qg_ghS6ZMMDJP1aU1oiC6Bts3KTDKBt03G28yhrTMrM"
	case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
	case accessScope = "public+read_user+write_likes"
	case grantType = "authorization_code"
	case responseType = "code"
}

extension String {
	static func key(_ constant: Constant) -> Self { constant.rawValue }
}

enum OrderBy: String {
	case latest
	case oldest
	case popular
}

enum UnsplashAPI: API {
	
	case getAuthorizationCodeRequest
	case getAuthTokenRequest(String)
	case getMe
	case getPublicUser(String)
	case getListPhotos(Int,Int,OrderBy)
	
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
		case .getPublicUser:
			return "api.unsplash.com"
		case .getListPhotos:
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
		case .getPublicUser(let username):
			return "/users/\(username)"
		case .getListPhotos:
			return "/photos"
		}
	}
	var parameters: [URLQueryItem]? {
		switch self {
		case .getAuthorizationCodeRequest:
			return [
				URLQueryItem(name: "client_id", value: .key(.accessKey)),
				URLQueryItem(name: "redirect_uri", value: .key(.redirectURI)),
				URLQueryItem(name: "response_type", value: .key(.responseType)),
				URLQueryItem(name: "scope", value: .key(.accessScope))
			]
		case .getAuthTokenRequest(let authCode):
			return [
				URLQueryItem(name: "client_id", value: .key(.accessKey)),
				URLQueryItem(name: "client_secret", value: .key(.secretKey)),
				URLQueryItem(name: "redirect_uri", value: .key(.redirectURI)),
				URLQueryItem(name: "code", value: authCode),
				URLQueryItem(name: "grant_type", value: .key(.grantType))
			]
		case .getMe:
			return nil
		case .getPublicUser:
			return nil
		case let .getListPhotos(page, perPage, orderBy):
			return [
				URLQueryItem(name: "page", value: "\(page)"),
				URLQueryItem(name: "per_page", value: "\(perPage)"),
				URLQueryItem(name: "order_by", value: orderBy.rawValue)
			]
		}
	}
}
