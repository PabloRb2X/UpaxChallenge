//
//  PokedexWireframe.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import UIKit
import SwiftUI
import PokemonDetailFramework

public class PokedexWireframe {
    
    private var currentViewController: UIViewController?
    
    public static func createModule() -> UIViewController {
        let view = PokedexViewController()
        let presenter = PokedexPresenter()
        let interactor = PokedexInteractor()
        let wireframe = PokedexWireframe()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = wireframe
        interactor.presenter = presenter
        
        wireframe.currentViewController = view
        
        return view
    }
}

extension PokedexWireframe: PokedexRouterProtocol {
    public func navigateToPokemonDetail(pokemonID: Int) {
        let viewModel = PokemonDetailViewModel()
        let detailView = PokemonDetailView(viewModel: viewModel, pokemonID: pokemonID)
        let hostingController = UIHostingController(rootView: detailView)
        
        if let nav = currentViewController?.navigationController {
            nav.pushViewController(hostingController, animated: true)
        } else {
            currentViewController?.present(hostingController, animated: true)
        }
    }
}
