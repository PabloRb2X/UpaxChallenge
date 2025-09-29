//
//  LoginInterfaces.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

protocol LoginViewProtocol: AnyObject {
    func showError(message: String)
    func showSuccess(message: String)
    func showLoader()
    func hideLoader()
}

protocol LoginPresenterProtocol: AnyObject {
    func login(username: String?, password: String?)
    func register(username: String?, password: String?)
}

protocol LoginInteractorProtocol: AnyObject {
    func login(username: String, password: String)
    func register(username: String, password: String)
}

public protocol LoginWireframeProtocol: AnyObject {
    func navigateToPokemonHome()
}
