//
//  PokedexPresenter.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

final class PokedexPresenter {
    weak var view: PokedexViewProtocol?
    var interactor: PokedexInteractorProtocol?
    var router: PokedexRouterProtocol?
    
    private var pokemons: [Pokemon] = []
    private var nextURL: String?
    
    init() {}
    
    func fetchSucceeded(pokemons: [Pokemon], nextURL: String?) {
        self.pokemons.append(contentsOf: pokemons)
        self.nextURL = nextURL
        
        view?.showPokemons(self.pokemons)
    }
    
    func fetchFailed(error: String) {
        view?.showError(error)
    }
}

extension PokedexPresenter: PokedexPresenterProtocol {
    func viewDidLoad() {
        interactor?.fetchPokemons(url: nil)
    }
    
    func loadMorePokemons() {
        interactor?.fetchPokemons(url: nextURL)
    }
    
    func navigateToPokemonDetail(pokemonID: Int) {
        router?.navigateToPokemonDetail(pokemonID: pokemonID)
    }
}
