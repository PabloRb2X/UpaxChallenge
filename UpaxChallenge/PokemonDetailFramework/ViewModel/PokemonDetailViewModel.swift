//
//  PokemonDetailViewModel.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import Foundation
import Combine
import SwiftUI

public final class PokemonDetailViewModel: ObservableObject {
    @Published public var pokemon: PokemonDetail?
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    public let service: PokemonAPIServiceInterface
    private var cancellables = Set<AnyCancellable>()
    
    public init(service: PokemonAPIServiceInterface = PokemonAPIService()) {
        self.service = service
    }
    
    public func fetchPokemon(id: Int) {
        isLoading = true
        errorMessage = nil
        
        service.fetchPokemonDetail(id: id)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                
                self?.isLoading = false
            } receiveValue: { [weak self] detail in
                self?.pokemon = detail
            }
            .store(in: &cancellables)
    }
}
