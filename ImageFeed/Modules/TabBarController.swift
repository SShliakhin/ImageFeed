//
//  TabBarController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 13.01.2023.
//

import UIKit

final class TabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()

		setupAppearance()
	}
}

private extension TabBarController {
	func setupAppearance() {
		let appearance = UITabBarAppearance()
		appearance.backgroundColor = Theme.color(usage: .ypBlack)

		tabBar.standardAppearance = appearance
		if #available(iOS 15.0, *) {
			tabBar.scrollEdgeAppearance = appearance
		}

		tabBar.tintColor = Theme.color(usage: .ypWhite)
		tabBar.clipsToBounds = true
	}
}
