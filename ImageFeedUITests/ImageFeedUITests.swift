//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Александр Кудряшов on 18.07.2023.
//

import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    
    //Это тестовый аккаунт, поэтому данные не удалены
    private let mail = "hogapak122@muzitp.com"
    private let password = "Qwerty1234"
    private let nameSurname = "Jonh Weak"
    private let userName = "@jonhweak"
    
    private let app = XCUIApplication() // переменная приложения

    override func setUpWithError() throws {

        continueAfterFailure = true // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так

        app.launch() //Запускаем приложение перед каждым тестом

    }
    //тестируем сценарий авторизации
    func testAuth() throws {
        
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"]
        sleep(2)
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
       
        // Ввести данные в форму
        let loginTexField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTexField.waitForExistence(timeout: 5))
        
        loginTexField.tap()
        loginTexField.typeText(mail)
        
        dismissKeyboard()
       // webView.swipeUp()
        sleep(2)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        sleep(2)
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        dismissKeyboard()
        //webView.swipeUp()
        sleep(2)
                
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        sleep(5)
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        sleep(3)
    }
    
    //тестируем сценарий ленты
    func testFeed() throws {
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables
        
        sleep(5)
        // Сделать жест «смахивания» вверх по экрану для его скролла
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)

        // Поставить лайк в ячейке верхней картинки
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

        cellToLike.buttons["LikeButtom"].tap()
        sleep(2)

        // Отменить лайк в ячейке верхней картинки
        cellToLike.buttons["LikeButtom"].tap()
        sleep(2)

        // Нажать на верхнюю ячейку
        cell.tap()
        
        // Подождать, пока картинка открывается на весь экран
        sleep(3)
        let image = app.scrollViews.images.element(boundBy: 0)
        
        // Увеличить картинку
        image.pinch(withScale: 3, velocity: 1)
        sleep(3)

        // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(3)
        
        // Вернуться на экран ленты
        let navBackButtonWhiteButton = app.buttons["singleViewBackButtom"] //уточнить название кнопки
        navBackButtonWhiteButton.tap()

    }
    
    //тестируем сценарий профиля
    func testProfile() throws {
        
        // Подождать, пока открывается и загружается экран ленты
        sleep(3)
        
        // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts[nameSurname].exists) //ввести свои данные
        XCTAssertTrue(app.staticTexts[userName].exists)
        
        // Нажать кнопку логаута
        app.buttons["logout button"].tap()
        
        // Проверить, что открылся экран авторизации
        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
    }
    
    func dismissKeyboard() {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Continiue"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }

}
