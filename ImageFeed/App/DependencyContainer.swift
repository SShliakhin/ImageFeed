//
//  DependencyContainer.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

enum AnimatedTransitionType {
    case none
    case fade
    case dismiss
}

struct Module {
    let vc: UIViewController
    var animatedType: AnimatedTransitionType = .none
    var completion: (() -> Void)? = nil
}

protocol ModuleFactory: AnyObject {
    func makeStartModule() -> Module
    func makeAuthModule(_ code: String) -> Module
    func makeWebViewModule() -> Module
    func makeTabBarModule() -> Module
    func makeImagesListModule() -> Module
    func makeSingleImageModule(_ picture: Picture) -> Module
    func makeProfileModule() -> Module
}

protocol LoaderFactory {
    func makePicturesLoader() -> PicturesLoading
    func makeProfileLoader() -> ProfileLoading
}

protocol LoginServicesFactory {
    func makeTokenStorage(_ storage: UserDefaults) -> ITokenStorage
    func makeNetworkService() -> APIClient
}

final class DependencyContainer {
    private let session: URLSession
    private let storage: UserDefaults
    private let rootVC: IRootViewController
    
    public init(
        rootVC: IRootViewController,
        configuration: URLSessionConfiguration = .default,
        storage: UserDefaults = UserDefaults.standard
    ) {
        self.rootVC = rootVC
        self.session = URLSession(configuration: configuration)
        self.storage = storage
    }
}

// MARK: - ModuleFactory
extension DependencyContainer: ModuleFactory {
    func makeStartModule() -> Module {
        let storage = makeTokenStorage(storage)
        
        let interactor = SplashInteractor(storage: storage)
        let router = SplashRouter()
        let presenter = SplashPresenter(interactor: interactor, router: router)
        let view = SplashViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.view = view
        router.view = rootVC
        return .init(vc: view)
    }
    
    func makeWebViewModule() -> Module {
        let router = WebViewRouter()
        let presenter = WebViewPresenter(router: router)
        let view = WebViewViewController(presenter: presenter)
        
        view.modalPresentationStyle = .fullScreen
        
        presenter.view = view
        router.view = rootVC
        return .init(vc: view)
    }

    func makeAuthModule(_ code: String) -> Module {
        let storage = makeTokenStorage(storage)
        let network = makeNetworkService()
        
        let interactor = AuthInteractor(storage: storage, network: network)
        let router = AuthRouter()
        let presenter = AuthPresenter(interactor: interactor, router: router, code: code)
        let view = AuthViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.view = view
        router.view = rootVC
        
        let navigationVC = UINavigationController(rootViewController: view)
        navigationVC.navigationBar.isHidden = true
        return .init(vc: navigationVC)
    }
    
    func makeTabBarModule() -> Module {
        let view = TabBarController()
        let imagesList = makeImagesListModule()
        imagesList.vc.tabBarItem = .init(
            title: "",
            image: Theme.image(kind: .tabListIcon),
            tag: 0
        )
        let profile = makeProfileModule()
        profile.vc.tabBarItem = .init(
            title: "",
            image: Theme.image(kind: .tabProfileIcon),
            tag: 1
        )
        view.viewControllers = [imagesList.vc, profile.vc]
        return .init(vc: view)
    }
    
    func makeImagesListModule() -> Module {
        let router = ImagesListRouter()
        let interactor = ImagesListInteractor(picturesLoader: makePicturesLoader())
        let presenter = ImagesListPresenter(interactor: interactor, router: router)
        let view = ImagesListViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.view = view
        router.view = rootVC
        
        let navigationVC = UINavigationController(rootViewController: view)
        navigationVC.navigationBar.isHidden = true
        return .init(vc: navigationVC)
    }
    
    func makeSingleImageModule(_ picture: Picture) -> Module {
        let router = SingleImageRouter()
        let interactor = SingleImageInteractor()
        let presenter = SingleImagePresenter(interactor: interactor, router: router)
        let view = SingleImageViewController(presenter: presenter, picture: picture)
        
        view.modalPresentationStyle = .fullScreen
        
        interactor.output = presenter
        presenter.view = view
        router.view = rootVC
        return .init(vc: view)
    }
    
    func makeProfileModule() -> Module {
        let storage = makeTokenStorage(storage)
        
        let router = ProfileRouter()
        let interactor = ProfileInteractor(profileLoader: makeProfileLoader(), storage: storage)
        let presenter = ProfilePresenter(interactor: interactor, router: router)
        let view = ProfileViewController(presenter: presenter)
        
        interactor.output = presenter
        presenter.view = view
        router.view = rootVC
        return .init(vc: view)
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

// MARK: - LoginServicesFactory
extension DependencyContainer: LoginServicesFactory {
    func makeNetworkService() -> APIClient {
        return APIClient(session: session)
    }
    
    func makeTokenStorage(_ storage: UserDefaults) -> ITokenStorage {
        TokenStorage.init(userDefaults: storage)
    }
}
