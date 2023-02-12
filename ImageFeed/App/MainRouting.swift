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
    case toAuth(String)
    case toWebView
    case toMainModule
    case toImageList
    case toSingleImage(Picture)
    case toProfile
    
    func getModule(factory: ModuleFactory) -> Module {
        switch self {
        case .toAuth(let code):
            return factory.makeAuthModule(code)
        case .toWebView:
            return factory.makeWebViewModule()
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
