//
//  MainRouting.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

protocol MainRouting: AnyObject {
    typealias Factory = ModuleFactory
    var view: UIViewController? { get set}
    var factory: Factory { get }
    
    func navigate(_ route: ModuleRoutes)
    func exit()
}

extension MainRouting {
    func navigate(_ route: ModuleRoutes) {
        let vc = route.getModule(factory: factory)
        view?.present(vc, animated: true)
    }
    func exit() {
        view?.dismiss(animated: true)
    }
}

enum ModuleRoutes {
    case toAuth
    case toWebView(IWebViewModuleOutput)
    case toMainModule
    case toImageList
    case toSingleImage(Picture)
    case toProfile
    
    func getModule(factory: ModuleFactory) -> UIViewController {
        switch self {
        case .toAuth:
            return factory.makeAuthModule()
        case .toWebView(let moduleOutput):
            return factory.makeWebViewModule(moduleOutput)
        case .toMainModule:
            return factory.makeTabBarModule()
        case .toImageList:
            return factory.makeImagesListModule()
        case .toSingleImage(let picture):
            return factory.makeSingleImageModule(picture)
        case .toProfile:
            return factory.makeProfileModule()
        }
    }
}
