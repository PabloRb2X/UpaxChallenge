//
//  LoginInteractorTests.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 28/09/25.
//

import XCTest
import CoreData
@testable import LoginFramework

// MARK: - Mock Presenter
final class MockLoginPresenter: LoginPresenter {
    var loginSucceededCalled = false
    var loginFailedMessage: String?
    var userPassed: User?

    override func loginSucceeded(user: User) {
        loginSucceededCalled = true
        userPassed = user
    }
    
    override func loginFailed(error: String) {
        loginFailedMessage = error
    }
}

// MARK: - In-Memory Core Data Manager

final class InMemoryCoreDataManager {
    static func makeContainer() -> NSPersistentContainer {
        let testBundle = Bundle(for: InMemoryCoreDataManager.self)
        let frameworkBundle = Bundle(for: CoreDataManager.self)

        let modelURL = testBundle.url(forResource: "LoginModel", withExtension: "momd")
            ?? frameworkBundle.url(forResource: "LoginModel", withExtension: "momd")

        guard let url = modelURL,
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("❌ No se encontró LoginModel.momd en ningún bundle")
        }

        let container = NSPersistentContainer(name: "LoginModel", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Error al cargar in-memory store: \(error)")
            }
        }

        return container
    }
}

// MARK: - Tests
final class LoginInteractorTests: XCTestCase {
    var interactor: LoginInteractor!
    var mockPresenter: MockLoginPresenter!
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        
        container = InMemoryCoreDataManager.makeContainer()
        context = container.viewContext
        
        mockPresenter = MockLoginPresenter()
        interactor = LoginInteractor()
        interactor.presenter = mockPresenter
        
        interactor.setContextForTesting(context)
    }

    override func tearDown() {
        context.reset()
        interactor = nil
        mockPresenter = nil
        container = nil
        context = nil
        
        super.tearDown()
    }
    
    // MARK: - Register Tests
    func test_register_shouldSaveNewUser() {
        // Given
        interactor.register(username: "ash", password: "pikachu")
        
        XCTAssertTrue(mockPresenter.loginSucceededCalled)
        XCTAssertEqual(mockPresenter.userPassed?.username, "ash")
        
        // When
        let fetch: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let results = try? context.fetch(fetch)
        
        // Then
        XCTAssertEqual(results?.count, 1)
    }
    
    func test_register_existingUser_shouldFail() {
        // Given
        let user = UserEntity(context: context)
        user.username = "misty"
        user.password = "starmie"
        try? context.save()
        
        // When
        interactor.register(username: "misty", password: "newpass")
        
        // Then
        XCTAssertEqual(mockPresenter.loginFailedMessage, "Error to register the user")
    }
    
    func test_register_emptyFields_shouldFail() {
        interactor.register(username: "", password: "")
        
        XCTAssertEqual(mockPresenter.loginFailedMessage, "User or password cannot be empty")
    }
    
    // MARK: - Login Tests
    func test_login_withCorrectCredentials_shouldSucceed() {
        // Given
        let user = UserEntity(context: context)
        user.username = "brock"
        user.password = "onix"
        try? context.save()
        
        // When
        interactor.login(username: "brock", password: "onix")
        
        // Then
        XCTAssertTrue(mockPresenter.loginSucceededCalled)
        XCTAssertEqual(mockPresenter.userPassed?.username, "brock")
    }
    
    func test_login_withWrongPassword_shouldFail() {
        // Given
        let user = UserEntity(context: context)
        user.username = "gary"
        user.password = "eevee"
        try? context.save()
        
        // When
        interactor.login(username: "gary", password: "wrongpass")
        
        // Then
        XCTAssertEqual(mockPresenter.loginFailedMessage, "User or password incorrect")
    }
    
    func test_login_withNonExistentUser_shouldFail() {
        interactor.login(username: "notfound", password: "1234")
        
        XCTAssertEqual(mockPresenter.loginFailedMessage, "User or password incorrect")
    }
}
