//
//  ImagesListRouter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

final class ImagesListRouter: IImagesListRouter {
    private(set) var factory: Factory = DependencyContainer()
    weak var view: UIViewController?
}
