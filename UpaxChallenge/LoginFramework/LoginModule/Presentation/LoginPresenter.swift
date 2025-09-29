//
//  LoginPresenter.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

final class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol?
    var wireframe: LoginWireframeProtocol?
    
    init() { }
    
    func login(username: String?, password: String?) {
        guard let username = username, let password = password else {
            view?.showError(message: "Empty fields")
            
            return
        }
        
        interactor?.login(username: username, password: password)
        view?.hideLoader()
    }
    
    func register(username: String?, password: String?) {
        guard let username = username, let password = password else {
            view?.showError(message: "Empty fields")
            
            return
        }
        
        interactor?.register(username: username, password: password)
        view?.hideLoader()
    }
    
    func loginSucceeded(user: User) {
        wireframe?.navigateToPokemonHome()
    }
    
    func loginFailed(error: String) {
        view?.showError(message: error)
    }
}
