//
//  AuthRouter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 02.02.2023.
//

import UIKit

final class AuthRouter: IAuthRouter {
    private(set) var factory: Factory = DependencyContainer()
    weak var view: UIViewController?
}
