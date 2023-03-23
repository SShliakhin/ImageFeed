//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by SERGEY SHLYAKHIN on 23.03.2023.
//

import XCTest

// swiftlint:disable overridden_super_cal line_length comment_spacing

final class Image_FeedUITests: XCTestCase {
	private let app = XCUIApplication() // переменная приложения

	override func setUpWithError() throws {
		continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так

		app.launch() // запускаем приложение перед каждым тестом
	}

	func testAuth() throws {
		// тестируем сценарий авторизации

		// Нажать кнопку авторизации
		// Подождать, пока экран авторизации открывается и загружается
		// Ввести данные в форму
		// Нажать кнопку логина
		// Подождать, пока открывается экран ленты

		// 1. Нажать кнопку авторизации
		/*
		 У приложения мы получаем список кнопок на экране и получаем нужную кнопку по тексту на ней
		 Далее вызываем функцию tap() для нажатия на этот элемент
		 Идентификатор кнопки "Authenticate" создается при создании кнопки:

		 button.accessibilityIdentifier = "Authenticate"
		 */
		let loginButton = app.buttons.firstMatch
		XCTAssertTrue(loginButton.waitForExistence(timeout: Appearance.timeOut), "кнопка авторизации не найдена")
		XCTAssertTrue(loginButton.firstMatch.label == "Войти", "найдена не та кнопка")
		loginButton.tap()

		// 2. Подождать, пока экран авторизации открывается и загружается
		let webView = app.webViews.firstMatch
		XCTAssertTrue(webView.waitForExistence(timeout: Appearance.timeOut), "web страница не найдена")

		// 3. Ввести данные в форму
		let loginTextField = webView.descendants(matching: .textField).element
		XCTAssertTrue(loginTextField.waitForExistence(timeout: Appearance.timeOut), "текстовое поле ввода логина не найдено")
		loginTextField.tap()
		loginTextField.typeText(Appearance.login) // введёт текст в поле ввода
		webView.swipeUp() // поможет скрыть клавиатуру после ввода текста (необязательно, но иногда требуется для прохождения теста)
		sleep(Appearance.sleep)
		webView.tap() // не всегда получается соскочить с поля логин - так вроде помогает
		sleep(Appearance.sleep)

		let passwordTextField = webView.descendants(matching: .secureTextField).element
		XCTAssertTrue(passwordTextField.waitForExistence(timeout: Appearance.timeOut), "текстовое поле ввода пароля не найдено")
		passwordTextField.tap()
		passwordTextField.typeText(Appearance.password)
		webView.swipeUp()
		sleep(Appearance.sleep)

		// 4. Нажать кнопку логина
		let login = webView.buttons["Login"]
		XCTAssertTrue(login.waitForExistence(timeout: Appearance.timeOut), "кнопка логина не найдена")
		login.tap()

		// 5. Подождать, пока открывается экран ленты
		let table = app.tables.firstMatch
		XCTAssertTrue(table.waitForExistence(timeout: Appearance.timeOut), "таблица не найдена")
	}

