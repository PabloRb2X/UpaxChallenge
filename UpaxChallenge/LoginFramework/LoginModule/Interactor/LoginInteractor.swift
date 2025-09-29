//
//  LoginInteractor.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import CoreData

final class LoginInteractor {
    
    weak var presenter: LoginPresenter?
    private let context = CoreDataManager.shared.context
    
    init() {}
}

extension LoginInteractor: LoginInteractorProtocol {
    func login(username: String, password: String) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let result = try context.fetch(request)
            if let userEntity = result.first {
                let user = User(username: userEntity.username ?? "", password: userEntity.password ?? "")
                presenter?.loginSucceeded(user: user)
            } else {
                presenter?.loginFailed(error: "User or password incorrect")
            }
        } catch {
            presenter?.loginFailed(error: "Error to validate the user")
        }
    }
    
    func register(username: String, password: String) {
        guard !username.isEmpty, !password.isEmpty else {
            presenter?.loginFailed(error: "User or password cannot be empty")
            
            return
        }
        
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let result = try context.fetch(request)
            if !result.isEmpty {
                presenter?.loginFailed(error: "The user exists!")
                
                return
            }
            
            let newUser = UserEntity(context: context)
            newUser.username = username
            newUser.password = password
            try context.save()
            
            presenter?.loginSucceeded(user: User(username: username, password: password))
            
        } catch {
            presenter?.loginFailed(error: "Error to register the user")
        }
    }
}
