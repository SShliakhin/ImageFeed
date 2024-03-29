//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 21.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	var container: DependencyContainer?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)

		let rootViewController = RootViewController()
		container = DependencyContainer(rootVC: rootViewController)
		rootViewController.factory = container
		rootViewController.start()

		window.rootViewController = rootViewController
		window.makeKeyAndVisible()
		self.window = window
	}
}
