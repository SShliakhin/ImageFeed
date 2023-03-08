//
//  DependencyContainer.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit
import SwiftKeychainWrapper

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
	func makeTabBarModule(_ profile: ProfileResult) -> Module
	func makeImagesListModule() -> Module
	func makeSingleImageModule(_ picture: Picture) -> Module
	func makeProfileModule(_ profile: ProfileResult) -> Module
}

protocol IStartModuleDependency {
	var storage: ITokenStorage { get }
	var profileLoader: IProfileService { get }
	var profilePictureURLLoader: IProfileImageURLService { get }
}

protocol IAuthModuleDependency {
	var storage: ITokenStorage { get }
	var oauth2TokenLoader: IOAuth2Service { get }
}

protocol IImagesListModuleDependency {
}

protocol IProfileModuleDependency {
	var storage: ITokenStorage { get }
	var profilePictureURLLoader: IProfileImageURLService { get }
	var notificationCenter: NotificationCenter { get }
}

typealias AllDependencies = (IStartModuleDependency & IAuthModuleDependency & IImagesListModuleDependency & IProfileModuleDependency)

protocol LoaderFactory {
	func makePicturesLoader() -> PicturesLoading
}

protocol ServicesFactory {
	func makeTokenStorage(_ storage: UserDefaults) -> ITokenStorage
	func makeTokenStorage(_ storage: KeychainWrapper) -> ITokenStorage
	func makeNetworkService() -> APIClient
	func makeProfileService(apiClient: APIClient) -> IProfileService
	func makeProfileImageURLService(
		apiClient: APIClient,
		notificationCenter: NotificationCenter
	) -> IProfileImageURLService
	func makeOAuth2Service(apiClient: APIClient) -> IOAuth2Service
}

final class DependencyContainer {
	private let notificationCenter: NotificationCenter
	private let session: URLSession
	private let storage: KeychainWrapper
	private let rootVC: IRootViewController
	private var dependencies: AllDependencies!
	
	public init(
		rootVC: IRootViewController,
		notificationCenter: NotificationCenter = .default,
		configuration: URLSessionConfiguration = .default,
		storage: KeychainWrapper = .standard
	) {
		self.rootVC = rootVC
		self.notificationCenter = notificationCenter
		self.session = URLSession(configuration: configuration)
		self.storage = storage
		
		let apiClient = makeNetworkService()
		
		dependencies = Dependency(
			storage: makeTokenStorage(storage),
			profileLoader: makeProfileService(apiClient: apiClient),
			oauth2TokenLoader: makeOAuth2Service(apiClient: apiClient),
			profilePictureURLLoader: makeProfileImageURLService(
				apiClient: apiClient,
				notificationCenter: notificationCenter
			),
			notificationCenter: notificationCenter
		)
	}
	
	struct Dependency: AllDependencies {
		let storage: ITokenStorage
		let profileLoader: IProfileService
		let oauth2TokenLoader: IOAuth2Service
		let profilePictureURLLoader: IProfileImageURLService
		let notificationCenter: NotificationCenter
	}
}

// MARK: - ModuleFactory

extension DependencyContainer: ModuleFactory {
	func makeStartModule() -> Module {
		let interactor = SplashInteractor(dep: dependencies)
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
		let interactor = AuthInteractor(dep: dependencies)
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
	
	func makeTabBarModule(_ profile: ProfileResult) -> Module {
		let view = TabBarController()
		let imagesList = makeImagesListModule()
		imagesList.vc.tabBarItem = .init(
			title: "",
			image: Theme.image(kind: .tabListIcon),
			tag: 0
		)
		let profile = makeProfileModule(profile)
		profile.vc.tabBarItem = .init(
			title: "",
			image: Theme.image(kind: .tabProfileIcon),
			tag: 1
		)
		view.viewControllers = [imagesList.vc, profile.vc]
		return .init(vc: view)
	}
	
	func makeImagesListModule() -> Module {
		let interactor = ImagesListInteractor(picturesLoader: makePicturesLoader())
		let router = ImagesListRouter()
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
		let interactor = SingleImageInteractor()
		let router = SingleImageRouter()
		let presenter = SingleImagePresenter(interactor: interactor, router: router)
		let view = SingleImageViewController(presenter: presenter, picture: picture)
		
		view.modalPresentationStyle = .fullScreen
		
		interactor.output = presenter
		presenter.view = view
		router.view = rootVC
		return .init(vc: view)
	}
	
	func makeProfileModule(_ profile: ProfileResult) -> Module {
		let interactor = ProfileInteractor(dep: dependencies)
		let router = ProfileRouter()
		let presenter = ProfilePresenter(interactor: interactor, router: router, profile: profile)
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
}

// MARK: - ServicesFactory

extension DependencyContainer: ServicesFactory {
	func makeTokenStorage(_ storage: KeychainWrapper) -> ITokenStorage {
		OAuth2TokenStorage.init(keychainWrapper: storage)
	}
	
	func makeTokenStorage(_ storage: UserDefaults) -> ITokenStorage {
		TokenStorage.init(userDefaults: storage)
	}
	
	func makeNetworkService() -> APIClient {
		APIClient(session: session)
	}
	
	func makeOAuth2Service(apiClient: APIClient) -> IOAuth2Service {
		OAuth2Service(network: apiClient)
	}
	
	func makeProfileService(apiClient: APIClient) -> IProfileService {
		ProfileService(network: apiClient)
	}
	
	func makeProfileImageURLService(
		apiClient: APIClient,
		notificationCenter: NotificationCenter
	) -> IProfileImageURLService {
		ProfileImageURLService(
			network: apiClient,
			notificationCenter: notificationCenter
		)
	}
}
