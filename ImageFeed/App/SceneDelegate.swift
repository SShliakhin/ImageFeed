//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 21.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = makeTabBarModule()
        window.makeKeyAndVisible()
        self.window = window
    }
}

// TODO: - choose final pattern
private extension SceneDelegate {
    func makeImagesListModule() -> UIViewController {
        let viewController = ImagesListViewController(picturesLoader: PicturesLoader())
        viewController.onSelect = { [weak viewController, weak self] picture  in
            guard
                let overVC = viewController,
                let self = self
            else { return }
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
        let viewController = ProfileViewController(profileLoader: ProfileLoader())
        return viewController
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
}
