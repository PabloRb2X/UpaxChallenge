//
//  PokedexInteractor.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import Foundation

final class PokedexInteractor: PokedexInteractorProtocol {
    weak var presenter: PokedexPresenter?
    private var nextURL: String? = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20"
    
    init() {}
    
    func fetchPokemons(url: String? = nil) {
        let urlString = url ?? nextURL
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.presenter?.fetchFailed(error: error.localizedDescription)
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(PokemonResponse.self, from: data)
                self?.nextURL = response.next
                
                DispatchQueue.main.async {
                    self?.presenter?.fetchSucceeded(pokemons: response.results, nextURL: response.next)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.presenter?.fetchFailed(error: error.localizedDescription)
                }
            }
        }.resume()
    }
}
