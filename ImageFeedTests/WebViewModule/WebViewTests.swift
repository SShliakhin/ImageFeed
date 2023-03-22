//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by SERGEY SHLYAKHIN on 20.03.2023.
//

import XCTest
@testable import ImageFeed

// swiftlint:disable implicitly_unwrapped_optional force_unwrapping

final class WebViewTests: XCTestCase {

	private var viewSpy: WebViewViewControllerSpy!
	private var presenterSpy: WebViewPresenterSpy!
	private var interactorDummy: WebViewInteractorDummy!
	private var routerDummy: WebViewRouterDummy!

	override func setUp() {
		super.setUp()

		viewSpy = WebViewViewControllerSpy()
		presenterSpy = WebViewPresenterSpy()
		interactorDummy = WebViewInteractorDummy()
		routerDummy = WebViewRouterDummy()
	}

	override func tearDown() {
		viewSpy = nil
		presenterSpy = nil
		interactorDummy = nil
		routerDummy = nil

		super.tearDown()
	}

	// тестируем вызов метода viewDidLoad презентера
	func test_viewCallsPresenterViewDidLoad_shouldBeSuccess() {
		// arrange
		let sut = WebViewViewController(presenter: presenterSpy)

		// act
		_ = sut.view

		// assert
		XCTAssertTrue(presenterSpy.viewDidLoadCalled, "Метод презентера viewDidload() не вызван")
	}

	// вызывает ли презентер после вызова presenter.viewDidLoad() метод loadRequest вьюконтроллера
	func test_presenterCallsViewLoadRequest_shouldBeSuccess() {
		// arrange
		let sut = WebViewPresenter(interactor: interactorDummy, router: routerDummy)
		sut.view = viewSpy

		// act
		sut.viewDidLoad()

		// assert
		XCTAssertTrue(viewSpy.loadRequestCalled, "Метод вью loadRequest() не вызван")
	}

	// тестируем необходимость скрытия прогресса после вызова presenter.didUpdateProgressValue
	// 1. с параметром меньше 1 метод view.setProgressHidden() не вызывается
	// 2. с парамтером равным 1 метод view.setProgressHidden() вызывается

	func test_presenterCallsViewSetProgressHidden_withProgressLessTheOne_shouldBeFail() {
		// arrange
		let sut = WebViewPresenter(interactor: interactorDummy, router: routerDummy)
		sut.view = viewSpy
		let progress = 0.6

		// act
		sut.didUpdateProgressValue(progress)

		// assert
		XCTAssertFalse(viewSpy.setProgressHiddenCalled, "Метод вью setProgressHiden вызван")
	}

	func test_presenterCallsViewSetProgressHidden_withProgressOne_shouldBeSuccess() {
		// arrange
		let sut = WebViewPresenter(interactor: interactorDummy, router: routerDummy)
		sut.view = viewSpy
		let progress = 1.0

		// act
		sut.didUpdateProgressValue(progress)

		// assert
		XCTAssertTrue(viewSpy.setProgressHiddenCalled, "Метод вью setProgressHiden не вызван")
	}

	// тестируем хелпер
	// 1. получение ссылки авторизации authURL
	// 2. получение кода из URL code(from url: URL)

	func test_helperAuthRequestURL_shouldBeAllComponentsContain() {
		// arrange
		let sut = APIHelper()

		// act
		let url = sut.authRequest().url!
		let urlString = url.absoluteString
		typealias Constants = UnsplashAPI.Constant

		// assert
		XCTAssertTrue(urlString.contains(Constants.authorizeURLString.rawValue), "URL не содержит базовый адрес")
		XCTAssertTrue(urlString.contains(Constants.accessKey.rawValue), "URL не содержит ключ доступа")
		XCTAssertTrue(urlString.contains(Constants.redirectURI.rawValue), "URL не содержит адре редиректа")
		XCTAssertTrue(urlString.contains(Constants.responseType.rawValue), "URL не содержит тип ответа")
		XCTAssertTrue(urlString.contains(Constants.accessScope.rawValue), "URL не содержит набор доступа")
	}

	func test_helperCode_WithMockURLAndCode_shouldBeReturnMockCode() {
		// arrange
		let sut = APIHelper()
		var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
		urlComponents.queryItems = [URLQueryItem(name: "code", value: "123")]
		let url = urlComponents.url!

		// act
		let code = sut.code(from: url)

		// assert
		XCTAssertEqual(code, "123", "Метод не вернул заданный код")
	}
}

// MARK: - WebViewPresenterSpy

final class WebViewPresenterSpy: IWebViewViewOutput {
	private(set) var viewDidLoadCalled = false

	func viewDidLoad() {
		viewDidLoadCalled = true
	}

	func didUpdateProgressValue(_ newValue: Double) {}

	func getAuthCode(from url: URL?) -> String? {
		nil
	}

	func didGetAuthCode(_ code: String) {}

	func didTapBack() {}
}

// MARK: - WebViewViewControllerSpy

final class WebViewViewControllerSpy: IWebViewViewInput {
	private(set) var loadRequestCalled = false
	private(set) var setProgressHiddenCalled = false

	func loadRequest(_ request: URLRequest) {
		loadRequestCalled = true
	}

	func setProgressValue(_ newValue: Float) {}

	func setProgressHidden() {
		setProgressHiddenCalled = true
	}
}

// MARK: - WebViewInteractorDummy

final class WebViewInteractorDummy: IWebViewInteractorInput {
	func getAuthCode(from url: URL) -> String? {
		nil
	}

	func getAuthRequest() -> URLRequest {
		URLRequest(url: URL(string: "www.apple.com")!)
	}
}

// MARK: - WebViewRouterDummy

final class WebViewRouterDummy: IWebViewRouter {
	var view: IRootViewController?
}
