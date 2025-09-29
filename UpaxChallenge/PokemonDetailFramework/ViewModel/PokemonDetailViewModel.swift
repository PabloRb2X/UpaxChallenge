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
    @Published var pokemon: PokemonDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = PokemonAPIService()
    private var cancellables = Set<AnyCancellable>()
    
    public init() { }
    
    func fetchPokemon(id: Int) {
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
