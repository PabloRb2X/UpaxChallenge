//
//  PokemonAPIService.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import Foundation
import Combine

public protocol PokemonAPIServiceInterface: AnyObject {
    func fetchPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, Error>
}

public final class PokemonAPIService: PokemonAPIServiceInterface {
    
    public init() { }

    public func fetchPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, Error> {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
            
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
