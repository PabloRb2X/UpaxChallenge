//
//  PokedexInteractorTests.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 28/09/25.
//

import XCTest
@testable import PokedexFramework

// MARK: - Mocks 

final class MockPresenterForInteractor: PokedexPresenter {
    var fetchSucceededCalled = false
    var fetchFailedCalled = false
    var pokemonsPassed: [Pokemon]?
    var nextURLPassed: String?
    var errorPassed: String?

    override func fetchSucceeded(pokemons: [Pokemon], nextURL: String?) {
        fetchSucceededCalled = true
        pokemonsPassed = pokemons
        nextURLPassed = nextURL
    }

    override func fetchFailed(error: String) {
        fetchFailedCalled = true
        errorPassed = error
    }
}

final class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var stubError: Error?

    override class func canInit(with request: URLRequest) -> Bool { return true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { return request }

    override func startLoading() {
        if let error = MockURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = MockURLProtocol.stubResponseData {
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() { }
}

// MARK: - Interactor Tests

final class PokedexInteractorTests: XCTestCase {
    var interactor: PokedexInteractor!
    var mockPresenter: MockPresenterForInteractor!
    var session: URLSession!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)

        interactor = PokedexInteractor(session: session)
        mockPresenter = MockPresenterForInteractor()
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        session = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        
        super.tearDown()
    }

    func test_fetchPokemons_success_shouldCallFetchSucceeded() throws {
        // Given
        let fakeResponse = PokemonResponse(
            results: [Pokemon(name: "pikachu", url: "url1")],
            next: "nextURL"
        )
        let data = try JSONEncoder().encode(fakeResponse)
        MockURLProtocol.stubResponseData = data

        // When
        let expectation = self.expectation(description: "fetch success")
        interactor.fetchPokemons(url: "https://fakeurl.com")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // Then
            
            XCTAssertTrue(self.mockPresenter.fetchSucceededCalled)
            XCTAssertEqual(self.mockPresenter.pokemonsPassed?.count, 1)
            XCTAssertEqual(self.mockPresenter.pokemonsPassed?.first?.name, "pikachu")
            XCTAssertEqual(self.mockPresenter.nextURLPassed, "nextURL")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }

    func test_fetchPokemons_failure_shouldCallFetchFailed() {
        // Given
        MockURLProtocol.stubError = NSError(domain: "test", code: 1, userInfo: nil)

        // When
        let expectation = expectation(description: "fetch failure")
        interactor.fetchPokemons(url: "https://fakeurl.com")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // Then
            
            XCTAssertTrue(self.mockPresenter.fetchFailedCalled)
            XCTAssertNotNil(self.mockPresenter.errorPassed)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }

    func test_fetchPokemons_invalidData_shouldCallFetchFailed() {
        // Given
        MockURLProtocol.stubResponseData = "invalid json".data(using: .utf8)

        // When
        let expectation = self.expectation(description: "invalid data")
        interactor.fetchPokemons(url: "https://fakeurl.com")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // Then
            
            XCTAssertTrue(self.mockPresenter.fetchFailedCalled)
            XCTAssertNotNil(self.mockPresenter.errorPassed)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}
