//
//  DependencyContainer.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

protocol ModuleFactory {
    func makeAuthModule() -> UIViewController
    func makeWebViewModule(_ moduleOutput: IWebViewModuleOutput?) -> UIViewController
    func makeTabBarModule() -> UIViewController
    func makeImagesListModule() -> UIViewController
    func makeSingleImageModule(_ picture: Picture) -> UIViewController
    func makeProfileModule() -> UIViewController
}

protocol LoaderFactory {
    func makePicturesLoader() -> PicturesLoading
    func makeProfileLoader() -> ProfileLoading
}

final class DependencyContainer {
    func makeRootViewController() -> UIViewController {
        makeAuthModule()
    }
}

// MARK: - ModuleFactory
extension DependencyContainer: ModuleFactory {
    func makeWebViewModule(_ moduleOutput: IWebViewModuleOutput?) -> UIViewController {
        let view = WebViewViewController()
        view.moduleOutput = moduleOutput
        view.modalPresentationStyle = .fullScreen
        return view
    }

    func makeAuthModule() -> UIViewController {
        let router = AuthRouter()
        let presenter = AuthPresenter(router: router)
        let view = AuthViewController(presenter: presenter)
        
        presenter.view = view
        router.view = view
        return view
    }
    
    func makeTabBarModule() -> UIViewController {
        let viewController = TabBarController()
        let imagesList = makeImagesListModule()
        imagesList.tabBarItem = .init(
            title: "",
            image: Theme.image(kind: .tabListIcon),
            tag: 0
        )
        let profile = makeProfileModule()
        profile.tabBarItem = .init(
            title: "",
            image: Theme.image(kind: .tabProfileIcon),
            tag: 1
        )
        viewController.viewControllers = [imagesList, profile]
        return viewController
    }
    
    func makeImagesListModule() -> UIViewController {
        let router = ImagesListRouter()
        let interactor = ImagesListInteractor(picturesLoader: makePicturesLoader())
        let presenter = ImagesListPresenter(interactor: interactor, router: router)
        let view = ImagesListViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.view = view
        router.view = view
        return view
    }
    
    func makeSingleImageModule(_ picture: Picture) -> UIViewController {
        let router = SingleImageRouter()
        let interactor = SingleImageInteractor()
        let presenter = SingleImagePresenter(interactor: interactor, router: router)
        let view = SingleImageViewController(presenter: presenter, picture: picture)
        
        view.modalPresentationStyle = .fullScreen
        
        interactor.output = presenter
        presenter.view = view
        router.view = view
        return view
    }
    
    func makeProfileModule() -> UIViewController {
        let router = ProfileRouter()
        let interactor = ProfileInteractor(profileLoader: makeProfileLoader())
        let presenter = ProfilePresenter(interactor: interactor, router: router)
        let view = ProfileViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.view = view
        router.view = view
        return view
    }
}

// MARK: - LoaderFactory
extension DependencyContainer: LoaderFactory {
    func makePicturesLoader() -> PicturesLoading {
        PicturesLoader()
    }
    
    func makeProfileLoader() -> ProfileLoading {
        ProfileLoader()
    }
}