	func testFeed() throws {
		// тестируем сценарий ленты

		// Подождать, пока открывается и загружается экран ленты
		// Сделать жест «смахивания» вверх по экрану для его скролла
		// Поставить лайк в ячейке верхней картинки
		// Отменить лайк в ячейке верхней картинки
		// Нажать на верхнюю ячейку
		// Подождать, пока картинка открывается на весь экран
		// Увеличить картинку
		// Уменьшить картинку
		// Вернуться на экран ленты

		// 1. Подождать, пока открывается и загружается экран ленты
		//let table = app.tables["tableView"] // вернёт таблицы на экран
		let table = app.tables.firstMatch
		XCTAssertTrue(table.waitForExistence(timeout: Appearance.timeOut), "таблица не найдена")
		let cell = table.children(matching: .cell).element(boundBy: 0) // вернёт ячейку по индексу 0
		XCTAssertTrue(cell.waitForExistence(timeout: Appearance.timeOut), "ячейка не найдена")

		// 2. Сделать жест «смахивания» вверх по экрану для его скролла
		table.swipeUp()
		sleep(Appearance.sleep)
		table.swipeDown()
		sleep(Appearance.sleep)

		// 3. Поставить лайк в ячейке верхней картинки
		let cellToLike = table.children(matching: .cell).element(boundBy: 1)
		XCTAssertTrue(cellToLike.waitForExistence(timeout: Appearance.timeOut), "ячейка не найдена")

		let likeButton = cellToLike.children(matching: .button)["likeButton"]
		XCTAssertTrue(likeButton.waitForExistence(timeout: Appearance.timeOut), "кнопка не найдена")
		likeButton.tap()
		sleep(Appearance.sleep)

		// 4. Отменить лайк в ячейке верхней картинки
		likeButton.tap()
		sleep(Appearance.sleep)

		// 5. Нажать на верхнюю ячейку
		cellToLike.tap()

		// 6. Подождать, пока картинка открывается на весь экран
		sleep(Appearance.sleep)

		let image = app.scrollViews.images.element(boundBy: 0)
		XCTAssertTrue(image.waitForExistence(timeout: Appearance.timeOut), "фото не найдено")

		// 7. Увеличить картинку
		image.pinch(withScale: 3, velocity: 1) // zoom in
		sleep(Appearance.sleep)

		// 8. Уменьшить картинку
		image.pinch(withScale: 0.5, velocity: -1)
		sleep(Appearance.sleep)

		// 9. Вернуться на экран ленты
		let backButton = app.buttons["backButton"]
		XCTAssertTrue(backButton.waitForExistence(timeout: Appearance.timeOut), "кнопка не найдена")
		backButton.tap()
	}

	func testProfile() throws {
		// тестируем сценарий профиля

		// Подождать, пока открывается и загружается экран ленты
		// Перейти на экран профиля
		// Проверить, что на нём отображаются ваши персональные данные
		// Нажать кнопку логаута
		// Проверить, что открылся экран авторизации

		// 1. Подождать, пока открывается и загружается экран ленты
		let tabBarProfile = app.tabBars.buttons.element(boundBy: 1)
		XCTAssertTrue(tabBarProfile.waitForExistence(timeout: Appearance.timeOut), "вкладка не найдена")

		// 2. Перейти на экран профиля
		tabBarProfile.tap()

		// 3. Проверить, что на нём отображаются ваши персональные данные
		XCTAssertTrue(app.staticTexts["nameLabel"].exists, "метка для имени не найдена")

		// 4. Нажать кнопку логаута
		let logoutButton = app.buttons["logoutButton"]
		XCTAssertTrue(logoutButton.waitForExistence(timeout: Appearance.timeOut), "кнопка не найдена")
		logoutButton.tap()

		let alert = app.alerts.firstMatch
		XCTAssertTrue(alert.waitForExistence(timeout: Appearance.timeOut), "алерт не найден")

		let buttonYes = alert.buttons.element(boundBy: 1)
		XCTAssertTrue(buttonYes.waitForExistence(timeout: Appearance.timeOut), "кнопка не найдена")
		XCTAssertTrue(buttonYes.firstMatch.label == "Да", "найдена не та кнопка")
		buttonYes.tap()

		// 5. Проверить, что открылся экран авторизации
		let loginButton = app.buttons.firstMatch
		XCTAssertTrue(loginButton.waitForExistence(timeout: Appearance.timeOut), "кнопка авторизации не найдена")
		XCTAssertTrue(loginButton.firstMatch.label == "Войти", "найдена не та кнопка")
	}
}

extension Image_FeedUITests {
	enum Appearance {
		static let login = ""
		static let password = ""
		static let timeOut = 5.0
		static let sleep: UInt32 = 2
	}
}
