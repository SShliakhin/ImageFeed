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
        
        window.rootViewController = makeProfileModule()
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func makeImagesListModule() -> UIViewController {
        let adapter = ImagesListTableViewAdapter(dataSet: ImagesListData())
        adapter.onSelect = { picture in
            print(picture)
        }
        let viewController = ImagesListViewController(adapter: adapter)
        return viewController
    }
    
    private func makeProfileModule() -> UIViewController {
        let mockData = Profile.mockProfile
        let viewController = ProfileViewController(with: mockData)
        return viewController
    }
}
