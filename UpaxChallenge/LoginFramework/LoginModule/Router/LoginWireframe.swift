//
//  LoginWireframe.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import UIKit
import PokedexFramework

public final class LoginWireframe {
    
    public weak var viewController: UIViewController?
    
    public init() {}
    
    public static func createModule() -> UIViewController {
        let view = LoginViewController()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let wireframe = LoginWireframe()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter
        wireframe.viewController = view
        
        return view
    }
}

extension LoginWireframe: LoginWireframeProtocol {
    public func navigateToPokemonHome() {
        let pokedexVC = PokedexWireframe.createModule()
        
        let backItem = UIBarButtonItem()
        viewController?.navigationController?.navigationItem.backBarButtonItem = backItem
        viewController?.navigationController?.pushViewController(pokedexVC, animated: true)
    }
}
