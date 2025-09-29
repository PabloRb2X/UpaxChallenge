//
//  PokedexPresenterTests.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 28/09/25.
//

import XCTest
@testable import PokedexFramework

// MARK: - Mocks

final class MockPokedexView: PokedexViewProtocol {
    var pokemonsShown: [Pokemon]?
    var errorShown: String?

    func showPokemons(_ pokemons: [Pokemon]) {
        pokemonsShown = pokemons
    }

    func showError(_ message: String) {
        errorShown = message
    }
}

final class MockPokedexInteractor: PokedexInteractorProtocol {
    var lastFetchedURL: String?
    var fetchPokemonsCalled = false

    func fetchPokemons(url: String?) {
        fetchPokemonsCalled = true
        lastFetchedURL = url
    }
}

final class MockPokedexRouter: PokedexWireframeProtocol {
    var navigatedPokemonID: Int?

    static func createModule() -> UIViewController {
        return UIViewController()
    }

    func navigateToPokemonDetail(pokemonID: Int) {
        navigatedPokemonID = pokemonID
    }
}

// MARK: - Tests

final class PokedexPresenterTests: XCTestCase {
    var presenter: PokedexPresenter!
    var mockView: MockPokedexView!
    var mockInteractor: MockPokedexInteractor!
    var mockRouter: MockPokedexRouter!

    override func setUp() {
        super.setUp()
        presenter = PokedexPresenter()
        mockView = MockPokedexView()
        mockInteractor = MockPokedexInteractor()
        mockRouter = MockPokedexRouter()

        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func test_viewDidLoad_shouldCallFetchPokemons() {
        // When
        presenter.viewDidLoad()

        // Then
        XCTAssertTrue(mockInteractor.fetchPokemonsCalled)
        XCTAssertNil(mockInteractor.lastFetchedURL)
    }

    func test_loadMorePokemons_shouldCallFetchWithNextURL() {
        // Given
        let fakePokemons = [Pokemon(name: "pikachu", url: "url1")]
        presenter.fetchSucceeded(pokemons: fakePokemons, nextURL: "nextURL")
        mockInteractor.fetchPokemonsCalled = false
        mockInteractor.lastFetchedURL = nil

        // When
        presenter.loadMorePokemons()

        // Then
        XCTAssertTrue(mockInteractor.fetchPokemonsCalled)
        XCTAssertEqual(mockInteractor.lastFetchedURL, "nextURL")
    }

    func test_fetchSucceeded_shouldAppendPokemonsAndNotifyView() {
        // Given
        let firstBatch = [Pokemon(name: "bulbasaur", url: "url1")]
        let secondBatch = [Pokemon(name: "charmander", url: "url2")]

        // When
        presenter.fetchSucceeded(pokemons: firstBatch, nextURL: "urlA")
        presenter.fetchSucceeded(pokemons: secondBatch, nextURL: "urlB")

        // Then
        XCTAssertEqual(mockView.pokemonsShown?.count, 2)
        XCTAssertEqual(mockView.pokemonsShown?.first?.name, "bulbasaur")
        XCTAssertEqual(mockView.pokemonsShown?.last?.name, "charmander")
    }

    func test_fetchFailed_shouldNotifyViewWithError() {
        // When
        presenter.fetchFailed(error: "network error")

        // Then
        XCTAssertEqual(mockView.errorShown, "network error")
    }

    func test_navigateToPokemonDetail_shouldCallRouter() {
        // When
        presenter.navigateToPokemonDetail(pokemonID: 25)

        // Then
        XCTAssertEqual(mockRouter.navigatedPokemonID, 25)
    }
}
