//
//  PokedexInterfaces.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import UIKit
 
protocol PokedexViewProtocol: AnyObject {
    func showPokemons(_ pokemons: [Pokemon])
    func showError(_ message: String)
}

protocol PokedexPresenterProtocol: AnyObject {
    func viewDidLoad()
    func loadMorePokemons()
    func navigateToPokemonDetail(pokemonID: Int)
}

protocol PokedexInteractorProtocol: AnyObject {
    func fetchPokemons(url: String?)
}

public protocol PokedexWireframeProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToPokemonDetail(pokemonID: Int)
}
