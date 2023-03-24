//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by SERGEY SHLYAKHIN on 21.03.2023.
//

import XCTest
@testable import ImageFeed

// swiftlint:disable implicitly_unwrapped_optional force_unwrapping

final class ProfileTests: XCTestCase {
	private let interactorDummy = ProfileInteractorDummy()
	private let routerDummy = ProfileRouterDummy()

	private let profile = ProfileResult(firstName: nil, lastName: nil, username: nil, bio: nil)

	private var viewSpy: ProfileViewControllerSpy!
	private var profileImageURLServiceStub: ProfileImageURLServiceStub!

	struct Dependency: IProfileModuleDependency {
		var storage: ITokenStorage
		var profilePictureURLLoader: IProfileImageURLService
		var notificationCenter: NotificationCenter
	}

	var dep: Dependency!

	override func setUp() {
		super.setUp()

		let dependencyContainer = DependencyContainer(rootVC: RootViewController())
		viewSpy = ProfileViewControllerSpy()
		profileImageURLServiceStub = ProfileImageURLServiceStub(notificationCenter: .default)
		dep = Dependency(
			storage: dependencyContainer.makeTokenStorage(UserDefaults.standard),
			profilePictureURLLoader: profileImageURLServiceStub,
			notificationCenter: .default
		)
	}

	override func tearDown() {
		viewSpy = nil
		profileImageURLServiceStub = nil
		dep = nil

		super.tearDown()
	}

	// тестируем хранилище на сохранение токена
	func test_tokenStorageSaveTokenSomeToken_shouldBeSuccess() {
		// arrange
		var sut = dep.storage

		// act
		sut.token = "some token"

		// assert
		XCTAssertTrue(sut.token == "some token", "token не равен some token")
	}

	// тестируем хранилище на удаление токена
	func test_tokenStorageRemoveToken_shouldBeSuccess() {
		// arrange
		var sut = dep.storage
		sut.token = "some token"

		// act
		sut.removeToken()

		// assert
		XCTAssertNil(sut.token, "token не удален")
	}

	// тестируем вызов updateAvatarURL после получения URL для аватарки профиля
	func test_serviceURLUpdateCallsViewUpdateAvatarURL_shouldBeSuccess() {
		// arrange
		let interactor = ProfileInteractor(dep: dep)
		let presenter = ProfilePresenter(interactor: interactor, router: routerDummy, profile: profile)
		interactor.output = presenter
		presenter.view = viewSpy

		let sut = profileImageURLServiceStub!

		// act
		sut.profileImageURL = "http://apple.com"

		// assert
		XCTAssertTrue(viewSpy.updateAvatarURLCalled, "Метод вью updateAvatarURL() не вызван")
	}

	func test_transferProfileToViewOnLoad_shouldBeSuccess() {
		// arrange
		let sut = ProfilePresenter(interactor: interactorDummy, router: routerDummy, profile: profile)
		sut.view = viewSpy

		// act
		sut.viewDidLoad()

		// assert
		XCTAssertTrue(viewSpy.showProfileCalled, "Метод вью showProfileL() не вызван")
		XCTAssertEqual(viewSpy.profileViewModel, profile, "Полученный профайл не равен исходному")
	}
}

// MARK: - ProfileViewControllerSpy

final class ProfileViewControllerSpy: IProfileViewInput {
	private(set) var showProfileCalled = false
	private(set) var updateAvatarURLCalled = false
	private(set) var showAlertDialogCalled = false
	private(set) var profileViewModel: ProfileResult?

	func showProfile(profile: ProfileResult) {
		showProfileCalled = true
		profileViewModel = profile
	}

	func updateAvatarURL(_ profileImageURL: URL) {
		updateAvatarURLCalled = true
	}

	func showAlertDialog(_ model: AlertModel) {
		showAlertDialogCalled = true
	}
}

// MARK: - ProfileInteractorDummy

final class ProfileInteractorDummy: IProfileInteractorInput {
	func cleanUpUserData() {}
}

// MARK: - ProfileRouterDummy

final class ProfileRouterDummy: IProfileRouter {
	var view: IRootViewController?
}

// MARK: - ProfileImageURLServiceStub

final class ProfileImageURLServiceStub: IProfileImageURLService {
	private let notificationCenter: NotificationCenter
	var profileImageURL: String? {
		didSet {
			notificationCenter.post(
				name: didChangeNotification,
				object: self,
				userInfo: ["URL": self.profileImageURL as Any]
			)
		}
	}

	init(notificationCenter: NotificationCenter) {
		self.notificationCenter = notificationCenter
	}

	func fetchProfileImageURL(
		username: String,
		bearerToken: String,
		completion: @escaping (Result<String, APIError>) -> Void
	) {
		if let url = profileImageURL {
			completion(.success(url))
		} else {
			completion(.failure(.errorMessage("No image URL")))
		}
	}
}

// MARK: - ProfileServiceStub

final class ProfileServiceStub: IProfileService {
	var profileResult: ProfileResult?

	func fetchProfile(
		bearerToken: String,
		completion: @escaping (Result<ProfileResult, APIError>) -> Void
	) {
		if let profile = profileResult {
			completion(.success(profile))
		} else {
			completion(.failure(.errorMessage("No profile")))
		}
	}
}
