//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by SERGEY SHLYAKHIN on 21.03.2023.
//

import XCTest
@testable import ImageFeed

// swiftlint:disable implicitly_unwrapped_optional force_unwrapping

final class ImagesListTests: XCTestCase {
	// 1. проверить первичную загрузку картинок - когда открывается модуль
	// - interactor.fetchPhotos() или imagesListService.fetchPhotosNextPage()
	// + вызов view.reloadTableView()
	// 2. проверить подгрузку картинок - адаптер вызывает presenter.didDisplayLastPhoto()
	// + вызов view.addRowsToTableView()
	// 3. проверить лайк на картинку
	// - выбрать случайную картинку presenter.getPhoto().randomElement() - запоминаем текущий лайк
	// - и presenter.didChangeLikeStatusOf(photo: photo) - запоминаем новый лайк
	// + вызов view.updateRowByIndex()
	// 4. переход на экран с полноразмерной картинкой
	// - выбор случайной картинки presenter.getPhoto().randomElement()
	// - и present.didSelectPhoto() - проверка вызова router.present()
	// Надо:
	// - viewSpy -
	// - routerSpy
	// - ImagesListServiceStub
	// - interactor
	// - presenter
	// 5. Можно еще проверить установку токена в сервис: ImagesListServiceStub.setToken()

	private var viewSpy: ImagesListViewControllerSpy!
	private var routerSpy: ImagesListRouterSpy!
	private var imagesListServiceStub: ImagesListServiceStub!

	struct Dependency: IImagesListModuleDependency {
		var imagesListPageLoader: IImagesListService
		var notificationCenter: NotificationCenter
	}

	private var dep: Dependency!

	override func setUp() {
		super.setUp()

		viewSpy = ImagesListViewControllerSpy()
		routerSpy = ImagesListRouterSpy()
		imagesListServiceStub = ImagesListServiceStub(notificationCenter: .default)
		dep = Dependency(
			imagesListPageLoader: imagesListServiceStub,
			notificationCenter: .default
		)
	}

	override func tearDown() {
		viewSpy = nil
		routerSpy = nil
		imagesListServiceStub = nil
		dep = nil

		super.tearDown()
	}

	// тестируем первичную загрузку фото
	func test_serviceFetchPhotosNextPage_shouldBeFivePhotos() {
		// arrange
		let (_, presenter) = makeArrangeComponents(presenterIsReady: false)

		let sut = imagesListServiceStub!
		sut.presenterIsReady = true

		// act
		sut.fetchPhotosNextPage()

		// assert
		XCTAssertEqual(presenter.getPhotos().count, 5, "Количество фото не равно 5")
		XCTAssertTrue(viewSpy.reloadTableViewCalled, "Не был вызван метод вью reloadTableView()")
	}

	// тестируем подгрузку фото
	func test_presenterDidDisplayLastPhoto_shouldBeTenPhotos() {
		// arrange
		let (_, presenter) = makeArrangeComponents(presenterIsReady: true)

		let sut = presenter

		// act
		sut.didDisplayLastPhoto()

		// assert
		XCTAssertEqual(presenter.getPhotos().count, 10, "Количество фото не равно 10")
		XCTAssertTrue(viewSpy.addRowsToTableViewCalled, "Не был вызван метод вью addRowsToTableView()")
	}

	// тестируем лайк на фото
	func test_presenterDidChangeLikeStatusOf_shouldBeDifferenceBetweenLikeStatus() {
		// arrange
		let (_, presenter) = makeArrangeComponents(presenterIsReady: true)
		let photo = presenter.getPhotos().randomElement()
		let status = photo?.isLiked
		let idPhoto = photo?.id

		let sut = presenter

		// act
		sut.didChangeLikeStatusOf(photo: photo!)

		var newStatus = status
		let photos = presenter.getPhotos()
		if let photo = photos.first(where: { $0.id == idPhoto }) {
			newStatus = photo.isLiked
		}

		// assert
		XCTAssertNotEqual(status, newStatus, "Состояния между лайками равны")
		XCTAssertTrue(viewSpy.updateRowByIndexCalled, "Не был вызван метод вью updateRowByIndex()")
	}

	// тестируем переход на другой экран
	func test_presenterDidSelectPhoto_shouldBeCallsRouterPresent() {
		// arrange
		let (_, presenter) = makeArrangeComponents(presenterIsReady: true)
		let photo = presenter.getPhotos().randomElement()

		let sut = presenter

		// act
		sut.didSelectPhoto(photo!)

		// assert
		XCTAssertTrue(routerSpy.presentCalled, "Не был вызван метод router present()")
	}
}

// MARK: - Private methods

private extension ImagesListTests {
	func makeArrangeComponents(presenterIsReady: Bool) -> (ImagesListInteractor, ImagesListPresenter) {
		let interactor = ImagesListInteractor(dep: dep)
		let presenter = ImagesListPresenter(interactor: interactor, router: routerSpy)
		interactor.output = presenter
		presenter.view = viewSpy

		imagesListServiceStub.presenterIsReady = presenterIsReady
		imagesListServiceStub.fetchPhotosNextPage()
		return (interactor, presenter)
	}
}

// MARK: - ImagesListViewControllerSpy

final class ImagesListViewControllerSpy: IImagesListViewInput {
	private(set) var reloadTableViewCalled = false
	private(set) var addRowsToTableViewCalled = false
	private(set) var updateRowByIndexCalled = false

	func reloadTableView() {
		reloadTableViewCalled = true
	}

	func addRowsToTableView(indexPaths: [IndexPath]) {
		addRowsToTableViewCalled = true
	}

	func updateRowByIndex(_ index: Int) {
		updateRowByIndexCalled = true
	}
}

// MARK: - ImagesListRouterSpy

final class ImagesListRouterSpy: IImagesListRouter {
	var view: IRootViewController?
	private(set) var presentCalled = false
	private(set) var photo: Photo?

	func present(_ route: ModuleRoute) {
		presentCalled = true
		if case .toSingleImage(let photo) = route {
			self.photo = photo
		}
	}
}

// MARK: - ImagesListServiceStub

final class ImagesListServiceStub: IImagesListService {
	private let notificationCenter: NotificationCenter
	private(set) var bearerToken: String?
	private var lastLoadedPage = 0
	private let photosPerPage = 5

	var presenterIsReady = false

	var photos: [Photo] = [] {
		didSet {
			notificationCenter.post(name: didChangeNotification, object: self)
		}
	}

	init(notificationCenter: NotificationCenter) {
		self.notificationCenter = notificationCenter
	}

	func fetchPhotosNextPage() {
		guard presenterIsReady else { return }

		var allPhotos = lastLoadedPage * photosPerPage
		var allPhotosPlusPage = allPhotos + photosPerPage
		if allPhotosPlusPage > Photo.stubPhotos.count {
			lastLoadedPage = 0
			allPhotos = 0
			allPhotosPlusPage = photosPerPage
		}
		let newPhotos = Photo.stubPhotos[allPhotos ..< allPhotosPlusPage]

		photos += newPhotos
		lastLoadedPage += 1
	}

	func setToken(_ bearerToken: String) {
		self.bearerToken = bearerToken
	}

	func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, APIError>) -> Void) {
		if let index = photos.firstIndex(where: { $0.id == photoId }) {
			photos[index].isLiked = isLike
			completion(.success(isLike))
		} else {
			completion(.failure(.errorMessage("Не смогли установить лайк")))
		}
	}
}
