//
//  PokemonDetailViewModelTests.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 28/09/25.
//

import XCTest
import Combine
@testable import PokemonDetailFramework

// MARK: - Mock Service

final class MockPokemonAPIService: PokemonAPIServiceInterface {
    var result: Result<PokemonDetail, Error>?

    func fetchPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, Error> {
        guard let result = result else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return result
            .publisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - ViewModel Tests

final class PokemonDetailViewModelTests: XCTestCase {
    var viewModel: PokemonDetailViewModel!
    var mockService: MockPokemonAPIService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockPokemonAPIService()
        viewModel = PokemonDetailViewModel(service: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchPokemon_success_shouldUpdatePokemon() {
        // Given
        let expectedPokemon = PokemonDetail(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            sprites: PokemonDetail.Sprites(frontDefault: "url"),
            types: [],
            stats: []
        )
        mockService.result = .success(expectedPokemon)
        
        let expectationPokemon = expectation(description: "pokemon updated")
        let expectationLoading = expectation(description: "loading updated")
        
        viewModel.$pokemon
            .dropFirst()
            .sink { pokemon in
                XCTAssertEqual(pokemon?.name, "bulbasaur")
                expectationPokemon.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading { expectationLoading.fulfill() }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.fetchPokemon(id: 1)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetchPokemon_failure_shouldUpdateErrorMessage() {
        // Given
        mockService.result = .failure(URLError(.notConnectedToInternet))
        let expectationError = expectation(description: "error updated")
        
        var capturedErrors: [String?] = []
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                capturedErrors.append(error)
                if error != nil {
                    expectationError.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.fetchPokemon(id: 1)
        
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertEqual(capturedErrors.last, URLError(.notConnectedToInternet).localizedDescription)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.pokemon)
    }

    func test_isLoading_shouldBeTrueWhileFetching() {
        // Given
        mockService.result = .success(PokemonDetail(
            id: 1, name: "pikachu", height: 4, weight: 60,
            sprites: PokemonDetail.Sprites(frontDefault: "url"), types: [], stats: []
        ))
        let expectationLoading = expectation(description: "loading updated")
        
        var loadingValues: [Bool] = []
        viewModel.$isLoading
            .sink { loading in
                loadingValues.append(loading)
                if loadingValues.count >= 2 {
                    expectationLoading.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.fetchPokemon(id: 1)
        
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertEqual(loadingValues.first, false)
        XCTAssertEqual(loadingValues.last, true)
    }
}
