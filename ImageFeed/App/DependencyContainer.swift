//
//  DependencyContainer.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

protocol ModuleFactory {
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
        makeTabBarModule()
    }
}

// MARK: - ModuleFactory
extension DependencyContainer: ModuleFactory {
    
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
        let viewController = ImagesListViewController(picturesLoader: PicturesLoader())
        viewController.onSelect = { [weak viewController] picture  in
            guard let overVC = viewController else { return }
            let vc = self.makeSingleImageModule(picture)
            overVC.present(vc, animated: true)
        }
        return viewController
    }
    
    func makeSingleImageModule(_ picture: Picture) -> UIViewController {
        let viewController = SingleImageViewController(picture: picture)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
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
