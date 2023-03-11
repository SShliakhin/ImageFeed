//
//  MainRouting.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

protocol MainRouting: AnyObject {
	var view: IRootViewController? { get set}
	
	func navigate(_ route: ModuleRoute)
	func push(_ route: ModuleRoute)
	func present(_ route: ModuleRoute)
}

extension MainRouting {
	func navigate(_ route: ModuleRoute) {
		guard
			let view = view,
			let factory = view.factory
		else { return }
		
		let module = route.getModule(factory: factory)
		view.navigate(to: module)
	}
	
	func push(_ route: ModuleRoute) {
		guard
			let view = view,
			let factory = view.factory
		else { return }
		
		let module = route.getModule(factory: factory)
		view.push(to: module)
	}
	
	func present(_ route: ModuleRoute) {
		guard
			let view = view,
			let factory = view.factory
		else { return }
		
		let module = route.getModule(factory: factory)
		view.present(to: module)
	}
}

enum ModuleRoute {
	case toStart
	case toAuth(String)
	case toWebView
	case toMainModule(ProfileResult)
	case toImageList
	case toSingleImage(Photo)
	case toProfile(ProfileResult)
	
	func getModule(factory: ModuleFactory) -> Module {
		switch self {
		case .toStart:
			return factory.makeStartModule()
		case .toAuth(let code):
			return factory.makeAuthModule(code)
		case .toWebView:
			return factory.makeWebViewModule()
		case .toMainModule(let profile):
			return factory.makeTabBarModule(profile)
		case .toImageList:
			return factory.makeImagesListModule()
		case .toSingleImage(let picture):
			return factory.makeSingleImageModule(picture)
		case .toProfile(let profile):
			return factory.makeProfileModule(profile)
		}
	}
}
