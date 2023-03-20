//
//  DependencyContainer.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit
import SwiftKeychainWrapper

// MARK: - Module

enum AnimatedTransitionType {
	case none
	case fade
	case dismiss
}

struct Module {
	let viewController: UIViewController
	var animatedType: AnimatedTransitionType = .none
	var completion: (() -> Void)?
}

protocol ModuleFactory: AnyObject {
	func makeStartModule() -> Module
	func makeAuthModule(_ code: String) -> Module
	func makeWebViewModule() -> Module
	func makeTabBarModule(_ profile: ProfileResult) -> Module
	func makeImagesListModule() -> Module
	func makeSingleImageModule(_ photo: Photo) -> Module
	func makeProfileModule(_ profile: ProfileResult) -> Module
}

// MARK: - Module Dependencies

protocol IStartModuleDependency {
	var storage: ITokenStorage { get }
	var profileLoader: IProfileService { get }
	var profilePictureURLLoader: IProfileImageURLService { get }
	var imagesListPageLoader: IImagesListService { get }
}

protocol IAuthModuleDependency {
	var storage: ITokenStorage { get }
	var oauth2TokenLoader: IOAuth2Service { get }
}

protocol IImagesListModuleDependency {
	var imagesListPageLoader: IImagesListService { get }
	var notificationCenter: NotificationCenter { get }
}

protocol IProfileModuleDependency {
	var storage: ITokenStorage { get }
	var profilePictureURLLoader: IProfileImageURLService { get }
	var notificationCenter: NotificationCenter { get }
}

protocol ISingleImageModuleDependency {
	var singleImageDataLoader: ISingleImageService { get }
}

typealias AllDependencies = (
	IStartModuleDependency &
	IAuthModuleDependency &
	IImagesListModuleDependency &
	IProfileModuleDependency &
	ISingleImageModuleDependency
)

// MARK: - Services

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
	func makeImagesListService(
		apiClient: APIClient,
		notificationCenter: NotificationCenter
	) -> IImagesListService
	func makeSingleImageService(apiClient: APIClient) -> ISingleImageService
}

// MARK: - Dependency container

final class DependencyContainer {
	private let notificationCenter: NotificationCenter
	private let session: URLSession
	private let storage: KeychainWrapper
	private let rootVC: IRootViewController
	private var dependencies: AllDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

	init(
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
			imagesListPageLoader: makeImagesListService(
				apiClient: apiClient,
				notificationCenter: notificationCenter
			),
			singleImageDataLoader: makeSingleImageService(apiClient: apiClient),
			notificationCenter: notificationCenter
		)
	}

	struct Dependency: AllDependencies {
		let storage: ITokenStorage
		let profileLoader: IProfileService
		let oauth2TokenLoader: IOAuth2Service
		let profilePictureURLLoader: IProfileImageURLService
		let imagesListPageLoader: IImagesListService
		let singleImageDataLoader: ISingleImageService
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
		return .init(viewController: view)
	}

	func makeWebViewModule() -> Module {
		let router = WebViewRouter()
		let presenter = WebViewPresenter(router: router)
		let view = WebViewViewController(presenter: presenter)

		view.modalPresentationStyle = .fullScreen

		presenter.view = view
		router.view = rootVC
		return .init(viewController: view)
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
		return .init(viewController: navigationVC)
	}

	func makeTabBarModule(_ profile: ProfileResult) -> Module {
		let view = TabBarController()
		let imagesList = makeImagesListModule()
		imagesList.viewController.tabBarItem = .init(
			title: "",
			image: Theme.image(kind: .tabListIcon),
			tag: 0
		)
		let profile = makeProfileModule(profile)
		profile.viewController.tabBarItem = .init(
			title: "",
			image: Theme.image(kind: .tabProfileIcon),
			tag: 1
		)
		view.viewControllers = [imagesList.viewController, profile.viewController]
		return .init(viewController: view)
	}

	func makeImagesListModule() -> Module {
		let interactor = ImagesListInteractor(dep: dependencies)
		let router = ImagesListRouter()
		let presenter = ImagesListPresenter(interactor: interactor, router: router)
		let adapter = ImagesListTableViewAdapter(presenter: presenter)
		let view = ImagesListViewController(presenter: presenter, adapter: adapter)

		interactor.output = presenter
		presenter.view = view
		router.view = rootVC

		let navigationVC = UINavigationController(rootViewController: view)
		navigationVC.navigationBar.isHidden = true
		return .init(viewController: navigationVC)
	}

	func makeSingleImageModule(_ photo: Photo) -> Module {
		let interactor = SingleImageInteractor(dep: dependencies)
		let router = SingleImageRouter()
		let presenter = SingleImagePresenter(interactor: interactor, router: router, photo: photo)
		let view = SingleImageViewController(presenter: presenter)

		view.modalPresentationStyle = .fullScreen

		interactor.output = presenter
		presenter.view = view
		router.view = rootVC
		return .init(viewController: view)
	}

	func makeProfileModule(_ profile: ProfileResult) -> Module {
		let interactor = ProfileInteractor(dep: dependencies)
		let router = ProfileRouter()
		let presenter = ProfilePresenter(interactor: interactor, router: router, profile: profile)
		let view = ProfileViewController(presenter: presenter)

		interactor.output = presenter
		presenter.view = view
		router.view = rootVC
		return .init(viewController: view)
	}
}

// MARK: - ServicesFactory

extension DependencyContainer: ServicesFactory {
	func makeTokenStorage(_ storage: KeychainWrapper) -> ITokenStorage {
		OAuth2TokenStorage(keychainWrapper: storage)
	}

	func makeTokenStorage(_ storage: UserDefaults) -> ITokenStorage {
		TokenStorage(userDefaults: storage)
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

	func makeImagesListService(
		apiClient: APIClient,
		notificationCenter: NotificationCenter
	) -> IImagesListService {
		ImagesListService(
			network: apiClient,
			notificationCenter: notificationCenter,
			photosPerPage: 10,
			orderBy: OrderBy.latest
		)
	}

	func makeSingleImageService(apiClient: APIClient) -> ISingleImageService {
		SingleImageService(network: apiClient)
	}
}
