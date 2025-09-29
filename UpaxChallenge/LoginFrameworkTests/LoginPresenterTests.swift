//
//  LoginPresenterTests.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 28/09/25.
//

import XCTest
@testable import LoginFramework

// MARK: - Mocks
final class MockLoginView: LoginViewProtocol {
    var showErrorMessage: String?
    var hideLoaderCalled = false
    var showSuccessCalled = false
    var showLoaderCalled = false
    
    func showError(message: String) {
        showErrorMessage = message
    }
    
    func hideLoader() {
        hideLoaderCalled = true
    }
    
    func showSuccess(message: String) {
        showSuccessCalled = true
    }
    
    func showLoader() {
        showLoaderCalled = true
    }
}

final class MockLoginInteractor: LoginInteractorProtocol {
    var loginCalled = false
    var registerCalled = false
    var usernamePassed: String?
    var passwordPassed: String?
    
    func login(username: String, password: String) {
        loginCalled = true
        usernamePassed = username
        passwordPassed = password
    }
    
    func register(username: String, password: String) {
        registerCalled = true
        usernamePassed = username
        passwordPassed = password
    }
}

final class MockLoginWireframe: LoginWireframeProtocol {
    var navigateCalled = false
    
    func navigateToPokemonHome() {
        navigateCalled = true
    }
}

final class LoginPresenterTests: XCTestCase {
    var presenter: LoginPresenter!
    var mockView: MockLoginView!
    var mockInteractor: MockLoginInteractor!
    var mockWireframe: MockLoginWireframe!
    
    override func setUp() {
        super.setUp()
        presenter = LoginPresenter()
        mockView = MockLoginView()
        mockInteractor = MockLoginInteractor()
        mockWireframe = MockLoginWireframe()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.wireframe = mockWireframe
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockWireframe = nil
        
        super.tearDown()
    }
    
    // MARK: - Login
    
    func test_login_withNilFields_shouldShowError() {
        presenter.login(username: nil, password: nil)
        
        XCTAssertEqual(mockView.showErrorMessage, "Empty fields")
        XCTAssertFalse(mockInteractor.loginCalled)
    }
    
    func test_login_withValidFields_shouldCallInteractorAndHideLoader() {
        presenter.login(username: "ash", password: "pikachu")
        
        XCTAssertTrue(mockInteractor.loginCalled)
        XCTAssertEqual(mockInteractor.usernamePassed, "ash")
        XCTAssertEqual(mockInteractor.passwordPassed, "pikachu")
        XCTAssertTrue(mockView.hideLoaderCalled)
    }
    
    // MARK: - Register
    
    func test_register_withNilFields_shouldShowError() {
        presenter.register(username: nil, password: nil)
        
        XCTAssertEqual(mockView.showErrorMessage, "Empty fields")
        XCTAssertFalse(mockInteractor.registerCalled)
    }
    
    func test_register_withValidFields_shouldCallInteractorAndHideLoader() {
        presenter.register(username: "misty", password: "starmie")
        
        XCTAssertTrue(mockInteractor.registerCalled)
        XCTAssertEqual(mockInteractor.usernamePassed, "misty")
        XCTAssertEqual(mockInteractor.passwordPassed, "starmie")
        XCTAssertTrue(mockView.hideLoaderCalled)
    }
    
    // MARK: - Login Result
    
    func test_loginSucceeded_shouldNavigateToPokemonHome() {
        let user = User(username: "brock", password: "onix")
        
        presenter.loginSucceeded(user: user)
        
        XCTAssertTrue(mockWireframe.navigateCalled)
    }
    
    func test_loginFailed_shouldShowErrorMessage() {
        presenter.loginFailed(error: "User or password incorrect")
        
        XCTAssertEqual(mockView.showErrorMessage, "User or password incorrect")
    }
}
