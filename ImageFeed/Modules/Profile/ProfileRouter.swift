//
//  ProfileRouter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

final class ProfileRouter: IProfileRouter {
    private(set) var factory: Factory = DependencyContainer()
    weak var view: UIViewController?
}
